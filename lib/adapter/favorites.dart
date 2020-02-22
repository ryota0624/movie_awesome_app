
import 'dart:collection';

import 'package:movie_awesome_app/model/favorite.dart';
import 'package:movie_awesome_app/model/movie.dart';
import 'package:movie_awesome_app/model/paging_collection.dart';

class FavoritesOnMemory extends Favorites {
  final _data = LinkedHashMap<int, Favorite>.identity();
  @override
  Future<PagingCollection<Favorite>> allFavorites() async {
    return PagingCollection(Page.initial, _data.values.toList());
  }

  @override
  Future<Favorite> getByMovie(MovieID id) async {
    return _data[id.hashCode];
  }

  @override
  Future<void> remove(Favorite f) {
    _data.remove(f.movieID.hashCode);
  }

  @override
  Future<void> store(Favorite f) {
    if (_data.containsKey(f.movieID.hashCode)) {
      return Future.value();
    }
    _data[f.movieID.hashCode] = f;
  }

  @override
  Future<int> allFavoriteCount() async {
    return _data.values.length;
  }
}