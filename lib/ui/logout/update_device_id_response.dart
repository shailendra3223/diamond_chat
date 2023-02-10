class UpdateDeviceId {
  bool? result;
  int? status;
  String? message;

  UpdateDeviceId({this.result, this.status, this.message});

  UpdateDeviceId.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    status = json['status'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['result'] = this.result;
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}
