import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickbite/services/home_repository.dart';
import 'package:quickbite/services/mock_home_repository.dart';

final homeRepositoryProvider = Provider<HomeRepository>(
  (ref) => const MockHomeRepository(),
);
