import 'package:movie_awesome_app/model/paging_collection.dart';

import 'movie.dart';

abstract class Movies {
  Future<PagingCollection<Movie>> recentMovies({Page page});
  Future<PagingCollection<Movie>> similarMovies(MovieID id, {Page page});
  Future<List<Movie>> getByIDs(List<MovieID> ids);
}

class ResourceGetError implements Exception {}