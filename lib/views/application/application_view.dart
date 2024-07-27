import 'dart:developer';

import 'package:ai_sign_language_recognition/views/application/widgets/application_widgets.dart';
import 'package:ai_sign_language_recognition/views/application/bloc/app_blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ApplicationView extends StatefulWidget {
  const ApplicationView({super.key});

  @override
  State<ApplicationView> createState() => _ApplicationViewState();
}

class _ApplicationViewState extends State<ApplicationView> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBlocs, AppState>(
      builder: (context, state) {
        return Container(
          color: Colors.white,
          child: SafeArea(
            child: Scaffold(
                body: buildPage(state.index),
                bottomNavigationBar: Container(
                  width: 375.w,
                  height: 58.h,
                  decoration: BoxDecoration(color: Colors.blue, boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 1)
                  ]),
                  child: BottomNavigationBar(
                    currentIndex: state.index,
                    onTap: (value) {
                      log(value.toString());

                      context.read<AppBlocs>().add(AppInitializeEvent(index: value));
                    },
                    elevation: 0,
                    type: BottomNavigationBarType.fixed,
                    showSelectedLabels: true,
                    showUnselectedLabels: true,
                    selectedItemColor: Colors.blue,
                    unselectedItemColor: Colors.grey,
                    items: bottomTabs,
                  ),
                )),
          ),
        );
      },
    );
  }
}
