// class User {
//   const User({
//     required this.id,
//     required this.username,
//     this.email,
//     this.password,
//   });

//   final String id;
//   final String username;
//   final String? email;
//   final String? password;
// }

class User {
  const User({
    required this.id,
    this.email,
    required this.username,
    List<String>? groups,
  }) : _groups = groups;

  final int id;
  final String? email;
  final String username;
  final List<String>? _groups;

  bool get isManager => _groups!.contains('manager');
  bool get isDeliveryCrew => _groups!.contains('delivery-crew');

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      username: json['username'],
      groups: List<String>.from(json['groups']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'groups': _groups,
    };
  }
}
