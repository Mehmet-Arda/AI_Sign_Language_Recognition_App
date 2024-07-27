import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

AppBar buildAppBar(String type) {
  return AppBar(
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Container(
          color: Colors.grey.withOpacity(0.5),
          height: 1.0,
        ),
      ),
      title: Center(
        child: Text(
          type,
          style: TextStyle(
              backgroundColor: Colors.yellow,
              color: Colors.black,
              fontSize: 16.sp,
              fontWeight: FontWeight.normal),
        ),
      ));
}

Widget buildThirdPartyLogin(BuildContext context) {
  return Container(
    margin: EdgeInsets.only(top: 40.h, bottom: 20.h),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _reusableIcons("google"),
        _reusableIcons("facebook"),
        _reusableIcons("cartcurt"),
      ],
    ),
  );
}

Widget _reusableIcons(String iconName) {
  return GestureDetector(
    onTap: () {},
    child: Container(
      width: 40.w,
      height: 40.w,
      child: Text(iconName), //Image.asset("assetst/icons/$iconName.png"),
    ),
  );
}

Widget reusableText(String text) {
  return Container(
    margin: EdgeInsets.only(bottom: 5.h),
    child: Text(
      text,
      style: TextStyle(
        color: Colors.grey.withOpacity(0.7),
        fontWeight: FontWeight.normal,
        fontSize: 14.sp,
      ),
    ),
  );
}

Widget buildTextField(String text, String textType,
    void Function(String value)? func, TextEditingController textController) {
  return Container(
      width: 325.w,
      height: 50.h,
      margin: EdgeInsets.only(bottom: 20.h),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.all(Radius.circular(15.w)),
        border: Border.all(color: Colors.black),
      ),
      child: Row(
        children: [
          Container(
              width: 16.w,
              margin: EdgeInsets.only(left: 17.w),
              height: 16.w,
              child: Text("I") //Image.asset("assets"),
              ),
          Container(
            width: 270.w,
            height: 50.h,
            child: TextField(
              controller: textController,
              keyboardType: textType == "email" ? TextInputType.emailAddress : TextInputType.none,
              obscureText: textType == "password" ? true : false,
              enableSuggestions: textType == "password" ? false : true,
              autocorrect: false,
              onChanged: (value) => func!(value),
            ),
          ),
        ],
      ));
}

Widget forgotPassword() {
  return Container(
    width: 260.w,
    height: 44.h,
    child: GestureDetector(
      onTap: () {},
      child: Text(
        "Forgot Password",
      ),
    ),
  );
}

Widget buildLogInAndRegButton(
    String buttonName, String buttonType, void Function()? func) {
  return GestureDetector(
    onTap: func,
    child: Container(
      width: 325.w,
      height: 50.h,
      decoration: BoxDecoration(color: Colors.blue),
      child: Center(child: Text(buttonName)),
    ),
  );
}
