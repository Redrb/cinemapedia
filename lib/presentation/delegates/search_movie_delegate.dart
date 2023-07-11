import 'dart:async';
import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter/material.dart';

typedef SearchMoviesCallback = Future<List<Movie>> Function(String query);

class SearchMovieDelegate extends SearchDelegate<Movie?> {
  final SearchMoviesCallback searchMovies;
  List<Movie> initialMovies;
  StreamController<List<Movie>> debouncedMovies = StreamController.broadcast();
  StreamController<bool> isLoadingStream = StreamController.broadcast();
  Timer? _debounceTimer;

  SearchMovieDelegate(
      {required this.searchMovies, required this.initialMovies});

  void _onqueryChanged(String query) {
    if (query.isNotEmpty) {
      isLoadingStream.add(true);
    }
    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer!.cancel();
    }
    _debounceTimer = Timer(const Duration(milliseconds: 700), () async {
      final movies = await searchMovies(query);
      debouncedMovies.add(movies);
      initialMovies = movies;
      isLoadingStream.add(false);
    });
  }

  void clearStreams() {
    debouncedMovies.close();
    isLoadingStream.close();
  }

  @override
  String get searchFieldLabel => 'Buscar película';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      StreamBuilder(
        stream: isLoadingStream.stream,
        initialData: false,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return snapshot.data
              ? SpinPerfect(
                  duration: const Duration(seconds: 20),
                  spins: 10,
                  infinite: true,
                  child: IconButton(
                    onPressed: () => query = '',
                    icon: const Icon(Icons.refresh),
                  ),
                )
              : FadeIn(
                  animate: query.isNotEmpty,
                  child: IconButton(
                    onPressed: () => query = '',
                    icon: const Icon(Icons.clear),
                  ),
                );
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        clearStreams();
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back_ios_new_outlined),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _getSearchMoviesBuilder();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    _onqueryChanged(query);
    return _getSearchMoviesBuilder();
  }

  StreamBuilder _getSearchMoviesBuilder() {
    return StreamBuilder(
      initialData: initialMovies,
      stream: debouncedMovies.stream,
      builder: (context, snapshot) {
        final movies = snapshot.data ?? [];
        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (context, index) {
            return _MovieSearchItem(
              movie: movies[index],
              onMovieSelected: (context, movie) {
                clearStreams();
                close(context, movie);
              },
            );
          },
        );
      },
    );
  }
}

class _MovieSearchItem extends StatelessWidget {
  final Movie movie;
  final Function onMovieSelected;
  const _MovieSearchItem({required this.movie, required this.onMovieSelected});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textStyles = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        onMovieSelected(context, movie);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          //image
          SizedBox(
            width: size.width * 0.25,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                movie.posterPath,
                loadingBuilder: (context, child, loadingProgress) =>
                    FadeIn(child: child),
              ),
            ),
          ),
          SizedBox(width: size.width * 0.05),

          //description

          SizedBox(
            width: size.width * 0.65,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(movie.title, style: textStyles.titleMedium),
                (movie.overview.length > 100)
                    ? Text('${movie.overview.substring(0, 100)}...')
                    : Text(movie.overview),
                Row(
                  children: [
                    Icon(
                      Icons.star_half_rounded,
                      color: Colors.yellow.shade800,
                    ),
                    const SizedBox(width: 5),
                    Text(HumanFormats.number(movie.voteAverage, decimals: 1),
                        style: textStyles.bodyMedium
                            ?.copyWith(color: Colors.yellow.shade800))
                  ],
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }
}
