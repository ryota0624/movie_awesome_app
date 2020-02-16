import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_awesome_app/model/paging_collection.dart';
import 'package:movie_awesome_app/posters_page.dart';
import 'package:provide/provide.dart';

import 'bloc/favorite.dart';
import 'bloc/favorite_list.dart';
import 'bloc/movie_list.dart';
import 'model/favorite.dart';
import 'model/movie.dart';

class MovieDetail extends StatefulWidget {
  const MovieDetail({
    Key key,
    this.id,
    this.preloadMovie,
  }) : super(key: key);

  final MovieID id;
  final Movie preloadMovie;

  @override
  _MovieDetailState createState() => _MovieDetailState();
}

class _MovieDetailState extends State<MovieDetail> {
  String get posterURL => widget.preloadMovie.posterURL;

  MovieListBloc movieListBloc() => Provide.value<MovieListBloc>(context);

  FavoriteBloc favoriteBloc() => Provide.value<FavoriteBloc>(context);

  FavoriteListBloc favoriteListBloc() =>
      Provide.value<FavoriteListBloc>(context);

  @override
  void didChangeDependencies() {
    print("didChangeDependencies");
    super.didChangeDependencies();
    movieListBloc().fetchSimilarMovies(widget.preloadMovie.id);
    fetchFavoriteByMovie();
  }

  void fetchFavoriteByMovie() {
    favoriteListBloc().fetchFavoriteByMovie(widget.preloadMovie.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.preloadMovie.title),
      ),
      body: Hero(
        tag: widget.id.toString(),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Image.network(
                        'https://image.tmdb.org/t/p/w500_and_h282_face/' +
                            posterURL,
                        fit: BoxFit.fill,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: buildSimilarMovieStreamBuilder(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: StreamBuilder(
        stream: favoriteListBloc().favorite(widget.preloadMovie.id),
        builder: (BuildContext ctx, AsyncSnapshot<Favorite> asyncSnapshot) {
          if (asyncSnapshot.connectionState == ConnectionState.waiting) {
            return FloatingActionButton(onPressed: () => {});
          }

          Color iconColor = Colors.grey;
          if (asyncSnapshot.connectionState == ConnectionState.active &&
              asyncSnapshot.data != null) {
            iconColor = Colors.red;
          }

          return FloatingActionButton(
            onPressed: () {
              if (asyncSnapshot.data == null) {
                favoriteBloc().add(widget.preloadMovie.id);
                fetchFavoriteByMovie();
                return;
              }
              favoriteBloc().remove(asyncSnapshot.data);
              fetchFavoriteByMovie();
            },
            child: Icon(
              Icons.favorite,
              color: iconColor,
            ),
          );
        },
      ),
    );
  }

  StreamBuilder<PagingCollection<Movie>> buildSimilarMovieStreamBuilder() {
    return StreamBuilder(
      stream: movieListBloc().similarMovies(widget.preloadMovie.id),
      builder: (BuildContext ctx, AsyncSnapshot<PagingCollection<Movie>> s) {
        if (!s.hasData) {
          return Text('loading');
        }

        final movies = s.data.toList();
        return GridView.builder(
          itemCount: movies.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
          ),
          itemBuilder: (BuildContext ctx, int i) {
            final movie = movies[i];
            return PosterGridCard(
              movie: movie,
            );
          },
        );
      },
    );
  }

  void back(BuildContext context) {
    Navigator.of(context).pop();
  }
}
