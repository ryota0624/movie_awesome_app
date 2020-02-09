class MovieID {
  MovieID(this._value);

  final String  _value;

  @override
  String toString() => _value;
}

class Movie {
  Movie(
    this.id,
    this.posterURL,
    this.title,
  );

  final MovieID id;
  final String posterURL;
  final String title;
}
