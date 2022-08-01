
import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:delivery_win/routes/app_pages.dart';
import 'package:delivery_win/util/db/DataDb.dart';
import 'package:delivery_win/util/shared_preferences.dart';
import 'package:delivery_win/util/sp_help.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:desktop_window/desktop_window.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DesktopWindow.setMinWindowSize(const Size(1400,800));
  SpHelp.sp = await SpUtil.getInstance();
  ///初始化数据库插件
  sqfliteFfiInit();
  ///初始化数据库
  await DBService.instance.initDB();

  runApp(MyApp());
}






class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final flutterSmart = FlutterSmartDialog.init();
  final bootToast = BotToastInit();

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(750, 1334),
      minTextAdapt: true,
      builder: (context , child){
        return GestureDetector(
          onTapDown: (TapDownDetails details){
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: GetMaterialApp(
            builder:  (context, widget){
              widget = flutterSmart(context, widget);
              widget = bootToast(context, widget);
              return widget;
            },
            navigatorObservers: [BotToastNavigatorObserver(),FlutterSmartDialog.observer],
            title: "壹点通同城配送",
            debugShowCheckedModeBanner: false,
            enableLog: true,
            initialRoute: AppPages.initPage,
            getPages: AppPages.routes,
            // unknownRoute: AppPages.unknownRoute,
            theme: ThemeData(
              splashColor: Colors.transparent, // 点击时的高亮效果设置为透明
              highlightColor: Colors.transparent, // 长按时的扩散效果设置为透明
            ),
          ),
        );
      },
    );
  }
}
