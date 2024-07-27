import 'package:ai_sign_language_recognition/views/home/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget buildPage(int index) {
  List<Widget> _widget = [
    const HomeView(),
    Center(child: Text("Search")),
    Center(child: Text("Profile")),
  ];

  return _widget[index];
}

var bottomTabs = [
  BottomNavigationBarItem(
      label: "Home",
      icon: SizedBox(
        width: 15.w,
        height: 15.h,
        child: Icon(Icons.home), //Image.asset("assetst/icons/home.png"),
      )),
  BottomNavigationBarItem(
      label: "Search",
      icon: SizedBox(
        width: 15.w,
        height: 15.h,
        child: Icon(Icons.search), //Image.asset("assetst/icons/home.png"),
      )),
  BottomNavigationBarItem(
      label: "Profile",
      icon: SizedBox(
        width: 15.w,
        height: 15.h,
        child: Icon(Icons.person), //Image.asset("assetst/icons/home.png"),
      )),
];
