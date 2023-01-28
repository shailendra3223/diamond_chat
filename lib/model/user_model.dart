class UserList {
  List<Result>? result;
  int? status;
  String? message;

  UserList({this.result, this.status, this.message});

  UserList.fromJson(Map<String, dynamic> json) {
    if (json['result'] != null) {
      result = <Result>[];
      json['result'].forEach((v) {
        result!.add(new Result.fromJson(v));
      });
    }
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.result != null) {
      data['result'] = this.result!.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}

class Result {
  int? userId;
  String? profileImgPath;
  String? fullName;
  String? message;
  String? createdDate;

  Result(
      {this.userId,
        this.profileImgPath,
        this.fullName,
        this.message,
        this.createdDate});

  Result.fromJson(Map<String, dynamic> json) {
    userId = json['userId']??"";
    profileImgPath = json['profileImgPath']??"";
    fullName = json['fullName']??"";
    message = json['message']??"";
    createdDate = json['createdDate']??"";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['profileImgPath'] = this.profileImgPath;
    data['fullName'] = this.fullName;
    data['message'] = this.message;
    data['createdDate'] = this.createdDate;
    return data;
  }
}

