import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ClientController {
  late final SupabaseClient supabaseClient;
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  ClientController() {
    supabaseClient = SupabaseClient(
      dotenv.env['PUBLIC_SUPABASE_URL']!,
      dotenv.env['PUBLIC_SUPABASE_ANON_KEY']!,
        authOptions: const AuthClientOptions(authFlowType: AuthFlowType.implicit)
    );
  }

  SupabaseClient initIstance() {
    final String supabaseUrl = dotenv.env['PUBLIC_SUPABASE_URL']!;
    final String supabaseAnonKey = dotenv.env['PUBLIC_SUPABASE_ANON_KEY']!;

    return SupabaseClient(supabaseUrl, supabaseAnonKey);
  }

  Future<Session?> getSession() async {
    final session = supabaseClient.auth.currentSession;
    return session;
  }

  Future<User?> getUser() async {
    final user = supabaseClient.auth.currentUser;
    return user;
  }
}
