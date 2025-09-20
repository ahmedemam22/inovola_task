import 'package:get_it/get_it.dart';
import 'injection.dart';

// Legacy service locator - now just forwards to Injectable
final GetIt sl = getIt;

Future<void> setupServiceLocator() async {
  await configureDependencies();
}

// Helper method to reset service locator (useful for testing)
Future<void> resetServiceLocator() async {
  await getIt.reset();
  await configureDependencies();
}