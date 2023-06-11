import 'package:flutter/material.dart';
import 'package:my_pet_melody/ui/component/rounded_and_chained_list_tile.dart';
import 'package:my_pet_melody/ui/definition/list_tile_position_in_group.dart';

class RoundedSettingsListTile extends StatelessWidget {
  const RoundedSettingsListTile({
    required this.title,
    this.trailing,
    this.onTap,
    this.positionInGroup = ListTilePositionInGroup.only,
    Key? key,
  }) : super(key: key);

  final Widget title;
  final Widget? trailing;
  final VoidCallback? onTap;
  final ListTilePositionInGroup positionInGroup;

  @override
  Widget build(BuildContext context) {
    final body = Row(
      children: [
        Expanded(
          child: title,
        ),
        const SizedBox(width: 16),
        if (trailing != null) trailing!,
      ],
    );

    return RoundedAndChainedListTile(
      onTap: onTap,
      positionInGroup: positionInGroup,
      child: body,
    );
  }
}
