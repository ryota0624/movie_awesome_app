
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
    return _data[id.toString().hashCode];
  }

  @override
  Future<void> remove(Favorite f) {
    _data.remove(f.movieID.toString().hashCode);
  }

  @override
  Future<void> store(Favorite f) {
    _data[f.movieID.toString().hashCode] = f;
  }
}