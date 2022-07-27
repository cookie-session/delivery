

class TimerUtil {


  //时间戳转时间
  static timeStringToTime(int createTime){
    DateTime times = DateTime.fromMillisecondsSinceEpoch(createTime);
    return '${times.year}-${times.month.toString().padLeft(2, "0")}-${times.day.toString().padLeft(2, "0")}  ${times.hour.toString().padLeft(2, "0")}'
        ':${times.minute.toString().padLeft(2, "0")}:${times.second.toString().padLeft(2, "0")}';
  }
}