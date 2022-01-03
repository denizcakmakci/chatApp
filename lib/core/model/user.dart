class User {
  String? name;
  String? phoneNumber;
  String? photoUrl;
  String? userId;

  User({this.name, this.phoneNumber, this.photoUrl, this.userId});

  T? _check<T>(T? data) => data is T ? data : null;

  User.fromJson(Map<String, dynamic> json) {
    name = _check<String>(json['name']);
    phoneNumber = _check<String>(json['phone_number']);
    photoUrl = _check<String>(json['photo_url']);
    userId = _check<String>(json['user_id']);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['phone_number'] = phoneNumber;
    data['photo_url'] = photoUrl;
    data['user_id'] = userId;
    return data;
  }
}
