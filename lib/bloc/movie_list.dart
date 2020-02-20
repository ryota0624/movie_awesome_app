import 'dart:async';

import 'package:movie_awesome_app/model/movie.dart';
import 'package:movie_awesome_app/model/movies.dart';
import 'package:movie_awesome_app/model/paging_collection.dart';
import 'package:tuple/tuple.dart';

class MovieListBloc {
  MovieListBloc(this._movies) {
    _similarController.stream.listen((d) {
      print("received $d ${d.hashCode}");
    });
  }

  final Movies _movies;

  final StreamController<PagingCollection<Movie>> _recentController =
      StreamController.broadcast();

  Stream<PagingCollection<Movie>> get recentMovies => _recentController.stream;

  Future<void> fetchRecentMovies({Page page}) async {
    await _recentController.addStream(_movies.recentMovies().asStream());
  }

  final StreamController<PagingCollection<Movie>>
      _similarController = StreamController.broadcast();

  Stream<PagingCollection<Movie>> get similarMovies$ =>
      _similarController.stream;

  Future<PagingCollection<Movie>> similarMovies(MovieID id) =>
      _movies.similarMovies(id);

  Future<void> fetchSimilarMovies(MovieID id, {Page page}) async {
    final movies = await _movies.similarMovies(id);
    print("fetchSimilarMovies");
    _similarController.sink.add(movies);
  }
}

// Stream のインスタンスが変わっているから空になっている。