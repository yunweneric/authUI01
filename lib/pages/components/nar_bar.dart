import 'package:flutter/material.dart';
import 'package:flutter_open_animate/utils/theme.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class NavBar extends StatefulWidget {
  final void Function()? onToggle;
  const NavBar({super.key, required this.onToggle});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  List<String> navitems = ["About", "Home", "Store"];
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 50,
      top: 30,
      right: 50,
      child: Builder(builder: (context) {
        final theme = Provider.of<AppTheme>(context, listen: true);
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 0),
          child: TweenAnimationBuilder(
            key: ValueKey(theme.currentTheme),
            duration: const Duration(milliseconds: 1500),
            curve: Curves.easeInOutExpo,
            tween: Tween<double>(begin: 0, end: 1),
            builder: (context, value, child) {
              return Opacity(opacity: value, child: navBar(theme));
            },
          ),
        );
      }),
    );
  }

  Widget navBar(AppTheme theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Logo",
          style: TextStyle(color: Theme.of(context).primaryColorDark),
        ),
        Expanded(
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                navItem(title: 'Home'),
                navDivider(),
                navItem(title: 'About'),
                navDivider(),
                navItem(title: 'Store'),
              ],
            ),
          ),
        ),
        Row(
          children: [
            navItem(title: 'EN'),
            navDivider(width: 20),
            TweenAnimationBuilder(
              key: ValueKey(theme.currentTheme),
              tween: Tween<Offset>(
                begin: Offset(0, theme.currentTheme == AppTheme.light() ? 90 : -90),
                end: const Offset(0, 0),
              ),
              duration: const Duration(milliseconds: 1500),
              curve: Curves.easeInOutExpo,
              builder: ((context, value, child) {
                return Transform.translate(
                  offset: value,
                  child: Opacity(
                    opacity: (1 - value.dy / 50).clamp(0, 1),
                    child: InkWell(
                      onTap: () {
                        widget.onToggle!();
                      },
                      child: theme.currentTheme == AppTheme.dark()
                          ? SvgPicture.asset(
                              "assets/icons/moon.svg",
                              height: 25,
                              width: 25,
                              color: Theme.of(context).primaryColorDark,
                            )
                          : SvgPicture.asset(
                              "assets/icons/sun.svg",
                              height: 25,
                              width: 25,
                              color: Theme.of(context).primaryColorDark,
                            ),
                    ),
                  ),
                );
              }),
            ),
          ],
        )
      ],
    );
  }

  Widget navDivider({double? width}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      width: width ?? 40,
      height: 2,
      color: Theme.of(context).primaryColorDark,
    );
  }

  Widget navItem({required String title}) {
    return InkWell(
      onTap: () {},
      child: Text(
        title,
        style: TextStyle(color: Theme.of(context).primaryColorDark),
      ),
    );
  }
}
