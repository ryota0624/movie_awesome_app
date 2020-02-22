class MovieID {
  MovieID(this._value);

  final String _value;

  @override
  String toString() => _value;

  @override
  bool operator ==(dynamic other) {
    return hashCode == (other.hashCode);
  }

  @override
  int get hashCode => _value.hashCode;
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

final sampleMovies = List<Movie>.generate(
  100,
  (i) => Movie(
    MovieID(i.toString()),
    'https://placehold.jp/150x150.png',
    'title',
  ),
);
