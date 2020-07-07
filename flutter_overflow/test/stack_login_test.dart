import 'package:flutter_overflow/pages/stack_login.dart';
import 'package:flutter_test/flutter_test.dart';void main(){
  group('stack_login',(){
    test('stack_login constructor test', (){
      final stack_login = StackLoginWebViewPage(
        clientId: 'test_id',
        clientSecret: 'test_secret',
        scope: ['test_scope'],
        redirectUrl: 'test_url',
      );

      expect(stack_login.clientId, 'test_id');
      expect(stack_login.clientSecret, 'test_secret');
      expect(stack_login.scope, ['test_scope']);
      expect(stack_login.redirectUrl, 'test_url');
    });
  });
}