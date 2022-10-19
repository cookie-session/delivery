import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:bot_toast/bot_toast.dart';
import 'package:delivery_win/bill_model.dart';
import 'package:delivery_win/body/bill_view_page/bill_view_page_logic.dart';
import 'package:delivery_win/util/db/DataDb.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'create_bill_state.dart';
import 'package:path/path.dart';
import 'package:sqflite_common/sqlite_api.dart';
class CreateBillLogic extends GetxController {
  final CreateBillState state = CreateBillState();

  //设置防抖周期为3s
  Duration durationTime = const Duration(milliseconds: 500);
  Timer? timer;

  selectPaymentMethod(String value){
    state.dropdownMenu.value = value;
    update();
  }


  ///写入表单
  saveBill() async {
    int now =  DateTime.now().millisecondsSinceEpoch;

    String sn = getSn();

    print('----------${state.printBillNumController.text.isEmpty ? "1" : state.printBillNumController.text}');

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
      'sn': sn,
      'printBillNum' : state.printBillNumController.text.isEmpty ? "1" : state.printBillNumController.text
    };

    print(saveData);

    //保存订单
    var installResult = await DBService.instance.database!.insert('bill', saveData);

    if(installResult == 0){
      BotToast.showText(text: '本地数据存储失败,请联系管理员');
    }else{

      /**
       * 保存发货人，收货人数据
       */
      ///发货人是否存在
      var sendUserDataSelect = await DBService.instance.database!.query('user', where: 'UserName = ?' , whereArgs: [state.sendUserNameController.text]);
      Map<String, dynamic> userDataSend = {
        "UserName" : state.sendUserNameController.text,
        "UserPhone" : state.sendPhoneController.text,
        "UserAddress" : "0",
        "createTime" : now,
      };
      if(sendUserDataSelect.isNotEmpty){ //存在--更新用户信息

        var updateUserDataResult = await DBService.instance.database!.update('user', userDataSend, where: "UserName = ?" , whereArgs: [state.sendUserNameController.text]);
        if(updateUserDataResult == 0){
          BotToast.showText(text: '更新用户数据----收货人数据更新失败');
          print('更新用户数据----收货人数据更新失败');
        }
      }
      else{ //插入用户信息
        var saveUserDataResult = await DBService.instance.database!.insert('user', userDataSend);
        if(saveUserDataResult == 0){
          print('新用户插入成功');
        }
      }

      ///收货人是否存在
      var getUserDataSelect = await DBService.instance.database!.query('user', where: 'UserName = ?' , whereArgs: [state.getUserNameController.text]);

      Map<String, dynamic> userDataGet = {
        "UserName" : state.getUserNameController.text,
        "UserPhone" : state.getPhoneController.text,
        "UserAddress" : state.getAddressController.text,
        "createTime" : now,
      };

      if(getUserDataSelect.isNotEmpty){ //存在--更新用户信息
        var updateUserDataResult = await DBService.instance.database!.update('user', userDataGet, where: "UserName = ?" , whereArgs: [state.getUserNameController.text]);
        if(updateUserDataResult == 0){
          BotToast.showText(text: '更新用户数据----收货人数据更新失败');
          print('更新用户数据----收货人数据更新失败');
        }
      }else{ //插入用户信息
        var saveUserDataResult = await DBService.instance.database!.insert('user', userDataGet);
        if(saveUserDataResult == 0){
          BotToast.showText(text: '存储新用户数据成功');
        }
      }



      //更新订单列表数据
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
        'sn': sn,
        'printBillNum' : state.printBillNumController.text.isEmpty ? "1" : state.printBillNumController.text
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


  /**
   * 获取人员列表
   */

  fillingData() async {
    var result = await DBService.instance.database!.query('user');
    if(result.isNotEmpty){
      state.searchUserListAll = <UserModel>[].obs;
      state.searchUserList = <UserModel>[].obs;
      for(int i = 0; i < result.length; i++){
        state.searchUserListAll.add(UserModel.fromJson(result[i]));
        state.searchUserList.add(UserModel.fromJson(result[i]));
      }
      update();
    }
  }

  @override
  void onInit() {
    super.onInit();
    searchListen();
    state.searchController.clear();
  }


  searchListen() async {
    state.searchController.addListener(() {
      timer?.cancel();
      timer = Timer(durationTime, () async {
        if(state.searchController.text.isNotEmpty){
          var result = await DBService.instance.database!.rawQuery("select * from user where UserName like '%${state.searchController.text}%'");
          state.searchUserList = <UserModel>[].obs;
          for(int r = 0; r < result.length; r++){
            state.searchUserList.add(UserModel.fromJson(result[r]));
          }
          update();
        }else{
          state.searchUserList = state.searchUserListAll;
          update();
        }
      });
    });
  }


  /**
   * 填充数据
   * type : 1 发货人  2 收货人
   */
  fillingAction(UserModel data, int type) {
    if (type == 1) {
      state.sendUserNameController.text = data.userName!;
      state.sendPhoneController.text = data.userPhone!;
      update();
    }else {
      state.getUserNameController.text = data.userName!;
      state.getPhoneController.text = data.userPhone!;
      if(data.userAddress == "0"){
        state.getAddressController.text = '';
      }else{
        state.getAddressController.text = data.userAddress!;
      }

      update();
    }
  }


  /**
   * 清除填充
   */
  clearFilling(int type){
    if (type == 1) {
      state.sendUserNameController.clear();
      state.sendPhoneController.clear();
      update();
    }else {
      state.getUserNameController.clear();
      state.getPhoneController.clear();
      state.getAddressController.clear();
      update();
    }
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    state.searchController.dispose();
    timer?.cancel();
  }
}
