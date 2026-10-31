import 'package:creditsea/core/utils/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Validators.mobile', () {
    test('accepts a 10 digit number starting 6-9', () {
      expect(Validators.mobile('9876543210'), isNull);
    });

    test('rejects short numbers and numbers starting below 6', () {
      expect(Validators.mobile('98765'), isNotNull);
      expect(Validators.mobile('5876543210'), isNotNull);
      expect(Validators.mobile(''), isNotNull);
    });
  });

  group('Validators.pan', () {
    test('accepts the standard format in either case', () {
      expect(Validators.pan('ABCDE1234F'), isNull);
      expect(Validators.pan('abcde1234f'), isNull);
    });

    test('rejects malformed PANs', () {
      expect(Validators.pan('ABCD1234EF'), isNotNull);
      expect(Validators.pan('ABCDE12345'), isNotNull);
    });
  });

  group('Validators.password', () {
    test('needs 8 characters and a special character', () {
      expect(Validators.password('Strong@123'), isNull);
      expect(Validators.password('short@1'), isNotNull);
      expect(Validators.password('NoSpecial123'), isNotNull);
    });

    test('confirm must match the original', () {
      final check = Validators.confirmPassword(() => 'Strong@123');
      expect(check('Strong@123'), isNull);
      expect(check('Different@1'), isNotNull);
    });
  });

  group('Validators.ageOn', () {
    test('does not count a birthday that has not happened yet', () {
      final dob = DateTime(2000, 6, 15);
      expect(Validators.ageOn(dob, DateTime(2026, 6, 14)), 25);
      expect(Validators.ageOn(dob, DateTime(2026, 6, 15)), 26);
    });
  });
}
