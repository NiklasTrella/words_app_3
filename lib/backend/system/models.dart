// Tento soubor obsahuje modely (třídy) pro různé objekty

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
      "isTeacher": isTeacher,
      "email": email
    };
  }
}

// Model kurzu
class CourseModel {
  String? userId;
  String? courseId;
  String? title;
  bool? isAuthor;

  CourseModel(this.userId, this.courseId, this.title);
  CourseModel.withAutorship(this.userId, this.courseId, this.title, this.isAuthor);

  Map<String, dynamic> courseToMap() {
    return <String, dynamic> {
      "userId": userId,
      "title": title
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
}

// Model slova
class WordModel {
  String? wordId;
  String? original;
  String? translation;
  int memory1 = 0;
  int memory2 = 0;

  WordModel(this.wordId, this.original, this.translation);

  WordModel.withMemory(this.wordId, this.original, this.translation, this.memory1, this.memory2);

  Map<String, dynamic> wordToMap() {
    return <String, dynamic> {
      "original": original,
      "translation": translation
    };
  }

  void addMemory(int? newMemory1, int? newMemory2) {
    if(newMemory1 != null) {
      memory1 = newMemory1;
    }
    if(newMemory2 != null) {
      memory1 = newMemory2;
    }
  }

  Map<String, dynamic> wordProgressToMap() {
    return <String, dynamic> {
      "memory1": memory1,
      "memory2": memory2
    };
  }
}