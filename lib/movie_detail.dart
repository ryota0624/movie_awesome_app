import 'package:flutter/cupertino.dart';

import 'model/movie.dart';

class MovieDetail extends StatelessWidget {
  const MovieDetail({
    Key key,
    this.id,
    this.preloadMovie,
  }) : super(key: key);

  final MovieID id;
  final Movie preloadMovie;

  String get posterURL => preloadMovie.posterURL;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: id,
      child: GestureDetector(
          onTap: () => back(context),
          child: Image.network(
            'https://image.tmdb.org/t/p/w500_and_h282_face/' + posterURL,
            fit: BoxFit.fill,
          )),
    );
  }

  void back(BuildContext context) {
    Navigator.of(context).pop();
  }
}
