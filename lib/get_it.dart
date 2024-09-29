import 'package:get_it/get_it.dart';

import 'company_repository.dart';
import 'company_repository_impl.dart';

final GetIt getIt = GetIt.instance;

void setup() {
  getIt.registerLazySingleton<CompanyRepository>(() => CompanyRepositoryImpl());
}
