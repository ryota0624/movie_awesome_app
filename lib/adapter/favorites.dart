import 'package:movie_awesome_app/model/favorite.dart';
import 'package:movie_awesome_app/model/movie.dart';
import 'package:movie_awesome_app/model/paging_collection.dart';

class FavoritesOnMemory extends Favorites {
  final _data = Map<MovieID, Favorite>.identity();
  @override
  Future<PagingCollection<Favorite>> allFavorites() async {
    return PagingCollection(Page.initial, _data.values.toList());
  }

  @override
  Future<Favorite> getByMovie(MovieID id) async {
    if (_data.containsKey(id)) {
      return _data[id];
    }
    return null;
  }

  @override
  Future<void> remove(Favorite f) {
    _data.remove(f.movieID);
  }

  @override
  Future<void> store(Favorite f) {
    _data[f.movieID] = f;
  }
}