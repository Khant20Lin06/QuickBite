import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickbite/features/home/domain/home_models.dart';
import 'package:quickbite/services/home_providers.dart';

final helpCenterOverviewProvider = FutureProvider<HelpCenterOverview>((
  ref,
) async {
  return ref.read(homeRepositoryProvider).getHelpCenter();
});

final helpSearchQueryProvider =
    NotifierProvider<HelpSearchQueryController, String>(
      HelpSearchQueryController.new,
    );

class HelpSearchQueryController extends Notifier<String> {
  @override
  String build() => '';

  void setQuery(String value) => state = value;
}
