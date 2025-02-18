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

  Future<void> fetchRecentMovies({Page page}) async {
    page ??= Page.initial;
    final movies = await _movies.recentMovies(page: page);
    _recentController.add(movies);
  }

  final StreamController<Tuple2<MovieID, PagingCollection<Movie>>>
      _similarController = StreamController.broadcast();

  Stream<PagingCollection<Movie>> similarMovies$(MovieID id) =>
      _similarController.stream.where((t) => t.item1 == id).map((t) => t.item2);

  Future<void> fetchSimilarMovies(MovieID id, {Page page}) async {
    final movies = await _movies.similarMovies(id);
    print("fetchSimilarMovies $id");
    _similarController.sink.add(Tuple2(id, movies));
  }

  final StreamController<Tuple2<List<MovieID>, List<Movie>>>
  _moviesByIDsController = StreamController.broadcast();

  Stream<List<Movie>> moviesByIDs$(List<MovieID> ids) =>
      _moviesByIDsController.stream
          .where((t) => t.item1.hashCode == ids.hashCode).map((t) => t.item2);

  Future<void> fetchMoviesByIDs(List<MovieID> ids) async {
    final movies = await _movies.getByIDs(ids);
    _moviesByIDsController.sink.add(Tuple2(ids, movies));
  }
}
