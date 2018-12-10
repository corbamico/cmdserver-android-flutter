import 'package:http/http.dart' as http;
import 'dart:convert' as json;
import 'serveraddress.dart';

enum Status {
  Unknown,IDLE,Running,Checking
}
String statusToString(Status st){
  String res;
  switch (st){
    case Status.Unknown:res = "无连接";break;
    case Status.Checking:res = "连接中";break;
    case Status.IDLE:res = "已关闭";break;
    case Status.Running:res = "已启动";break;
  }
  return res;
}


class ServerStatus{
  Status status;
  ServerStatus(this.status);
  ServerStatus.fromJson(Map<String,dynamic> json):status = _mapToStatus(json['result']);
  ServerStatus.fromJsonString(String source):this.fromJson(json.jsonDecode(source));

  static Status _mapToStatus(int result){
    Status res;
    switch (result){
      case 0:res = Status.IDLE;break;
      case 1:res = Status.Running;break;
      default:res = Status.Unknown;
    }
    return res;
  }

  String toString()=>statusToString(status);
}



class ServerStatusRepository {
  static Future<ServerStatus> getStatus() async {
    ServerStatus status = ServerStatus(Status.Unknown);
    try {
      var res = await http.get(SERVER_URL + SERVER_URI_STATUS);
      status = ServerStatus.fromJsonString(res.body);
    }catch(e){
      //print(e.toString());
      return status;
    }
    return status;
  }

  static Future<ServerStatus> restart() async {
    ServerStatus status = ServerStatus(Status.Unknown);

    try {
      var res = await http.get(SERVER_URL + SERVER_URI_RESTART);
      if (res.statusCode == 200) {
        status = ServerStatus.fromJsonString(res.body);
        return await getStatus();
      }
    }catch(e){
      return status;
    }
    return status;
  }
}