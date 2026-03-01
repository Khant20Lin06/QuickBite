import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickbite/features/home/domain/home_models.dart';
import 'package:quickbite/services/home_providers.dart';

final appSettingsOverviewProvider = FutureProvider<AppSettingsOverview>((
  ref,
) async {
  return ref.read(homeRepositoryProvider).getAppSettings();
});

final selectedAppLanguageProvider =
    NotifierProvider<SelectedAppLanguageController, String>(
      SelectedAppLanguageController.new,
    );

class SelectedAppLanguageController extends Notifier<String> {
  @override
  String build() => 'EN';

  void select(String language) => state = language;
}
