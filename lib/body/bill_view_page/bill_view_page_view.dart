import 'package:barcode_widget/barcode_widget.dart';
import 'package:delivery_win/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';

import 'bill_view_page_logic.dart';

class BillViewPagePage extends StatelessWidget {


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

  Color _payTypeColor(String payType){

    int type = int.parse(payType);
    if(type == 1){
      return const Color(0xffedb06d);
    }else if(type == 2){
      return Colors.redAccent;
    }else{
      return Colors.green;
    }
  }


  String _sendTypeFunc(int type){
    if(type == 1){
      return "待配送";
    }else if(type == 2){
      return "配送中";
    }else{
      return "已签收";
    }
  }

  Color _sendTypeColor(int type){

    if(type == 1){
      return Colors.red;
    }else if(type == 2){
      return const Color(0xffedb06d);
    }else{
      return Colors.green;
    }
  }


  @override
  Widget build(BuildContext context) {
    final logic = Get.find<BillViewPageLogic>();
    final state = Get.find<BillViewPageLogic>().state;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.green.shade300,
        title: Text('壹点通快递订单', style: TextStyle(letterSpacing: 10.w),),
        centerTitle: true,
        actions: [
          // Container(
          //   padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.w),
          //   child: ElevatedButton(
          //       onPressed: (){
          //         logic.getBillListData();
          //       },
          //       child: Text('查看')
          //   ),
          // ),
          // Container(
          //   padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.w),
          //   child: ElevatedButton(
          //       onPressed: (){
          //         logic.getDataBasePath();
          //       },
          //       child: Text('数据库位置')
          //   ),
          // ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.w),
            child: ElevatedButton(
                onPressed: (){
                  Get.toNamed(AppRoutes.createBill);
                },
                child: Text('录入')
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.grey.shade200,
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            height: 80.h,
            child: Row(
              children: [
                Container(
                  alignment: Alignment.center,
                  width: 120.w,
                  child: Text('订单号'),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                          alignment: Alignment.center,
                          width: 45.w,
                          child: Text('发货人')
                      ),
                      Container(
                          alignment: Alignment.center,
                          width: 45.w,
                          child: Text('收货人')
                      ),
                      Container(
                          alignment: Alignment.center,
                          width: 130.w,
                          child: Text('收货地址')
                      ),
                      Container(
                          alignment: Alignment.center,
                          width: 60.w,
                          child: Text('录入时间')
                      ),
                      Container(
                          alignment: Alignment.center,
                          width: 20.w,
                          child: Text('数量')
                      ),
                      Container(
                          alignment: Alignment.center,
                          width: 50.w,
                          child: Text('付款方式')
                      ),
                      Container(
                          alignment: Alignment.center,
                          width: 30.w,
                          child: Text('状态')
                      ),
                      Expanded(
                        child: Container(
                            alignment: Alignment.center,
                            // width: 120.w,
                            child: Text('操作')
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: GetBuilder<BillViewPageLogic>(
              init: logic,
              builder: (cox){
                if(cox.state.listData.isNotEmpty) {
                  return ListView.separated(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      itemCount: cox.state.listData.length,
                      separatorBuilder: (BuildContext context, int index) => const Divider( height: 1,),
                      itemBuilder: (BuildContext context, int index){
                        return SizedBox(
                          height: 100.h,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                alignment: Alignment.center,
                                width: 120.w,
                                child: Text('${cox.state.listData[index].sn}'),
                              ),
                              Expanded(
                                child: Row(
                                  children: [
                                    Container(
                                        alignment: Alignment.center,
                                        width: 45.w,
                                        child: Text('${cox.state.listData[index].sendUserName}')
                                    ),
                                    Container(
                                        alignment: Alignment.center,
                                        width: 45.w,
                                        child: Text('${cox.state.listData[index].getUserName}')
                                    ),
                                    Container(
                                        alignment: Alignment.center,
                                        width: 130.w,
                                        child: Text('${cox.state.listData[index].getUserAddress}', style: TextStyle(overflow: TextOverflow.ellipsis),)
                                    ),
                                    Container(
                                        alignment: Alignment.center,
                                        width: 60.w,
                                        child: Text('${cox.state.listData[index].createTime}')
                                    ),
                                    Container(
                                        alignment: Alignment.center,
                                        width: 20.w,
                                        child: Row(
                                          children: [
                                            Text('${cox.state.listData[index].getCount}', style: const TextStyle(color: Colors.red),),
                                            const Text('件')
                                          ],
                                        )
                                    ),
                                    Container(
                                        alignment: Alignment.center,
                                        width: 50.w,
                                        child: Text(
                                            _payTypeFunc(cox.state.listData[index].paymentMethod!),
                                          style: TextStyle(color: _payTypeColor(cox.state.listData[index].paymentMethod!)),
                                        )
                                    ),
                                    Container(
                                        alignment: Alignment.center,
                                        width: 30.w,
                                        child: Text(_sendTypeFunc(cox.state.listData[index].status!),
                                          style: TextStyle(color: _sendTypeColor(cox.state.listData[index].status!)),)
                                    ),
                                    Expanded(
                                      child: Container(
                                        alignment: Alignment.center,
                                        // width: 140.w,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            if(cox.state.listData[index].status == 1)
                                            ElevatedButton(
                                              style: ButtonStyle(
                                                  backgroundColor: MaterialStateProperty.all(Colors.green)
                                              ),
                                              onPressed: (){
                                                cox.sendPrint(cox.state.listData[index]);
                                              },
                                              child: Text('打印'),
                                            ),
                                            if(cox.state.listData[index].status == 2)
                                              ElevatedButton(
                                                style: ButtonStyle(
                                                    backgroundColor: MaterialStateProperty.all(Colors.orange)
                                                ),
                                                onPressed: (){
                                                  cox.sendPrint(cox.state.listData[index]);
                                                },
                                                child: Text('补印'),
                                              ),
                                            SizedBox(width: 10.w,),
                                            ElevatedButton(
                                              onPressed: (){
                                                SmartDialog.show(
                                                  bindPage: true,
                                                  builder: (_) {
                                                    return Container(
                                                        height: 800.h,
                                                        width: 300.w,
                                                        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.w),
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(20),
                                                          color: Colors.white,
                                                        ),
                                                        alignment: Alignment.center,
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Text('订单号：'),
                                                                SizedBox(width: 10.w,),
                                                                Text('YDT16516161')
                                                              ],
                                                            ),
                                                            Row(
                                                              children: [
                                                                Text('发货人名字：'),
                                                                SizedBox(width: 10.w,),
                                                                Text('张三'),
                                                                SizedBox(width: 10.w,),
                                                                SizedBox(
                                                                  height: 35.h,
                                                                  child: ElevatedButton(
                                                                      onPressed: (){

                                                                      },
                                                                      child: Text('改')
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                            Row(
                                                              children: [
                                                                Text('收货人名字：'),
                                                                SizedBox(width: 10.w,),
                                                                Text('里斯'),
                                                                SizedBox(width: 10.w,),
                                                                SizedBox(
                                                                  height: 35.h,
                                                                  child: ElevatedButton(
                                                                      onPressed: (){

                                                                      },
                                                                      child: Text('改')
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                            Row(
                                                              children: [
                                                                Text('收货地址：'),
                                                                SizedBox(width: 10.w,),
                                                                Text('武侯区天府三街一品CG1栋2601'),
                                                                SizedBox(width: 10.w,),
                                                                SizedBox(
                                                                  height: 35.h,
                                                                  child: ElevatedButton(
                                                                      onPressed: (){

                                                                      },
                                                                      child: Text('改')
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                            Row(
                                                              children: [
                                                                Text('数量：'),
                                                                SizedBox(width: 10.w,),
                                                                Text('10'),
                                                                SizedBox(width: 10.w,),
                                                                SizedBox(
                                                                  height: 35.h,
                                                                  child: ElevatedButton(
                                                                      onPressed: (){

                                                                      },
                                                                      child: Text('改')
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                            Row(
                                                              children: [
                                                                Text('运费：'),
                                                                SizedBox(width: 10.w,),
                                                                Text('￥10.00'),
                                                                SizedBox(width: 10.w,),
                                                                SizedBox(
                                                                  height: 35.h,
                                                                  child: ElevatedButton(
                                                                      onPressed: (){

                                                                      },
                                                                      child: Text('改')
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                            Row(
                                                              children: [
                                                                Text('付款方式：'),
                                                                SizedBox(width: 10.w,),
                                                                Text('已付款'),
                                                                SizedBox(width: 10.w,),
                                                                SizedBox(
                                                                  height: 35.h,
                                                                  child: ElevatedButton(
                                                                      onPressed: (){

                                                                      },
                                                                      child: Text('改')
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                            Row(
                                                              children: [
                                                                Text('状态：'),
                                                                SizedBox(width: 10.w,),
                                                                Text('待配送'),
                                                                SizedBox(width: 10.w,),
                                                                SizedBox(
                                                                  height: 35.h,
                                                                  child: ElevatedButton(
                                                                      onPressed: (){

                                                                      },
                                                                      child: Text('改')
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                            Row(
                                                              children: [
                                                                Text('录入时间：'),
                                                                SizedBox(width: 10.w,),
                                                                Text('2022-07-21 20:00')
                                                              ],
                                                            ),
                                                            BarcodeWidget(
                                                              height: 200.h,
                                                              barcode: Barcode.code128(),
                                                              data: 'YDT16516161',
                                                            )
                                                          ],
                                                        )
                                                    );
                                                  },
                                                );
                                              },
                                              child: Text('查看'),
                                            ),
                                            SizedBox(width: 10.w,),
                                            ElevatedButton(
                                              style: ButtonStyle(
                                                  backgroundColor: MaterialStateProperty.all(Colors.deepOrange)
                                              ),
                                              onPressed: (){

                                                SmartDialog.show(
                                                  bindPage: true,
                                                  tag: "deleteDialog",
                                                  builder: (_) {
                                                    return Container(
                                                        height: 500.h,
                                                        width: 300.w,
                                                        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.w),
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(20),
                                                          color: Colors.white,
                                                        ),
                                                        alignment: Alignment.center,
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: [
                                                            Text('删除数据后将无法恢复，请谨慎操作!', style: TextStyle(fontSize: 45.sp, fontWeight: FontWeight.bold),),
                                                            Text('您是否需要删除该条数据!', style: TextStyle(fontSize: 40.sp,color: Colors.red),),
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                              children: [
                                                                SizedBox(
                                                                  width: 80.w,
                                                                  height: 30.w,
                                                                  child: ElevatedButton(
                                                                      style: ButtonStyle(
                                                                          backgroundColor: MaterialStateProperty.all(Colors.red)
                                                                      ),
                                                                      onPressed: (){
                                                                        cox.deleteBill(cox.state.listData[index].id!);
                                                                        SmartDialog.dismiss(tag: "deleteDialog");
                                                                      },
                                                                      child: Text('删除')
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 80.w,
                                                                  height: 30.w,
                                                                  child: ElevatedButton(
                                                                      onPressed: (){

                                                                      },
                                                                      child: Text('取消')
                                                                  ),
                                                                ),
                                                              ],
                                                            )
                                                          ],
                                                        )
                                                    );
                                                  },
                                                );

                                                // cox.deleteBill(cox.state.listData[index].id!);
                                              },
                                              child: Text('删除'),
                                            ),

                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                  );
                }else{
                  return Center(
                    child: SizedBox(
                      width: 100.w,
                      child: Image.asset('assets/not_data.png'),
                    ),
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
