import 'package:events_app/controllers/client_controller.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OauthService {
  final String webClientId = dotenv.env['GOOGLE_CLIENT_ID']!;
  final ClientController _clientController = ClientController();

  Future<AuthResponse?> googleSignIn() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(serverClientId: webClientId);
      final googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        /// Caso in cui l'utente chiude il pop-up senza scegliere un account
        print('Login canceled by user.');
        return null;
      }

      final googleAuth = await googleUser.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (accessToken == null || idToken == null) {
        throw 'Missing Google access token or ID token.';
      }

      /// Login in Supabase
      return await _clientController.client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );
    } catch (e) {
      print('Error during Google Sign-In: $e');
      return null;
    }
  }

  Future<void> googleLogout() async {
    try {
      /// Disconnessione da Google
      final googleSignIn = GoogleSignIn();
      if (await googleSignIn.isSignedIn()) {
        await googleSignIn.disconnect();
        print('User disconnected from Google.');
      }

      /// Logout da Supabase
      await _clientController.client.auth.signOut();
      print('User logged out from Supabase.');

      final userAfterLogout = await _clientController.user;
      if (userAfterLogout == null) {
        print('User successfully logged out from all services.');
      } else {
        print('Logout failed. User is still logged in: ${await _clientController.userEmail}');
      }
    } catch (e) {
      print('Error during logout: $e');
    }
  }
}
