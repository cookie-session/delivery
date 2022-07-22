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
}
