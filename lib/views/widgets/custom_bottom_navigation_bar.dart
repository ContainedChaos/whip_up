import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:whip_up/views/utils/AppColor.dart';

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
      padding: EdgeInsets.only(left: 60, right: 60, bottom: 20),
      color: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: SizedBox(
          height: 70,
          child: BottomNavigationBar(
            currentIndex: widget.selectedIndex,
            onTap: (index) {
              widget.onItemTapped(index);
            },
            showSelectedLabels: false,
            showUnselectedLabels: false,
            elevation: 0,
            items: [
              (widget.selectedIndex == 0)
                  ? BottomNavigationBarItem(icon: SvgPicture.asset('assets/icons/home-filled.svg', color: AppColor.primary), label: '')
                  : BottomNavigationBarItem(icon: SvgPicture.asset('assets/icons/home.svg', color: Colors.grey[600]), label: ''),
              (widget.selectedIndex == 1)
                  ? BottomNavigationBarItem(icon: SvgPicture.asset('assets/icons/add-document-filled.svg', color: AppColor.primary, height: 22, width: 24), label: '')
                  : BottomNavigationBarItem(icon: SvgPicture.asset('assets/icons/add-document.svg', color: Colors.grey[600], height: 22, width: 24), label: ''),
              (widget.selectedIndex == 2)
                  ? BottomNavigationBarItem(icon: SvgPicture.asset('assets/icons/notebook.svg', color: AppColor.primary), label: '')
                  : BottomNavigationBarItem(icon: SvgPicture.asset('assets/icons/fire-filled.svg', color: Colors.grey[600]), label: ''),
              (widget.selectedIndex == 3)
                  ? BottomNavigationBarItem(icon: SvgPicture.asset('assets/icons/bookmark-filled.svg', color: AppColor.primary), label: '')
                  : BottomNavigationBarItem(icon: SvgPicture.asset('assets/icons/bookmark.svg', color: Colors.grey[600]), label: ''),
            ],
          ),
        ),
      ),
    );
  }
}
