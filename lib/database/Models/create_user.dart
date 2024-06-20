// ignore: camel_case_types
class newUser {
  final String? id;
  final String name;
  final String surname;
  final String dateOfBirt;
  final String phoneNumber;
  final String email;
  final String credit;

  const newUser({
    this.id,
    required this.name,
    required this.surname,
    required this.dateOfBirt,
    required this.phoneNumber,
    required this.email,
    required this.credit,
  });

  Map<String, dynamic> toJson() {
    return {
      'Name': name,
      'Surname': surname,
      'DateOfBirt': dateOfBirt,
      'PhoneNumber': phoneNumber,
      'Email': email,
      'Credit': credit,
    };
  }
}
