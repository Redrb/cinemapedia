
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../infrastructure/datasources/actor_moviedb_datasource.dart';
import '../../../infrastructure/repositories/actor_repository_impl.dart';

//? repositorio inmutable (solo lectura)
final actorsRepositoryProvider = Provider((ref) {
  return ActorRepositoryImpl(ActorMoviedbDatasource());
});
