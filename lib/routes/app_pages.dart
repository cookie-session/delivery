

import 'package:delivery_win/body/bill_view_page/bill_view_page_binding.dart';
import 'package:delivery_win/body/bill_view_page/bill_view_page_view.dart';
import 'package:delivery_win/body/create_bill/create_bill_view.dart';
import 'package:delivery_win/routes/app_routes.dart';
import 'package:get/get.dart';
class AppPages {

  static const String initPage = AppRoutes.billPage;


  static final List<GetPage> routes = [

    GetPage(
      name: AppRoutes.billPage,
      binding: BillViewPageBinding(),
      page: () => BillViewPagePage(),
    ),

    GetPage(
      name: AppRoutes.createBill,
      page: () => CreateBillPage(),
    ),
  ];
}