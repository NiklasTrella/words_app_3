// Model uživatele
class UserModel {
  String? userId;
  String? firstName;
  String? lastName;
  String? email;
  bool? isTeacher;

  UserModel(this.userId, this.firstName, this.lastName, this.isTeacher);
  UserModel.withEmail(this.userId, this.firstName, this.lastName, this.isTeacher, this.email);

  Map<String, dynamic> userToMap() {
    return <String, dynamic> {
      "firstName": firstName,
      "lastName": lastName,
      "isTeacher": isTeacher
    };
  }
}

// Model kurzu
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

  Map<String, dynamic> courseProgressToMap() {
    return <String, dynamic> {
      "courseId": courseId
    };
  }
}

// Model setu
class SetModel {
  String? courseId;
  String? setId;
  String? title;

  SetModel(this.courseId, this.setId, this.title);

  Map<String, dynamic> setToMap() {
    return <String, dynamic> {
      "title": title
    };
  }

  Map<String, dynamic> setProgressToMap() {
    return <String, dynamic> {
      "setId": setId,
    };
  }
}

// Model slova
class WordModel {
  // String? setId;
  String? wordId;
  String? original;
  String? translation;
  int? memory;

  WordModel(this.wordId, this.original, this.translation);

  WordModel.progressConstructor(this.wordId, this.original, this.translation, this.memory);

  Map<String, dynamic> wordToMap() {
    return <String, dynamic> {
      "original": original,
      "translation": translation
    };
  }

  void addMemory(int newMemory) {
    memory = newMemory;
  }

  // Map<String, dynamic> wordProgressToMap() {
  //   return <String, dynamic> {
  //     "wordId": wordId
  //   };
  // }
}