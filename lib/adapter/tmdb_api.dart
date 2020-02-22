import 'package:movie_awesome_app/model/movie.dart';
import 'package:movie_awesome_app/model/movies.dart';
import 'package:movie_awesome_app/model/paging_collection.dart';
import 'package:tmdb_client/tmdb_client.dart' as tmdb;

class MoviesOnTmdbApi extends Movies {
  MoviesOnTmdbApi(this._tmdbResolver);

  final tmdb.TmdbResolver _tmdbResolver;

  final Map<int, Movie> _cache = Map.identity();

  @override
  Future<PagingCollection<Movie>> recentMovies({Page page}) async {
    final movies = await _tmdbResolver.discoverMovie(page: page.asInt());
    final c = PagingCollection(
        page,
        movies.results
            .map((m) => Movie(
                  MovieID(m.id.toString()),
                  m.posterPath,
                  m.title,
                ))
            .toList());
    c.toList().forEach((m) {
      _cache[m.id.hashCode] = m;
    });
    return c;
  }

  @override
  Future<PagingCollection<Movie>> similarMovies(MovieID id, {Page page}) async {
    final movieIDInt = int.parse(id.toString());
    final movies = await _tmdbResolver.similarMovies(movieIDInt);
    final c = PagingCollection(
        page,
        movies.results
            .map((m) => Movie(
                  MovieID(m.id.toString()),
                  m.posterPath,
                  m.title,
                ))
            .toList());
    c.toList().forEach((m) {
      _cache[m.id.hashCode] = m;
    });
    return c;
  }

  @override
  Future<List<Movie>> getByIDs(List<MovieID> ids) async {
    print('Movies.getByIDs(${ids})');
    return _cache.values.where((element) => ids.contains(element.id)).toList();
  }
}
