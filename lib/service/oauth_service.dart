import 'package:events_app/controllers/client_controller.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase/supabase.dart';

class OauthService {
  final String  webClientId = dotenv.env['GOOGLE_CLIENT_ID']!;
  ClientController clientController = ClientController();

  Future<AuthResponse> googleSignIn() async {
    clientController.initIstance();

    final GoogleSignIn googleSignIn = GoogleSignIn(
      serverClientId: webClientId
    );
    final googleUser = await googleSignIn.signIn();
    final googleAuth = await googleUser!.authentication;
    final accessToken = googleAuth.accessToken;
    final idToken = googleAuth.idToken;
    final session = await clientController.getSession();

    if (accessToken == null) {
      throw 'No Access Token found.';
    }
    if (idToken == null) {
      throw 'No ID Token found.';
    }

    print('Access token: $accessToken, ID token: $idToken');
    print('User info: ${googleUser.email}');

    return clientController.supabaseClient.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );
  }

  // TODO: logout
}
