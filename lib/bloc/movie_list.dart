import 'dart:async';

import 'package:movie_awesome_app/model/movie.dart';
import 'package:movie_awesome_app/model/movies.dart';
import 'package:movie_awesome_app/model/paging_collection.dart';

class MovieListBloc {
  MovieListBloc(this._movies);

  final Movies _movies;

  final StreamController<PagingCollection<Movie>> _recentController =
      StreamController.broadcast();

  Stream<PagingCollection<Movie>> get recentMovies =>
      _recentController.stream;

  Future<void> fetchRecentMovies({Page page}) async {
    await _recentController.addStream(_movies.recentMovies().asStream());
  }
}
