class LoginResponse {
  Result? result;
  int? status;
  String? message;

  LoginResponse({this.result, this.status, this.message});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    result =
    json['result'] != null ?  Result.fromJson(json['result']) : null;
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}

class Result {
  String? userNameId;
  String? userPassword;
  String? deviceId;
  int? userId;
  String? userName;
  bool? isCustomer;
  int? userRoleID;
  String? profileImgPath;

  Result(
      {this.userNameId,
        this.userPassword,
        this.deviceId,
        this.userId,
        this.userName,
        this.isCustomer,
        this.userRoleID,
        this.profileImgPath});

  Result.fromJson(Map<String, dynamic> json) {
    userNameId = json['userNameId'];
    userPassword = json['userPassword'];
    deviceId = json['deviceId'];
    userId = json['userId'];
    userName = json['userName'];
    isCustomer = json['isCustomer'];
    userRoleID = json['userRoleID'];
    profileImgPath = json['profileImgPath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userNameId'] = this.userNameId;
    data['userPassword'] = this.userPassword;
    data['deviceId'] = this.deviceId;
    data['userId'] = this.userId;
    data['userName'] = this.userName;
    data['isCustomer'] = this.isCustomer;
    data['userRoleID'] = this.userRoleID;
    data['profileImgPath'] = this.profileImgPath;
    return data;
  }
}
