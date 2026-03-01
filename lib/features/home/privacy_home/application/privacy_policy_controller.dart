import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickbite/features/home/domain/home_models.dart';
import 'package:quickbite/services/home_providers.dart';

final privacyPolicyOverviewProvider = FutureProvider<PrivacyPolicyOverview>((
  ref,
) async {
  return ref.read(homeRepositoryProvider).getPrivacyPolicy();
});
