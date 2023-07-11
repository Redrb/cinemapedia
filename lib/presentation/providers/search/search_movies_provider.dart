import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');

final searchedMoviesProvider =
    StateNotifierProvider<SearchMoviesNotifier, List<Movie>>((ref) {
  final movieRepository = ref.read(movieRepositoryProvider);
  return SearchMoviesNotifier(
      searchMovies: movieRepository.searchMovies, ref: ref);
});

typedef SeachrMoviesCallBack = Future<List<Movie>> Function(String query);

class SearchMoviesNotifier extends StateNotifier<List<Movie>> {
  final SeachrMoviesCallBack searchMovies;
  final Ref ref;
  SearchMoviesNotifier({
    required this.searchMovies,
    required this.ref,
  }) : super([]); //estado inicial

  Future<List<Movie>> searchMoviesByQuery(String query) async {
    ref.read(searchQueryProvider.notifier).update((state) => query);
    final List<Movie> movies = await searchMovies(query);
    state = movies;
    return movies;
  }
}
