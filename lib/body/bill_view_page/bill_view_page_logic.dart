import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:delivery_win/bill_model.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'bill_view_page_state.dart';
import 'package:path/path.dart';
class BillViewPageLogic extends GetxController {
  final BillViewPageState state = BillViewPageState();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getBillListData();
  }



  getBillListData() async {
    var databaseFactory = databaseFactoryFfi;
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "delivery_db");
    var db = await databaseFactory.openDatabase(path);
    var result = await db.query('bill');
    if(result.isNotEmpty){
      for(int i = 0; i < result.length; i++){
        state.listData.add(BillModel.fromJson(result[i]));
      }
      update();
    }else{

    }
  }

  getDataBasePath() async {
    var databaseFactory = databaseFactoryFfi;

    BotToast.showText(text: '${await databaseFactory.getDatabasesPath()}');
    // var db = await databaseFactory.databaseExists(path) ///数据库是否存在
  }

}
