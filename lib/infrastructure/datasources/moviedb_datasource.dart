import 'package:cinemapedia/config/constants/environment.dart';
import 'package:cinemapedia/domain/datasources/movies_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/infrastructure/mappers/movie_mapper.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/moviedb_response.dart';
import 'package:dio/dio.dart';

class MovieDbDatasource extends MoviesDatasource {
  final dio = Dio(BaseOptions(
    baseUrl: 'https://api.themoviedb.org/3',
    queryParameters: {'api_key': Environment.movieDBKey, 'language': 'es-MX'},
  ));
  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async =>
      _getMoviesByUrl('/movie/now_playing', page);

  @override
  Future<List<Movie>> getPopular({int page = 1}) async =>
      _getMoviesByUrl('/movie/popular', page);

  @override
  Future<List<Movie>> getTopRated({int page = 1}) async =>
      _getMoviesByUrl('/movie/top_rated', page);

  @override
  Future<List<Movie>> getUpComing({int page = 1}) async =>
      _getMoviesByUrl('/movie/upcoming', page);

  Future<List<Movie>> _getMoviesByUrl(String path, int page) async {
    final response = await dio.get(path, queryParameters: {'page': page});
    return _jsonToMovies(response.data);
  }

  List<Movie> _jsonToMovies(Map<String, dynamic> json) {
    final movieDBResponse = MovieDbResponse.fromJson(json);
    final List<Movie> movies = movieDBResponse.results
        .where((movieDB) => movieDB.posterPath != 'no-poster')
        .map((movieDB) => MovieMapper.movieDBToEntity(movieDB))
        .toList();
    return movies;
  }
}
