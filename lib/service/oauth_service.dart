import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:auth0_flutter/auth0_flutter_web.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class OauthService {
  late Auth0 auth0 = Auth0(dotenv.env['AUTH0_DOMAIN']!, dotenv.env['AUTH0_CLIENT_ID']!);
  late Auth0Web auth0Web = Auth0Web(dotenv.env['AUTH0_DOMAIN']!, dotenv.env['AUTH0_CLIENT_ID']!);

  Future<void> login() async {
    try {
      if (kIsWeb) {
        return auth0Web.loginWithRedirect(redirectUrl: 'http://localhost:3000');
      }

      var credentials = await auth0
          .webAuthentication(scheme: dotenv.env['AUTH0_CUSTOM_SCHEME'])
          // Use a Universal Link callback URL on iOS 17.4+ / macOS 14.4+
          // useHTTPS is ignored on Android
          .login(useHTTPS: true);

      if (kDebugMode) {
        print(credentials.user);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> logout() async {
    try {
      if (kIsWeb) {
        await auth0Web.logout(returnToUrl: 'https://localhost:3000');
      } else {
        await auth0
            .webAuthentication(scheme: dotenv.env['AUTH0_CUSTOM_SCHEME'])
            // Use a Universal Link logout URL on iOS 17.4+ / macOS 14.4+
            // useHTTPS is ignored on Android
            .logout(useHTTPS: true);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}