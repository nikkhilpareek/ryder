class SignInResponseModel {
  String? token;
  bool? error;
  Student? student;

  SignInResponseModel({this.token, this.error, this.student});

  SignInResponseModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    error = json['error'];
    student =
        json['student'] != null ? new Student.fromJson(json['student']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['error'] = this.error;
    if (this.student != null) {
      data['student'] = this.student!.toJson();
    }
    return data;
  }
}

class Student {
  String? id;
  String? name;
  String? email;

  Student({this.id, this.name, this.email});

  Student.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    return data;
  }
}
