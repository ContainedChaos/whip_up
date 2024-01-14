import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:whip_up/views/utils/AppColor.dart';

import 'modals/search_filter_model.dart';

class DummySearchBar extends StatelessWidget {
  final VoidCallback routeTo; // Use VoidCallback here

  DummySearchBar({required this.routeTo});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: routeTo,
      child: Container(
        margin: EdgeInsets.only(top: 8),
        padding: EdgeInsets.symmetric(horizontal: 16),
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left side - Search Box
            Expanded(
              child: Container(
                height: 50,
                margin: EdgeInsets.only(right: 15),
                padding: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.grey.shade700),
                child: Row(
                  children: [
                    SvgPicture.asset('assets/icons/search.svg', color: Colors.white, height: 18, width: 18),
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Text(
                        'What do you want to eat?',
                        style: TextStyle(color: Colors.white.withOpacity(0.6)),
                      ),
                    )
                  ],
                ),
              ),
            ),
            // Right side - filter button
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
                    builder: (context) {
                      return SearchFilterModel();
                    });
              },
              child: Container(
                width: 50,
                height: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColor.secondary,
                ),
                child: SvgPicture.asset('assets/icons/magic.svg',
                    width: 25, // Set your desired width
                    height: 25,
                    color: Colors.black54
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

