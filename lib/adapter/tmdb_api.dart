import 'package:movie_awesome_app/model/movies.dart';
import 'package:tmdb_client/tmdb_client.dart';

class TmdbApi extends Movies {
  TmdbApi(this._tmdbResolver);

  final TmdbResolver _tmdbResolver;
}