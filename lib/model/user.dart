class User {
  int? id;
  String? name;
  String? study;
  String? age;
  String? blood;
  String? selectedImage;
  userMap() {
    var mapping = Map<String, dynamic>();
    mapping['id'] = id ?? null;
    mapping['name'] = name!;
    mapping['study'] = study!;
    mapping['age'] = age!;
    mapping['blood'] = blood!;
    mapping['selectedImage'] = selectedImage;
    return mapping;
  }

  // static fromMap(user) {}
}
