import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'model/movie.dart';
import 'routes.dart' as routes;

class PosterGrid extends StatelessWidget {
  const PosterGrid({Key key, @required this.movies}) : super(key: key);
  final List<Movie> movies;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final imageWidth = size.width > 1000 ? 300 : 200;

    final crossAxisCount = size.width / imageWidth.toDouble();
    // TODO(ryota0624): loading more
    return GridView.builder(
      itemCount: movies.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount.toInt(),
      ),
      itemBuilder: (BuildContext ctx, int i) {
        final movie = movies[i];
        return Hero(
          tag: movie.id.toString(),
          child: PosterGridCard(
            movie: movie,
          ),
        );
      },
    );
  }
}

class PosterGridCard extends StatelessWidget {
  const PosterGridCard({
    Key key,
    @required this.movie,
  }) : super(key: key);

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => transitionToMovieDetail(context),
      child: Image.network(
        // posterのサイズをいい感じにする
        'https://image.tmdb.org/t/p/w250_and_h141_face/' +
            movie.posterURL,
        fit: BoxFit.fill,
      ),
    );
  }

  void transitionToMovieDetail(BuildContext context) {
    Navigator.of(context).pushNamed('',
        arguments: routes.MovieDetail(
          movie.id,
          movie,
        ));
  }
}
