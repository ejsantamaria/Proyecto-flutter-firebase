class Vehicle {
  Vehicle({
    this.brand,
    this.licence,
    this.model,
    this.numberRegister,
    this.owner,
    this.typeLicense,
    this.plate,
    this.expiryLicense,
  });

  String? brand;
  String? licence;
  String? model;
  String? numberRegister;
  String? owner;
  String? typeLicense;
  String? plate;
  DateTime? expiryLicense;

  factory Vehicle.fromJson(Map<String, dynamic> json) => Vehicle(
        brand: json["brand"],
        licence: json["licence"],
        model: json["model"],
        numberRegister: json["number_register"],
        owner: json["owner"],
        typeLicense: json["type_license"],
        plate: json["plate"],
        expiryLicense: DateTime.parse(json["expiry_license"] == null
            ? DateTime.now().toIso8601String()
            : json["expiry_license"]),
      );

  Map<String, dynamic> toJson() => {
        "brand": brand,
        "licence": licence,
        "model": model,
        "number_register": numberRegister,
        "owner": owner,
        "type_license": typeLicense,
        "plate": plate,
        "expiry_license": expiryLicense!.toIso8601String(),
      };
}
