import 'package:get/get.dart';

import 'bill_view_page_logic.dart';

class BillViewPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BillViewPageLogic());
  }
}
