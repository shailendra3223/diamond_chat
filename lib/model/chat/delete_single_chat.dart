class CommonChatResponse {
  int? result;
  int? status;
  String? message;

  CommonChatResponse({this.result, this.status, this.message});

  CommonChatResponse.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}
