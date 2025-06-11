import 'package:flutter/material.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? upperTitle;
  final String? mainTitle;
  final IconData leadingIcon;
  final VoidCallback onLeadingTap;
  final IconData? actionIcon;
  final VoidCallback? onActionTap;
  final List<Widget>? actions;
  final double elevation;
  final double height;
  final Color leadingIconColor;
  final Color? actionIconColor;
  final TextStyle? upperTitleStyle;
  final TextStyle? mainTitleStyle;

  const CommonAppBar({
    Key? key,
    this.upperTitle,
    this.mainTitle,
    required this.leadingIcon,
    required this.onLeadingTap,
    this.actionIcon,
    this.onActionTap,
    this.actions,
    this.elevation = 0,
    this.height = kToolbarHeight,
    this.leadingIconColor = Colors.black,
    this.actionIconColor,
    this.upperTitleStyle,
    this.mainTitleStyle,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: elevation,
      centerTitle: true,
      leading: IconButton(
        icon: Icon(leadingIcon, color: leadingIconColor),
        onPressed: onLeadingTap,
      ),
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (upperTitle != null)
            Text(
              upperTitle!,
              style:
                  upperTitleStyle ??
                  const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          if (mainTitle != null)
            Text(
              mainTitle!,
              style:
                  mainTitleStyle ??
                  const TextStyle(
                    fontSize: 20,
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
            ),
        ],
      ),
      actions: [
        if (actionIcon != null)
          IconButton(
            icon: Icon(actionIcon, color: actionIconColor ?? Colors.black),
            onPressed: onActionTap,
          ),

        if (actions != null) ...actions!,
      ],
    );
  }
}
