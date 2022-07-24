import 'package:delivery_win/body/bill_view_page/bill_view_page_logic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'create_bill_logic.dart';

class CreateBillPage extends StatelessWidget {

  _dump(CreateBillLogic cox) {
    return DropdownButton(

      items: const <DropdownMenuItem<String>> [
        DropdownMenuItem(child: const Text("定金到付"), value: "1",),
        DropdownMenuItem(child: const Text("货到付款"), value: "2",),
        DropdownMenuItem(child: const Text("已收款"), value: "3",),
      ],
      hint: const Text("选择付款方式"),
      // 当没有初始值时显示
      onChanged: (selectValue) { //选中后的回调
        cox.selectPaymentMethod(selectValue.toString());
      },
      value: cox.state.dropdownMenu.value,
      elevation: 0,
      //设置阴影
      style: const TextStyle( //设置文本框里面文字的样式
          color: Colors.blue,
          fontSize: 15
      ),
      isExpanded: true,
      alignment: Alignment.centerRight,
      iconSize: 30,
      //设置三角标icon的大小
      underline: Container(height: 1, color: Colors.green.shade200,), // 下划线

    );
  }

  @override
  Widget build(BuildContext context) {
    final logic = Get.put<CreateBillLogic>(CreateBillLogic());
    final state = Get.find<CreateBillLogic>().state;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green.shade300,
          title: const Text('订单录入'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 100.h),
            child: GetBuilder<CreateBillLogic>(
              init: logic,
              builder: (cox) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        const Text('发货人：'),
                        SizedBox(width: 10.w,),
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(5.w),
                          ),
                          height: 95.h,
                          width: 100.w,
                          child: TextField(
                            controller: cox.state.sendUserNameController,
                            decoration: InputDecoration(
                                hintText: '请填写发货人姓名',
                                hintStyle: TextStyle(fontSize: 28.sp),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 5.w),
                                border: InputBorder.none
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 20.h,),
                    Row(
                      children: [
                        const Text('发货人联系方式：'),
                        SizedBox(width: 10.w,),
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(5.w)
                          ),
                          height: 95.h,
                          width: 100.w,
                          child: TextField(
                            controller: cox.state.sendPhoneController,
                            decoration: InputDecoration(
                                hintText: '请填写发货人联系方式',
                                hintStyle: TextStyle(fontSize: 28.sp),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 5.w),
                                border: InputBorder.none
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 20.h,),
                    Row(
                      children: [
                        const Text('收货人姓名：'),
                        SizedBox(width: 10.w,),
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(5.w)
                          ),
                          height: 95.h,
                          width: 100.w,
                          child: TextField(
                            controller: cox.state.getUserNameController,
                            decoration: InputDecoration(
                                hintText: '请填写收货人姓名',
                                hintStyle: TextStyle(fontSize: 28.sp),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 5.w),
                                border: InputBorder.none
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 20.h,),
                    Row(
                      children: [
                        const Text('收货人联系方式：'),
                        SizedBox(width: 10.w,),
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(5.w)
                          ),
                          height: 95.h,
                          width: 100.w,
                          child: TextField(
                            controller: cox.state.getPhoneController,
                            decoration: InputDecoration(
                                hintText: '请填写收货人联系方式',
                                hintStyle: TextStyle(fontSize: 28.sp),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 5.w),
                                border: InputBorder.none
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 20.h,),
                    Row(
                      children: [
                        const Text('收货地址：'),
                        SizedBox(width: 10.w,),
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(5.w)
                          ),
                          height: 95.h,
                          width: 160.w,
                          child: TextField(
                            controller: cox.state.getAddressController,
                            decoration: InputDecoration(
                                hintText: '请填写收货地址',
                                hintStyle: TextStyle(fontSize: 28.sp),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 5.w),
                                border: InputBorder.none
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 20.h,),
                    Row(
                      children: [
                        const Text('货品数量：'),
                        SizedBox(width: 10.w,),
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(5.w)
                          ),
                          height: 95.h,
                          width: 100.w,
                          child: TextField(
                            controller: cox.state.getCountController,
                            decoration: InputDecoration(
                                hintText: '请填写货品数量',
                                hintStyle: TextStyle(fontSize: 28.sp),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 5.w),
                                border: InputBorder.none
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 20.h,),
                    Row(
                      children: [
                        const Text('运费：'),
                        SizedBox(width: 10.w,),
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(5.w)
                          ),
                          height: 95.h,
                          width: 100.w,
                          child: TextField(
                            controller: cox.state.freightController,
                            decoration: InputDecoration(
                                hintText: '请填运费',
                                hintStyle: TextStyle(fontSize: 28.sp),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 5.w),
                                border: InputBorder.none
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 20.h,),
                    Row(
                      children: [
                        const Text('付款方式：'),
                        SizedBox(width: 10.w,),
                        SizedBox(
                          height: 95.h,
                          width: 100.w,
                          child: _dump(cox),
                        ),
                      ],
                    ),
                    SizedBox(height: 100.h,),
                    SizedBox(
                      width: 200.w,
                      height: 80.h,
                      child: ElevatedButton(
                          onPressed: (){
                            cox.saveBill();
                          },
                          child: Text('提交')
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        )
    );
  }
}
