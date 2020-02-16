import 'dart:async';

import 'package:movie_awesome_app/model/movie.dart';
import 'package:movie_awesome_app/model/movies.dart';
import 'package:movie_awesome_app/model/paging_collection.dart';
import 'package:tuple/tuple.dart';

class MovieListBloc {
  MovieListBloc(this._movies);

  final Movies _movies;

  final StreamController<PagingCollection<Movie>> _recentController =
      StreamController.broadcast();

  Stream<PagingCollection<Movie>> get recentMovies => _recentController.stream;

  Future<void> fetchRecentMovies({Page page}) async {
    await _recentController.addStream(_movies.recentMovies().asStream());
  }

  final StreamController<Tuple2<MovieID, PagingCollection<Movie>>>
      _similarController = StreamController.broadcast();

  Stream<PagingCollection<Movie>> similarMovies(MovieID id) =>
      _similarController.stream.where((m) => m.item1 == id).map((t) => t.item2);

  Future<void> fetchSimilarMovies(MovieID id, {Page page}) async {
    final m = await _movies.similarMovies(id);
    _similarController.add(Tuple2(id, m));
  }
}
