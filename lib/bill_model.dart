

class BillModel{
  // {id: 5, sendUserName: 4, sendUserPhone: 4, getUserName: 4, getUserPhone: 4, getUserAddress: 4, getCount: 4,
  // paymentMethod: 1, status: 1, freight: 4,
  // createTime: 1658480726711, sn: 2022722130303}
  int? id;
  String? sendUserName;
  String? sendUserPhone;
  String? getUserName;
  String? getUserPhone;
  String? getUserAddress;
  String? getCount;
  String? paymentMethod;
  int? status;
  int? freight;
  int? createTime;
  String? sn;

  BillModel.fromJson(Map<String, dynamic> json){
    id = json['id'];
    sendUserName = json['sendUserName'];
    sendUserPhone = json['sendUserPhone'];
    getUserName = json['getUserName'];
    getUserPhone = json['getUserPhone'];
    getUserAddress = json['getUserAddress'];
    getCount = json['getCount'];
    paymentMethod = json['paymentMethod'];
    status = json['status'];
    freight = json['freight'];
    createTime = json['createTime'];
    sn = json['sn'];
  }



}