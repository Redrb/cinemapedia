import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/movie_moviedb.dart';

import '../models/moviedb/movie_movidedb_details.dart';

class MovieMapper {
  static Movie movieDBToEntity(MovieFromMovideDB movieDB) => Movie(
      adult: movieDB.adult,
      backdropPath: movieDB.backdropPath != ''
          ? 'https://image.tmdb.org/t/p/w500${movieDB.backdropPath}'
          : 'https://sd.keepcalms.com/i/keep-calm-poster-not-found.png',
      genres: movieDB.genreIds.map((e) {
        return MovieGenre(id: e.toString(), name: '');
      }).toList(),
      id: movieDB.id,
      originalLanguage: movieDB.originalLanguage,
      originalTitle: movieDB.originalTitle,
      overview: movieDB.overview,
      popularity: movieDB.popularity,
      posterPath: movieDB.posterPath != ''
          ? 'https://image.tmdb.org/t/p/w500${movieDB.posterPath}'
          : 'https://sd.keepcalms.com/i/keep-calm-poster-not-found.png',
      releaseDate: movieDB.releaseDate,
      title: movieDB.title,
      video: movieDB.video,
      voteAverage: movieDB.voteAverage,
      voteCount: movieDB.voteCount);

  static Movie movieDetailsToEntity(MovieDbDetails movieDB) => Movie(
      adult: movieDB.adult,
      backdropPath: movieDB.backdropPath != ''
          ? 'https://image.tmdb.org/t/p/w500${movieDB.backdropPath}'
          : 'https://sd.keepcalms.com/i/keep-calm-poster-not-found.png',
      genres: movieDB.genres.map((genreDB) {
        return MovieGenre(id: genreDB.id.toString(), name: genreDB.name);
      }).toList(),
      id: movieDB.id,
      originalLanguage: movieDB.originalLanguage,
      originalTitle: movieDB.originalTitle,
      overview: movieDB.overview,
      popularity: movieDB.popularity,
      posterPath: movieDB.posterPath != ''
          ? 'https://image.tmdb.org/t/p/w500${movieDB.posterPath}'
          : 'https://sd.keepcalms.com/i/keep-calm-poster-not-found.png',
      releaseDate: movieDB.releaseDate,
      title: movieDB.title,
      video: movieDB.video,
      voteAverage: movieDB.voteAverage,
      voteCount: movieDB.voteCount);
}
