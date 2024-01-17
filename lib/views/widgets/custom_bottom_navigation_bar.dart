import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:whip_up/views/utils/AppColor.dart';
import 'package:provider/provider.dart';
import '../screens/notification_provider.dart';
import 'package:badges/badges.dart' as badges; // Alias 'badges' for Badge from the badges package



class CustomBottomNavigationBar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  CustomBottomNavigationBar({required this.selectedIndex, required this.onItemTapped});

  @override
  _CustomBottomNavigationBarState createState() => _CustomBottomNavigationBarState();
}
class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 30, right: 30, bottom: 40),
      color: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: SizedBox(
          height: 70,
          child: BottomNavigationBar(
            currentIndex: widget.selectedIndex,
            onTap: widget.onItemTapped,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            elevation: 0,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: _navBarIcon('assets/icons/home.svg', widget.selectedIndex == 0),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: _navBarIcon('assets/icons/add-document.svg', widget.selectedIndex == 1),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: _navBarIcon('assets/icons/notebook.svg', widget.selectedIndex == 2),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: _navBarIcon('assets/icons/bookmark.svg', widget.selectedIndex == 3),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: _notificationIcon(),
                label: '',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navBarIcon(String asset, bool isSelected) {
    return SvgPicture.asset(
      asset,
      color: isSelected ? Colors.grey.shade800 : Colors.grey[600],
      height: 22,
      width: 24,
    );
  }

  // Widget _notificationIcon() {
  //   return Consumer<NotificationProvider>(
  //     builder: (_, notifier, __) {
  //       return badges.Badge(
  //         showBadge: notifier.unreadCount > 0,
  //         badgeContent: Text(
  //           notifier.unreadCount.toString(),
  //           style: TextStyle(color: Colors.white, fontSize: 10),
  //         ),
  //         child: SvgPicture.asset(
  //           widget
  //               .selectedIndex == 4 ? 'assets/icons/bell-solid.svg' : 'assets/icons/bell-regular.svg',
  //           color: widget.selectedIndex == 4 ? Colors.grey.shade800 : Colors.grey[600],
  //           height: 22,
  //           width: 24,
  //         ),
  //       );
  //     },
  //   );
  // }
  Widget _notificationIcon() {
    return Consumer<NotificationProvider>(
      builder: (_, notifier, __) {
        return GestureDetector(
          onTap: () {
            // Handle the icon press, like navigating to the notifications screen
          },
          child: badges.Badge(
            showBadge: notifier.unreadCount > 0,
            badgeContent: Text(
              notifier.unreadCount.toString(),
              style: TextStyle(color: Colors.white, fontSize: 10),
            ),
            child: SvgPicture.asset(
              widget.selectedIndex == 4 ? 'assets/icons/bell-solid.svg' : 'assets/icons/bell-regular.svg',
              color: widget.selectedIndex == 4 ? Colors.grey.shade800 : Colors.grey[600],
              height: 22,
              width: 24,
            ),
          ),
        );
      },
    );
  }

}