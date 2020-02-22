import 'dart:async';

import 'package:movie_awesome_app/model/favorite.dart';
import 'package:movie_awesome_app/model/movie.dart';
import 'package:movie_awesome_app/model/paging_collection.dart';
import 'package:tuple/tuple.dart';

class FavoriteListBloc {
  FavoriteListBloc(this._favorites);

  final Favorites _favorites;

  final StreamController<PagingCollection<Favorite>> _allFavoritesController =
      StreamController.broadcast();

  Stream<PagingCollection<Favorite>> get allFavorites =>
      _allFavoritesController.stream;

  Future<void> fetchAllFavorites({Page page}) async {
    await _allFavoritesController
        .addStream(_favorites.allFavorites().asStream());
  }

  Future<int> allFavoriteCount() async {
    return _favorites.allFavoriteCount();
  }

  final StreamController<Tuple2<MovieID, Favorite>> _favoriteController =
      StreamController.broadcast();

  Stream<Favorite> favorite$(MovieID id) {
    return _favoriteController.stream.where((f) {
      return f.item1 == id;
    }).map((f) => f.item2);
  }

  Future<Favorite> favorite(MovieID id) {
    return _favorites.getByMovie(id);
  }

  Future<void> fetchFavoriteByMovie(MovieID movieID) async {
    final f = await _favorites.getByMovie(movieID);
    print("fetchFavoriteByMovie $f $movieID");
    _favoriteController.add(Tuple2(movieID, f));
  }
}
