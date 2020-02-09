import 'package:movie_awesome_app/model/favorite.dart';
import 'package:movie_awesome_app/model/movie.dart';

abstract class DateTimeFactory {
  DateTime createNow();
}

class DateTimeFactoryOnCore extends DateTimeFactory {
  @override
  DateTime createNow() => DateTime.now();

}

class FavoriteBloc {
  FavoriteBloc(this._favorites, this._dateTimeFactory);

  final Favorites _favorites;
  final DateTimeFactory _dateTimeFactory;

  Future<void> add(MovieID id) async {
    final now = _dateTimeFactory.createNow();
    await _favorites.store(Favorite(id, now));
  }

  Future<void> remove(Favorite f) async {
    await _favorites.remove(f);
  }
}
