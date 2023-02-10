class ForwardChatUserResponse {
  List<Result>? result;
  int? status;
  String? message;

  ForwardChatUserResponse({this.result, this.status, this.message});

  ForwardChatUserResponse.fromJson(Map<String, dynamic> json) {
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
  int? chatUserID;
  String? fullName;
  String? profileImgPath;
  bool? isSelected = false;

  Result({this.chatUserID, this.fullName, this.profileImgPath,this.isSelected});

  Result.fromJson(Map<String, dynamic> json) {
    chatUserID = json['chatUserID'];
    fullName = json['fullName'];
    isSelected = false;
    profileImgPath = json['profileImgPath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['chatUserID'] = this.chatUserID;
    data['fullName'] = this.fullName;
    data['profileImgPath'] = this.profileImgPath;
    return data;
  }
}
