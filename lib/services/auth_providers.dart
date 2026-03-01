import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickbite/services/auth_repository.dart';
import 'package:quickbite/services/mock_auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => const MockAuthRepository(),
);
