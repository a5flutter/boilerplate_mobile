import 'package:rxdart/rxdart.dart';

BehaviorSubject<String> errorStreamController = BehaviorSubject<String>();
Stream<String> httpErrorsStream = errorStreamController.stream;

// ignore: avoid_classes_with_only_static_members
class HttpErrors {
  static bool haveConnectionError = false;

  ///All possible error list
  static const errorList = [
    'detail',
    'email',
    'first_name',
    'middle_name',
    'last_name',
    'primary_phone',
    'secondary_phone',
    'address',
    'marital',
    'password',
    'is_accredited',
    'is_licensed',
    'is_agree_terms_and_use',
    'token',
    'current_password',
    'new_password',
    'phone_number',
    'code',
    'email',
    'relationship',
    'prefix',
    'street',
    'city',
    'state',
    'zip_code',
    'note',
    'name',
    'message',
    'error',
  ];

  static void pushError(String error) {
    errorStreamController.add(error);
  }

  static void pushConnectionError() {
    if (!haveConnectionError) {
      haveConnectionError = true;
      errorStreamController.add('Something_went_wrong');
    }
  }

  static void clearError() {
    errorStreamController.add('');
  }

  static String getErrorFromJson( dynamic errorData) {
    if (errorData is Map){
      for(final error in errorList){
        if (errorData.containsKey(error)){
          if(errorData[error] is Map){
            return getErrorFromJson(errorData[error]);
          }
          return getErrorFromJsonField(errorData[error]);
        }
      }
      return 'Unexpected error';
    }
    return 'Unexpected error';
  }

  static String getErrorFromJsonField(dynamic field) {
    if (field is List) {
      return field[0] as String;
    } else {
      return field as String;
    }
  }
}
