import 'dart:convert';

UserApp userFromJson(String str) => UserApp.fromJson(json.decode(str));

String userToJson(UserApp data) => json.encode(data.toJson());

class UserApp {
  UserApp({
        this.rol,
        this.age,//
        this.name,//
        this.phone,//
        this.surname,///
        this.uid,
        this.email,
        this.urlimage,
        this.school,
        this.grade,
        this.gparallel,
        this.score,
        this.username,
        this.secondname
      });

  String? rol;
  String? age;
  String? name;
  String? email;
  String? phone;
  String? surname;
  String? uid;
  String? urlimage;
  String? school;
  String? grade;
  String? gparallel;
  String? score;
  String? username;
  String? secondname;

  factory UserApp.fromJson(Map<String, dynamic> json) => UserApp(
        rol: json["Rol"],
        age: json["age"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        surname: json["surname"],
        uid: json["uid"],
        urlimage: json["urlimage"],
        school: json["school"],
        grade: json["grade"],
        gparallel: json["gparallel"],
        score: json["score"],
        username: json["username"],
        secondname: json["secondname"]
      );

  Map<String, dynamic> toJson() => {
        "Rol": rol,
        "age": age,
        "name": name,
        "phone": phone,
        "surname": surname,
        "uid": uid,
        "urlimage": urlimage,
        "email": email,
        "school": school,
        "grade": grade,
        "gparallel": gparallel,
        "score": score,
        "username": username,
        "secondname":secondname
      };
}
