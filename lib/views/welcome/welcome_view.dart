//import 'package:ai_sign_recognition/main.dart';
import 'package:ai_sign_language_recognition/common/routes/names.dart';
import 'package:ai_sign_language_recognition/common/values/constants/app_local_storage_constants.dart';
import 'package:ai_sign_language_recognition/global.dart';
import 'package:ai_sign_language_recognition/views/welcome/bloc/welcome_bloc.dart';

import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WelcomeView extends StatefulWidget {
  const WelcomeView({super.key});

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> {
  late PageController pageController;
  late int indicatorIndex;

  @override
  Widget build(BuildContext context) {
    final welcomeBloc = BlocProvider.of<WelcomeBloc>(context);
    return Container(
      color: Colors.white,
      child: Scaffold(
        body: BlocBuilder<WelcomeBloc, WelcomeState>(
          builder: (context, state) {
            if (state is WelcomePageDotsIndicatorIndexInitialState) {
              indicatorIndex = 0;
              pageController = PageController(initialPage: indicatorIndex);
            } else if (state is WelcomePageDotsIndicatorIndexChangedState) {
              indicatorIndex = state.indicatorIndex;
            }

            return Container(
              margin: EdgeInsets.only(top: 34.h),
              width: 375.w,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  PageView(
                    controller: pageController,
                    onPageChanged: (index) {
                      welcomeBloc.add(WelcomePageDotsIndicatorIndexChangeEvent(
                          indicatorIndex: index));
                    },
                    children: [
                      _page(1, context, "next", "Page 1 Title",
                          "Page 1 Subtitle", "/assets/images/image.png"),
                      _page(2, context, "next", "Page 2 Title",
                          "Page 2 Subtitle", "image path"),
                      _page(3, context, "next", "Page 3 Title",
                          "Page 3 Subtitle", "image path"),
                    ],
                  ),
                  Positioned(
                      bottom: 100.h,
                      child: DotsIndicator(
                        position: indicatorIndex,
                        dotsCount: 3,
                        mainAxisAlignment: MainAxisAlignment.center,
                        decorator: DotsDecorator(
                          color: Colors.grey,
                          size: const Size.square(8.0),
                          activeColor: Colors.blue,
                          activeSize: const Size(18, 8.0),
                          activeShape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                        ),
                      )),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _page(int index, BuildContext context, String buttonName, String title,
      String subTitle, String imagePath) {
    return Column(
      children: [
        SizedBox(
          width: 345.w,
          height: 345.w,
          child: const Text(
              "Image One"), //Image.asset(imagePath, fit: BoxFit.cover)
        ),
        Container(
          child: Text(
            title,
            style: TextStyle(
                color: Colors.black,
                fontSize: 24.sp,
                fontWeight: FontWeight.normal),
          ),
        ),
        Container(
          width: 375.w,
          padding: EdgeInsets.only(left: 30.w, right: 30.w),
          child: Text(
            subTitle,
            style: TextStyle(
                color: Colors.black.withOpacity(0.5),
                fontSize: 14.sp,
                fontWeight: FontWeight.normal),
          ),
        ),
        GestureDetector(
          onTap: () {
            if (index < 3) {
              pageController.animateToPage(index,
                  duration: const Duration(milliseconds: 130),
                  curve: Curves.easeIn);
            } else {
              //Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MyHomePage(title: "Test",)));
              Global.storageService
                  .setBool(AppConstants.STORAGE_APPLICATION_OPEN_FIRST_TIME, true);
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(AppRoutes.INITIAL, (route) => false);
            }
          },
          child: Container(
            margin: EdgeInsets.only(top: 100.h, left: 25.w, right: 25.w),
            width: 375.w,
            height: 50.h,
            decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.all(Radius.circular(15.w)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: Offset(0, 1))
                ]),
            child: Center(
              child: Text(
                buttonName,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.normal),
              ),
            ),
          ),
        )
      ],
    );
  }
}
