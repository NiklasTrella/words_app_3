import 'package:flutter/material.dart';

class CourseModel {
  String? userId;
  String? courseId;
  String? title;

  CourseModel(this.userId, this.courseId, this.title);

  Map<String, dynamic> courseToMap() {
    return <String, dynamic> {
      "userId": userId,
      "title": title
    };
  }
}

class SetModel {
  String? setId;
  String? title;

  SetModel(this.setId, this.title);

  Map<String, dynamic> setToMap() {
    return <String, dynamic> {
      "title": title
    };
  }
}

class UserModel {
  String? userId;
  String? firstName;
  String? lastName;

  UserModel(this.userId, this.firstName, this.lastName);

  Map<String, dynamic> userToMap() {
    return <String, dynamic> {
      "firstName": firstName,
      "lastName": lastName
    };
  }
}