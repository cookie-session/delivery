import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:delivery_win/bill_model.dart';
import 'package:delivery_win/util/db/DataDb.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import 'user_state.dart';

class UserLogic extends GetxController {
  final UserState state = UserState();


  getUserList() async {
    var resultUser = await DBService.instance.database!.query('user', orderBy: "id DESC");
    print(resultUser);
    if(resultUser.isNotEmpty){
      for(int i = 0; i < resultUser.length; i++){
        state.userList.add(UserModel.fromJson(resultUser[i]));
      }
      update();
    }
  }

  deleteUser(int id) async {
    var result = await DBService.instance.database!.delete('user',where: 'id = ?', whereArgs: [id]);
    if(result == 0){
      BotToast.showText(text: '删除失败');
    }
    BotToast.showText(text: '删除成功');
    for(int i = 0; i < state.userList.length; i++){
      if(state.userList[i].id == id){
        state.userList.removeAt(i);
        update();
        continue;
      }
    }
  }




  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getUserList();
  }
}
