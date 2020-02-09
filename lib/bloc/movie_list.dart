import 'package:movie_awesome_app/model/movie.dart';
import 'package:movie_awesome_app/model/movies.dart';
import 'package:movie_awesome_app/model/paging_collection.dart';
import 'package:movie_awesome_app/model/remote_data.dart';

class MovieList {
  MovieList(this._movies);
  final Movies _movies;

  AppendableRemotePagingCollection<Movie> _recent;

  Future<void> fetchRecentMovies({Page page}) async {
    try {
      _recent = _recent.loadNext();
      final recent = await _movies.recentMovies();
      _recent = _recent.append(Success(recent));
    } on ResourceGetError catch(e) {
      _recent = _recent.append(Failure(e));
    }
  }
}