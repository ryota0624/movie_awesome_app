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

  Stream<PagingCollection<Movie>> recentMovies({Page page}) =>
      _recentController.stream
          .where((c) => page == null ? true : c.equalPage(page));

  Future<void> fetchRecentMovies({Page page = Page.initial}) async {
    final movies = await _movies.recentMovies(page: page);
    _recentController.add(movies);
  }

  final StreamController<Tuple2<MovieID, PagingCollection<Movie>>>
      _similarController = StreamController.broadcast();

  Stream<PagingCollection<Movie>> similarMovies$(MovieID id) =>
      _similarController.stream.where((t) => t.item1 == id).map((t) => t.item2);

  Future<void> fetchSimilarMovies(MovieID id, {Page page}) async {
    final movies = await _movies.similarMovies(id);
    _similarController.sink.add(Tuple2(id, movies));
  }
}
