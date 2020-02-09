import 'package:movie_awesome_app/model/paging_collection.dart';

import 'movie.dart';

class Favorite {
  Favorite(this.movieID, this.favoriteAt);

  final MovieID movieID;
  final DateTime favoriteAt;
}

abstract class Favorites {
  Future<void> store(Favorite f);
  Future<void> remove(Favorite f);

  Future<Favorite> getByMovie(MovieID id);

  Future<PagingCollection<Favorite>> allFavorites();
}
