import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:delivery_win/bill_model.dart';
import 'package:delivery_win/util/db/DataDb.dart';
import 'package:delivery_win/util/socket.dart';
import 'package:delivery_win/util/timer.dart';
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

    WebSocketUtility().initWebSocket(onOpen: () {

    }, onMessage: (data) {
      print(data);
    }, onError: (e) {
      print(e);
    });

  }



  getBillListData() async {
    var result = await DBService.instance.database!.query('bill', orderBy: "id DESC");
    if(result.isNotEmpty){
      for(int i = 0; i < result.length; i++){
        state.listData.add(BillModel.fromJson(result[i]));
      }
      update();
    }else{
      BotToast.showText(text: '暂无更多数据');
    }
  }



  sendPrint(BillModel data) async {

    ///打印标签
    if(data.status == 1){
      ///打印操作
      printDelivery(data);
      ///更改数据库状态
      var updateResult = await DBService.instance.database!.update("bill", {"status" : 2}, where: 'id = ?', whereArgs: [data.id] );
      if(updateResult == 1){
        data.status = 2;
        update();
        BotToast.showText(text: '快递单打印中...');
      }else{
        BotToast.showText(text: '本条信息更新失败,请核对快递单数量和信息');
      }
    }else if(data.status == 2){
      printDelivery(data);
      BotToast.showText(text: '快递单补印中...');
    }else {
      BotToast.showText(text: '该订单已完成，无法打印快递单');
    }
  }

//验证是否是手机号码
  mobile(String phoneNumber){
    RegExp exp = RegExp(r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$');
    return exp.hasMatch(phoneNumber);
  }

  deleteBill(int deleteId) async {
    var result = await DBService.instance.database!.delete("bill", where: 'id = ?', whereArgs: [deleteId]);
    if(result == 1){
      for(int i = 0; i < state.listData.length; i++){
        if(state.listData[i].id == deleteId){
          state.listData.removeAt(i);
          update();
          break;
        }
      }
    }else{
      BotToast.showText(text: '删除失败，请联系管理员');
    }
  }


  ///打印快递单
  printDelivery(BillModel data){

    String times = TimerUtil.timeStringToTime(data.createTime!);

    WebSocketUtility().sendMessage(
        "SIZE 76 mm, 130 mm\r\n" +
            "CODEPAGE UTF-8\r\n" +
            "CLS\r\n" +
            "TEXT 130,50,\"TSS24.BF2\",0,2,2,\"壹点通同城配送\"\r\n" +
            "TEXT 30,150,\"TSS24.BF2\",0,1,1,\"发货人信息：\"\r\n" +
            "TEXT 30,190,\"TSS24.BF2\",0,1,1,\"发货人: ${data.sendUserName}\"\r\n" +
            "TEXT 30,240,\"TSS24.BF2\",0,1,1,\"发货人联系方式: ${data.sendUserPhone}\"\r\n" +
            "TEXT 30,290,\"TSS24.BF2\",0,1,1,\"-----------------------\"\r\n" +
            "TEXT 30,340,\"TSS24.BF2\",0,1,1,\"收货人信息：\"\r\n" +
            "TEXT 30,390,\"TSS24.BF2\",0,1,1,\"收货人: ${data.getUserName}\"\r\n" +
            "TEXT 30,440,\"TSS24.BF2\",0,1,1,\"收货人联系方式: ${data.getUserPhone}\"\r\n" +
            "TEXT 30,490,\"TSS24.BF2\",0,1,1,\"收货地址: \"\r\n" +
            "TEXT 30,540,\"TSS24.BF2\",0,1,1,\"${data.getUserAddress}\"\r\n" +
            "TEXT 30,590,\"TSS24.BF2\",0,1,1,\"-----------------------\"\r\n" +
            "TEXT 30,640,\"TSS24.BF2\",0,1,1,\"货物信息：\"\r\n" +
            "TEXT 30,690,\"TSS24.BF2\",0,1,1,\"订单号：${data.sn}\"\r\n" +
            "TEXT 30,740,\"TSS24.BF2\",0,1,1,\"订单日期：$times\"\r\n" +
            "TEXT 30,790,\"TSS24.BF2\",0,1,1,\"运费：${data.freight}元\"\r\n" +
            "TEXT 30,840,\"TSS24.BF2\",0,1,1,\"付款方式：${_payTypeFunc(data.paymentMethod!)}\"\r\n" +
            "TEXT 30,870,\"TSS24.BF2\",0,1,1,\"货物数量：${data.getCount}件\"\r\n" +
            "TEXT 30,920,\"TSS24.BF2\",0,1,1,\"------------------------------------------\"\r\n" +
            "TEXT 30,960,\"TSS24.BF2\",0,1,1,\"同城配送电话：18782635598\"\r\n" +
            "TEXT 30,990,\"TSS24.BF2\",0,1,1,\"郫都区安靖镇雍渡小区22栋附3-5号\"\r\n" +
            "PRINT 1,${data.getCount}\r\n" +
            "SOUND 5,100\r\n" +
            "OUT \"ABC1231\"\r\n");
  }



  String _payTypeFunc(String payType){
    int type = int.parse(payType);
    if(type == 1){
      return "定金到付";
    }else if(type == 2){
      return "货到付款";
    }else{
      return "已收款";
    }
  }


  /*
  修改订单信息
   */
  updateBill(BillModel billModel, String find, Function success) async {
    var result = await DBService.instance.database!.update("bill", {find : state.editingController.text},where: 'id = ?', whereArgs: [billModel.id]);
    if(result == 1){
      state.editingController.clear();
      var selectResult = await DBService.instance.database!.query("bill", where: 'id = ?' , whereArgs: [billModel.id]);
      if(selectResult.isNotEmpty){
        for(var i = 0; i < state.listData.length; i++){
          if(state.listData[i].id == billModel.id){
            state.listData[i] = BillModel.fromJson(selectResult.first);
            break;
          }
        }
        update();
        BotToast.showText(text: '修改成功');
        success();

      }else{
        BotToast.showText(text: '修改/更新数据列表失败');
      }
    }else{
      BotToast.showText(text: '修改更新数据库失败');
    }
  }
}
