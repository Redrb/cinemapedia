import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/creditsdb_response.dart';

class ActorMapper {
  static Actor castDBToEntity(Cast cast) => Actor(
        id: cast.id,
        name: cast.name,
        profilePath: cast.profilePath != null && cast.profilePath != ''
            ? 'https://image.tmdb.org/t/p/w500${cast.profilePath}'
            : 'https://www.pngitem.com/pimgs/m/287-2876223_no-profile-picture-available-hd-png-download.png',
        character: cast.character ?? '',
      );
}
