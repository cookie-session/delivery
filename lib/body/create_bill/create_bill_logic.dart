import 'dart:io';
import 'dart:math';

import 'package:bot_toast/bot_toast.dart';
import 'package:delivery_win/bill_model.dart';
import 'package:delivery_win/body/bill_view_page/bill_view_page_logic.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'create_bill_state.dart';
import 'package:path/path.dart';
class CreateBillLogic extends GetxController {
  final CreateBillState state = CreateBillState();



  selectPaymentMethod(String value){
    print(value);
    state.dropdownMenu.value = value;
    update();
  }


  ///写入表单
  saveBill() async {


    int now =  DateTime.now().millisecondsSinceEpoch;

    var databaseFactory = databaseFactoryFfi;
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "delivery_db");
    var db = await databaseFactory.openDatabase(path);
    String sn = getSn();
    Map<String, dynamic> saveData = {
      'sendUserName': state.sendUserNameController.text,
      'sendUserPhone': state.sendPhoneController.text,
      'getUserName': state.getUserNameController.text,
      'getUserPhone': state.getPhoneController.text,
      'getUserAddress': state.getAddressController.text,
      'getCount': state.getCountController.text,
      'paymentMethod': state.dropdownMenu.value,
      'status': 1,
      'freight': state.freightController.text,
      'createTime': now,
      'sn': sn
    };

    var installResult = await db.insert('bill', saveData);
    if(installResult == 0){
      BotToast.showText(text: '本地数据存储失败,请联系管理员');
    }else{
      var billLogic = Get.find<BillViewPageLogic>();

      Map<String, dynamic> saveLocalData = {
        'id':installResult,
        'sendUserName': state.sendUserNameController.text,
        'sendUserPhone': state.sendPhoneController.text,
        'getUserName': state.getUserNameController.text,
        'getUserPhone': state.getPhoneController.text,
        'getUserAddress': state.getAddressController.text,
        'getCount': state.getCountController.text,
        'paymentMethod': state.dropdownMenu.value,
        'status': 1,
        'freight': state.freightController.text,
        'createTime': now,
        'sn': sn
      };
      billLogic.state.listData.insert(0, BillModel.fromJson(saveLocalData));
      billLogic.update();
      BotToast.showText(text: '保存成功');
      state.sendUserNameController.clear();
      state.sendPhoneController.clear();
      state.getUserNameController.clear();
      state.getPhoneController.clear();
      state.getAddressController.clear();
      state.getCountController.clear();
      state.freightController.clear();
    }
  }


  String getSn(){
    String randomStr = Random().nextInt(5).toString();
    for(var i = 0; i < 5; i++){
      var str = Random().nextInt(5);
      randomStr = "$randomStr$str";
    }
    var timeNumber = DateTime.now();
    var sn = "YDT${timeNumber.year}${timeNumber.month}${timeNumber.day}$randomStr";
    return sn;
  }



}
