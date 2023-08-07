import 'package:blank_project/theme/app_colors.dart';
import 'package:blank_project/theme/app_text_style.dart';
import 'package:flutter/material.dart';

class MainBottomNavigationBar extends StatelessWidget {
  const MainBottomNavigationBar({
    Key? key,
    required this.currentPage,
    required this.onItemTap,
  }) : super(key: key);

  final int currentPage;
  final Function(int index) onItemTap;

  static const iconSize = 20.0;

  double getPadding(double displayWidth) {
    if (currentPage == 0) {
      return 0;
    } else if (currentPage == 1) {
      return displayWidth / 4;
    } else if (currentPage == 2) {
      return displayWidth / 2;
    } else {
      return displayWidth * 3 / 4;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BottomNavigationBar(
          elevation: 0,
          selectedFontSize: 0,
          type: BottomNavigationBarType.fixed,
          currentIndex: currentPage,
          onTap: onItemTap,
          selectedItemColor: AppColors.yellow,
          unselectedItemColor: AppColors.white,
          showUnselectedLabels: true,
          backgroundColor: AppColors.darkBlue,
          selectedLabelStyle: AppTextStyle.yellowH2,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              activeIcon: Icon(
                Icons.home,
                color: AppColors.yellow,
                size: iconSize,
              ),
              icon: Icon(
                Icons.home,
                color: AppColors.white,
                size: iconSize,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              activeIcon: Icon(
                Icons.margin,
                color: AppColors.yellow,
                size: iconSize,
              ),
              icon: Icon(
                Icons.margin,
                color: AppColors.white,
                size: iconSize,
              ),
              label: 'Assets',
            ),
            BottomNavigationBarItem(
              activeIcon: Icon(
                Icons.android_sharp,
                color: AppColors.yellow,
                size: iconSize,
              ),
              icon: Icon(
                Icons.android_sharp,
                color: AppColors.white,
                size: iconSize,
              ),
              label: 'Learn',
            ),
            BottomNavigationBarItem(
              activeIcon: Icon(
                Icons.settings,
                color: AppColors.yellow,
                size: iconSize,
              ),
              icon: Icon(
                Icons.settings,
                color: AppColors.white,
                size: iconSize,
              ),
              label: 'Account',
            ),
          ],
        ),
        Positioned(
          top: 0,
          child: Container(
            height: 1,
            width: MediaQuery.of(context).size.width,
            color: AppColors.mediumGrey,
          ),
        ),
        Positioned(
            top: 0,
            child: Container(
              margin: EdgeInsets.only(
                  left: getPadding(MediaQuery.of(context).size.width),
              ),
              height: 3,
              width: MediaQuery.of(context).size.width / 4,
              color: AppColors.yellow,
            ),
        )
      ],
    );
  }
}
