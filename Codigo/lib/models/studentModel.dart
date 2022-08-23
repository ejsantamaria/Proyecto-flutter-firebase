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
        this.username,
        this.secondname,
        this.tutorPhone
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
  String? username;
  String? secondname;
  String? tutorPhone;

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
        username: json["username"],
        secondname: json["secondname"],
        tutorPhone: json["tutorPhone"]
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
        "username": username,
        "secondname":secondname,
        "tutorPhone":tutorPhone
      };
}
