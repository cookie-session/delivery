import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'user_logic.dart';

class UserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final logic = Get.put<UserLogic>(UserLogic());
    final state = Get
        .find<UserLogic>()
        .state;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green.shade300,
        title: const Text('用户信息'),
        centerTitle: true,
      ),
      body: GetBuilder<UserLogic>(
          init: logic,
          builder: (cox) {
            return ListView.separated(
              separatorBuilder: (BuildContext context, int index) =>  Divider(height: 0,),
              itemCount: cox.state.userList.length,
                itemBuilder: (BuildContext context, int index){
                  return Container(
                    color: Colors.grey.shade100,
                    child: ListTile(
                      leading: Text('姓名：${cox.state.userList[index].userName!}'),
                      title: Text('电话：${cox.state.userList[index].userPhone!}'),
                      subtitle: Text('地址：${cox.state.userList[index].userAddress! == "0" ? "未录入" : cox.state.userList[index].userAddress}'),
                      trailing: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.redAccent)
                        ),
                        onPressed: (){
                          cox.deleteUser(cox.state.userList[index].id!);
                        },
                        child: Text('删除'),
                      ),
                    ),
                  );
                }
            );
          }
      ),
    );
  }
}
