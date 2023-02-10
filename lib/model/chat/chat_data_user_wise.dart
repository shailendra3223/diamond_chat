class ChatDataUserWise {
  Result? result;
  int? status;
  String? message;

  ChatDataUserWise({this.result, this.status, this.message});

  ChatDataUserWise.fromJson(Map<String, dynamic> json) {
    result =
    json['result'] != null ? new Result.fromJson(json['result']) : null;
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
  bool? loadPrev;
  String? profileImgPath;
  String? fullName;
  List<ChatListUserWiseModel>? chatListUserWiseModel;

  Result(
      {this.loadPrev,
        this.profileImgPath,
        this.fullName,
        this.chatListUserWiseModel});

  Result.fromJson(Map<String, dynamic> json) {
    loadPrev = json['loadPrev'];
    profileImgPath = json['profileImgPath'];
    fullName = json['fullName'];
    if (json['chatListUserWiseModel'] != null) {
      chatListUserWiseModel = <ChatListUserWiseModel>[];
      json['chatListUserWiseModel'].forEach((v) {
        chatListUserWiseModel!.add(new ChatListUserWiseModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['loadPrev'] = this.loadPrev;
    data['profileImgPath'] = this.profileImgPath;
    data['fullName'] = this.fullName;
    if (this.chatListUserWiseModel != null) {
      data['chatListUserWiseModel'] =
          this.chatListUserWiseModel!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ChatListUserWiseModel {
  int? userId;
  int? pageNumber;
  int? pageSize;
  int? chatUserId;
  int? chatId;
  String? fullName;
  String? message;
  String? createdDate;
  bool? isSender;
  int? senderUserId;
  bool? isSelected;
  String? createdDateOrder;
  List<dynamic>? chatFilePath = [];

  ChatListUserWiseModel(
      {this.userId,
        this.pageNumber,
        this.pageSize,
        this.chatUserId,
        this.chatId,
        this.fullName,
        this.message,
        this.createdDate,
        this.isSender,
        this.senderUserId,
        this.createdDateOrder,
        this.isSelected,
        this.chatFilePath});

  ChatListUserWiseModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    pageNumber = json['pageNumber'];
    pageSize = json['pageSize'];
    chatUserId = json['chatUserId'];
    chatId = json['chatId'];
    fullName = json['fullName'];
    message = json['message'];
    createdDate = json['createdDate'];
    isSender = json['isSender'];
    senderUserId = json['senderUserId'];
    isSelected = false;
    createdDateOrder = json['createdDateOrder'];
    if (json['chatFilePath'] != null) {
      json['chatFilePath'].forEach((v) {
        chatFilePath!.add((v));
      });
    }
    }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['pageNumber'] = this.pageNumber;
    data['pageSize'] = this.pageSize;
    data['chatUserId'] = this.chatUserId;
    data['chatId'] = this.chatId;
    data['fullName'] = this.fullName;
    data['message'] = this.message;
    data['createdDate'] = this.createdDate;
    data['isSender'] = this.isSender;
    data['senderUserId'] = this.senderUserId;
    data['createdDateOrder'] = this.createdDateOrder;
    if (this.chatFilePath != null) {
      data['chatFilePath'] =
          this.chatFilePath!.map((v) => v.toString());
    }
    return data;
  }
}
