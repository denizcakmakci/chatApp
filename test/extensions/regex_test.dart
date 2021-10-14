import 'package:flutter_template/core/init/extensions/string/validation_extensions.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  setUp(() {});

  test('Email Regex', () {
    var email = 'dnzckmc@gmail.com';
    expect(email.isValidEmail, true);
  });
}
