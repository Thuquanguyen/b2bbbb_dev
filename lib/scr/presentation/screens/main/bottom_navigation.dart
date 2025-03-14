import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:flutter/material.dart';
import 'package:b2b/scr/presentation/screens/main/tab_page.dart';
import 'package:b2b/utilities/image_helper/imagehelper.dart';
import 'package:flutter/services.dart';

class BottomNavigation extends StatelessWidget {
  const BottomNavigation(
      {Key? key, required this.selectedIndex, required this.onSelectPage})
      : super(key: key);
  final int selectedIndex;
  final ValueChanged<int> onSelectPage;

  Color _color(int index) =>
      selectedIndex == index ? Colors.green : Colors.grey;

  BottomNavigationBarItem _buildItem(int index, Map<String, dynamic> page) {
    // final Map<String, dynamic> page = TABS[index];
    return BottomNavigationBarItem(
      backgroundColor: Colors.transparent,
      icon: ImageHelper.loadFromAsset(page['icon'] as String,
          width: 20, height: 20, tintColor: _color(index)),
      label: (page['title'] as String).localized,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.grey.shade100,
      decoration: const BoxDecoration(
          // gradient: kGradientBackgroundH,
          border: Border(top: BorderSide(color: Colors.black12, width: 0.5))),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        selectedItemColor: Colors.green,
        selectedLabelStyle: TextStyles.itemText,
        unselectedLabelStyle: TextStyles.itemText,
        elevation: 0,
        unselectedItemColor: Colors.grey,
        currentIndex: selectedIndex,
        selectedFontSize: 12,
        mouseCursor: MouseCursor.uncontrolled,
        unselectedFontSize: 12,
        items: TABS
            .asMap()
            .entries
            .map((page) => _buildItem(page.key, page.value))
            .toList(),
        onTap: (index) {
          HapticFeedback.lightImpact();
          return onSelectPage(index);
        },
      ),
    );
  }
}
