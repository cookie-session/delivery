
import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:delivery_win/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:path/path.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();

  var databaseFactory = databaseFactoryFfi;
  Directory documentsDirectory = await getApplicationDocumentsDirectory();
  String path = join(documentsDirectory.path, "delivery_db");
  databaseFactory.setDatabasesPath(path);
  bool databaseExistsStatus = await databaseFactory.databaseExists(path);
  ///数据库是否存在
  if(!databaseExistsStatus){
    var db = await databaseFactory.openDatabase(path);
    await db.execute('''
        CREATE TABLE bill (
          id INTEGER NOT NULL PRIMARY KEY,
          sendUserName TEXT NOT NULL,
          sendUserPhone TEXT NOT NULL,
          getUserName TEXT NOT NULL,
          getUserPhone TEXT NOT NULL,
          getUserAddress TEXT NOT NULL,
          getCount TEXT NOT NULL,
          paymentMethod TEXT NOT NULL,
          status INTEGER NOT NULL,
          freight INTEGER NOT NULL,
          createTime INTEGER NOT NULL,
          sn TEXT NOT NULL
        )''');
    db.close();
  }

  // db.close();

  // print('Using sqlite3 ${sqlite3.version}');
  // final db = sqlite3.openInMemory();
  // db.execute('''
  //   CREATE TABLE bill (
  //     id INTEGER NOT NULL PRIMARY KEY,
  //     sendUserName TEXT NOT NULL,
  //     sendUserPhone TEXT NOT NULL,
  //     getUserName TEXT NOT NULL,
  //     getUserPhone TEXT NOT NULL,
  //     getUserAddress TEXT NOT NULL,
  //     getCount TEXT NOT NULL,
  //     paymentMethod TEXT NOT NULL,
  //     status INTEGER NOT NULL,
  //     freight INTEGER NOT NULL,
  //     createTime INTEGER NOT NULL,
  //     sn TEXT NOT NULL
  //   )
  // ''');
  //
  // db.dispose();

  runApp(MyApp());
}



class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);


  final flutterSmart = FlutterSmartDialog.init();
  final bootToast = BotToastInit();


  // This widget is the root of your application.
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
