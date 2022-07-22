import 'package:get/get.dart';

import 'create_bill_logic.dart';

class CreateBillBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CreateBillLogic());
  }
}
