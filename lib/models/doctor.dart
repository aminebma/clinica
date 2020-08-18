class Doctor {
  String _id, _firstName, _lastName, _speciality, _phoneNumber, _picture;

  Doctor(
      {String id,
      String firstName,
      String lastName,
      String speciality,
      String phoneNumber,
      String picture})
      : _id = id,
        _firstName = firstName,
        _lastName = lastName,
        _speciality = speciality,
        _phoneNumber = phoneNumber,
        _picture = picture;

  String get picture => _picture;

  set picture(String value) {
    _picture = value;
  }

  String get phoneNumber => _phoneNumber;

  set phoneNumber(String value) {
    _phoneNumber = value;
  }

  String get speciality => _speciality;

  set speciality(String value) {
    _speciality = value;
  }

  String get lastName => _lastName;

  set lastName(String value) {
    _lastName = value;
  }

  String get firstName => _firstName;

  set firstName(String value) {
    _firstName = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }
}
