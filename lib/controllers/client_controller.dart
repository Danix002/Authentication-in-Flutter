import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ClientController {
  static final ClientController _instance = ClientController._internal();

  factory ClientController() {
    return _instance;
  }

  ClientController._internal();

  late final SupabaseClient _supabaseClient = SupabaseClient(
    dotenv.env['PUBLIC_SUPABASE_URL']!,
    dotenv.env['PUBLIC_SUPABASE_ANON_KEY']!,
    authOptions: const AuthClientOptions(authFlowType: AuthFlowType.implicit),
  );

  SupabaseClient get client => _supabaseClient;

  Future<Session?> get session async => _supabaseClient.auth.currentSession;

  Future<User?> get user async => _supabaseClient.auth.currentUser;

  Future<String?> get userEmail async => _supabaseClient.auth.currentUser?.email;

  Future<String?> get userId async => _supabaseClient.auth.currentUser?.id;

  Future<String?> get userFullName async => _supabaseClient.auth.currentUser?.userMetadata?['full_name'];
}

