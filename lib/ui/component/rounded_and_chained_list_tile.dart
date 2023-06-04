import 'package:flutter/material.dart';
import 'package:my_pet_melody/ui/definition/display_definition.dart';
import 'package:my_pet_melody/ui/definition/list_tile_position_in_group.dart';

class RoundedAndChainedListTile extends StatelessWidget {
  const RoundedAndChainedListTile({
    required this.child,
    this.onTap,
    this.positionInGroup = ListTilePositionInGroup.only,
    Key? key,
  }) : super(key: key);

  final Widget child;
  final VoidCallback? onTap;
  final ListTilePositionInGroup positionInGroup;

  @override
  Widget build(BuildContext context) {
    final BorderRadius borderRadius;
    switch (positionInGroup) {
      case ListTilePositionInGroup.first:
        borderRadius = const BorderRadius.only(
          topLeft: Radius.circular(
            DisplayDefinition.cornerRadiusSizeSmall,
          ),
          topRight: Radius.circular(
            DisplayDefinition.cornerRadiusSizeSmall,
          ),
        );
        break;
      case ListTilePositionInGroup.middle:
        borderRadius = BorderRadius.zero;
        break;
      case ListTilePositionInGroup.last:
        borderRadius = const BorderRadius.only(
          bottomLeft: Radius.circular(
            DisplayDefinition.cornerRadiusSizeSmall,
          ),
          bottomRight: Radius.circular(
            DisplayDefinition.cornerRadiusSizeSmall,
          ),
        );
        break;
      case ListTilePositionInGroup.only:
        borderRadius = const BorderRadius.all(
          Radius.circular(
            DisplayDefinition.cornerRadiusSizeSmall,
          ),
        );
    }

    final contents = ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 56),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        child: child,
      ),
    );

    final Widget foreground;
    if (onTap == null) {
      foreground = contents;
    } else {
      foreground = InkWell(
        onTap: onTap,
        child: contents,
      );
    }

    return ClipRRect(
      borderRadius: borderRadius,
      child: Material(
        color: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius,
        ),
        child: foreground,
      ),
    );
  }
}
