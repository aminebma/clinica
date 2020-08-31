class Patient {
  String _id, _firstName, _lastName, _sex, _phoneNumber, _address, _mail;

  Patient(
      {String id,
      String firstName,
      String lastName,
      String sex,
      String phoneNumber,
      String address,
      String mail})
      : _id = id,
        _firstName = firstName,
        _lastName = lastName,
        _sex = sex,
        _phoneNumber = phoneNumber,
        _address = address,
        _mail = mail;

  get mail => _mail;

  set mail(value) {
    _mail = value;
  }

  String get address => _address;

  set address(String value) {
    _address = value;
  }

  String get phoneNumber => _phoneNumber;

  set phoneNumber(String value) {
    _phoneNumber = value;
  }

  String get sex => _sex;

  set sex(String value) {
    _sex = value;
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
