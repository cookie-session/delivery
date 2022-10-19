import 'package:delivery_win/bill_model.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class CreateBillState {

  var dropdownMenu = '1'.obs;
  var dropdownMenuText = ''.obs;

  TextEditingController sendUserNameController = TextEditingController();
  TextEditingController sendPhoneController = TextEditingController();
  TextEditingController getUserNameController = TextEditingController();
  TextEditingController getPhoneController = TextEditingController();
  TextEditingController getAddressController = TextEditingController();
  TextEditingController getCountController = TextEditingController();
  TextEditingController freightController = TextEditingController();
  TextEditingController printBillNumController = TextEditingController();


  TextEditingController searchController = TextEditingController();
  RxList<UserModel> searchUserListAll = <UserModel>[].obs;
  RxList<UserModel> searchUserList = <UserModel>[].obs;
}
