#!/bin/bash

# Flavor ごとの xcconfig を include するファイル
OUTPUT_FILE="${SRCROOT}/Flutter/DartDefines.xcconfig"

# Flutter 2.2 以降で必要な、Dart-Define のデコード処理
function decode_url() { echo "${*}" | base64 --decode; }

# 最初にファイル内容をいったん空にする
: > "$OUTPUT_FILE"

IFS=',' read -r -a define_items <<<"$DART_DEFINES"

for index in "${!define_items[@]}"
do
    item=$(decode_url "${define_items[$index]}")
    # Flavor が含まれる Dart-Define の場合
    is_flavor_item=$(echo "$item" | grep 'FLAVOR')
    if [ "$is_flavor_item" ]; then
        # Flavor の値を取得
        value=${item#*=}
        # Flavor に対応した xcconfig ファイルを include する
        echo "#include \"$value.xcconfig\"" >> "$OUTPUT_FILE"
    fi
done
