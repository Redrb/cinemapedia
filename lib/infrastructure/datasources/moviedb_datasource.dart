import 'package:cinemapedia/config/constants/environment.dart';
import 'package:cinemapedia/domain/datasources/movies_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/infrastructure/mappers/movie_mapper.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/movie_movidedb_details.dart';
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
  Future<List<Movie>> getUpComing({int page = 1}) async {
    final response =
        await dio.get('/movie/upcoming', queryParameters: {'page': page});
    final movieDBResponse = MovieDbResponse.fromJson(response.data);
    final List<Movie> movies = movieDBResponse.results
        .where((movieDB) {
          final releasedDate = movieDB.releaseDate;
          final hasReleaseDate = releasedDate != null;
          if (hasReleaseDate) {
            return releasedDate.compareTo(DateTime.now()) > 0;
          }
          return false;
        })
        .map((movieDB) => MovieMapper.movieDBToEntity(movieDB))
        .toList();
    return movies;
  }

  @override
  Future<Movie> getMovieById(String id) async {
    final response = await dio.get('/movie/$id');
    if (response.statusCode != 200) {
      throw Exception('Moviewith id $id not found');
    }
    final movieDBDetails = MovieDbDetails.fromJson(response.data);
    final Movie movie = MovieMapper.movieDetailsToEntity(movieDBDetails);
    return movie;
  }

  @override
  Future<List<Movie>> searchMovies(String query) async {
    if (query.isEmpty) {
      return [];
    }
    return _searchMoviesByquery(query);
  }

  Future<List<Movie>> _searchMoviesByquery(String query) async {
    final response =
        await dio.get('/search/movie', queryParameters: {'query': query});
    return _jsonToMovies(response.data);
  }

  Future<List<Movie>> _getMoviesByUrl(String path, int page) async {
    final response = await dio.get(path, queryParameters: {'page': page});
    return _jsonToMovies(response.data);
  }

  List<Movie> _jsonToMovies(Map<String, dynamic> json) {
    final movieDBResponse = MovieDbResponse.fromJson(json);
    final List<Movie> movies = movieDBResponse.results
        .map((movieDB) => MovieMapper.movieDBToEntity(movieDB))
        .toList();
    return movies;
  }
}
