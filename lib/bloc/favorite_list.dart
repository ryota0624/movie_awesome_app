import 'dart:async';

import 'package:movie_awesome_app/model/favorite.dart';
import 'package:movie_awesome_app/model/movie.dart';
import 'package:movie_awesome_app/model/paging_collection.dart';

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

  final StreamController<Favorite> _favoriteController =
  StreamController.broadcast();

  Stream<Favorite> favorite(MovieID id) => //_favoriteController.stream;
      _favoriteController.stream.where((f) => f.movieID == id);

  Future<void> fetchFavoriteByMovie(MovieID movieID) async {
    final f = await _favorites.getByMovie(movieID);
    print("fetchFavoriteByMovie $f $movieID");
    _favoriteController.add(f);
  }
}

