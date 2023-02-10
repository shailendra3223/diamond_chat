class Login_body {
  String? userNameId;
  String? userPassword;
  String? deviceId;

  Login_body({this.userNameId, this.userPassword, this.deviceId});

  Login_body.fromJson(Map<String, dynamic> json) {
    userNameId = json['UserNameId'];
    userPassword = json['UserPassword'];
    deviceId = json['DeviceId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['UserNameId'] = this.userNameId;
    data['UserPassword'] = this.userPassword;
    data['DeviceId'] = this.deviceId;
    return data;
  }
}
