import 'package:dio/dio.dart';
import '../../domain/datasources/actors_datasource.dart';
import 'package:cinemapedia/config/constants/environment.dart';
import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/infrastructure/mappers/actor_mapper.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/creditsdb_response.dart';

class ActorMoviedbDatasource extends ActorsDatasource {
  final dio = Dio(BaseOptions(
    baseUrl: 'https://api.themoviedb.org/3',
    queryParameters: {'api_key': Environment.movieDBKey, 'language': 'es-MX'},
  ));

  @override
  Future<List<Actor>> getActorsByMovie(String movieId) async {
    final response = await dio.get('/movie/$movieId/credits');
    final actorDBResponse = CreditsDbResponse.fromJson(response.data);
    final List<Actor> actors = actorDBResponse.cast
        .map((cast) => ActorMapper.castDBToEntity(cast))
        .toList();
    return actors;
  }
}
