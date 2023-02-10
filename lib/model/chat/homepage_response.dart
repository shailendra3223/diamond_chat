class HomePage {
  List<Result>? result;
  int? status;
  String? message;

  HomePage({this.result, this.status, this.message});

  HomePage.fromJson(Map<String, dynamic> json) {
    if (json['result'] != null) {
      result = <Result>[];
      json['result'].forEach((v) {
        result!.add(Result.fromJson(v));
      });
    }
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    if (this.result != null) {
      data['result'] = this.result!.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}

class Result {
  int? chatUserId;
  String? profileImgPath;
  String? fullName;
  String? message;
  String? createdDate;
  bool? isSelected;

  Result(
      {this.chatUserId,
        this.profileImgPath,
        this.fullName,
        this.message,
        this.isSelected,
        this.createdDate});

  Result.fromJson(Map<String, dynamic> json) {
    chatUserId = json['chatUserId']??"";
    profileImgPath = json['profileImgPath']??"";
    fullName = json['fullName']??"";
    message = json['message']??"";
    isSelected = false;
    createdDate = json['createdDate']??"";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['chatUserId'] = this.chatUserId;
    data['profileImgPath'] = this.profileImgPath;
    data['fullName'] = this.fullName;
    data['message'] = this.message;
    data['createdDate'] = this.createdDate;
    return data;
  }
}

