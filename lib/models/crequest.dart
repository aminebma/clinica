class CRequest {
  String _id,
      _patientId,
      _doctorId,
      _patientFirstName,
      _patientLastName,
      _treatments,
      _picture,
      _response,
      _status;

  List<String> _symptoms;

  CRequest(
      {String id,
      String patientId,
      String doctorId,
      String patientFirstName,
      String patientLastName,
      List<String> symptoms,
      String treatments,
      String picture,
      String response,
      String status})
      : _id = id,
        _patientId = patientId,
        _doctorId = doctorId,
        _patientFirstName = patientFirstName,
        _patientLastName = patientLastName,
        _symptoms = symptoms,
        _treatments = treatments,
        _picture = picture,
        _response = response,
        _status = status;

  String get picture => _picture;

  set picture(String value) {
    _picture = value;
  }

  String get treatments => _treatments;

  set treatments(String value) {
    _treatments = value;
  }

  String get patientLastName => _patientLastName;

  set patientLastName(String value) {
    _patientLastName = value;
  }

  String get patientFirstName => _patientFirstName;

  set patientFirstName(String value) {
    _patientFirstName = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  List<String> get symptoms => _symptoms;

  set symptoms(List<String> value) {
    _symptoms = value;
  }

  get status => _status;

  set status(value) {
    _status = value;
  }

  get response => _response;

  set response(value) {
    _response = value;
  }

  get doctorId => _doctorId;

  set doctorId(value) {
    _doctorId = value;
  }

  get patientId => _patientId;

  set patientId(value) {
    _patientId = value;
  }
}
