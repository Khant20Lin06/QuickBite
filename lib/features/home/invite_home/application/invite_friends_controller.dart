import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickbite/features/home/domain/home_models.dart';
import 'package:quickbite/services/home_providers.dart';

final inviteFriendsOverviewProvider = FutureProvider<InviteFriendsOverview>((
  ref,
) async {
  return ref.read(homeRepositoryProvider).getInviteFriends();
});
