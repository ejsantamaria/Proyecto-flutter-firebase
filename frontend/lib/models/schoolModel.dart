import 'dart:convert';

SchoolModel schoolFromJson(String str) => SchoolModel.fromJson(json.decode(str));

String schoolToJson(SchoolModel data) => json.encode(data.toJson());

class SchoolModel {
  SchoolModel({
      this.school_name
      });

  String? school_name;

  factory SchoolModel.fromJson(Map<String, dynamic> json) => SchoolModel(
        school_name: json["school_name"],
      );

  Map<String, dynamic> toJson() => {
        "school_name": school_name,
      };
}
