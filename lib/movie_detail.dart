import 'dart:async';

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

  Stream<PagingCollection<Movie>> similarMovies$;
  Stream<Favorite> favorite$;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (similarMovies$ == null) {
      similarMovies$ = movieListBloc().similarMovies$(widget.id);
      fetchSimilarMovies();
    }

    if (favorite$ == null) {
      favorite$ = favoriteListBloc().favorite(widget.preloadMovie.id);
      fetchFavoriteByMovie();
    }
  }

  @override
  void didUpdateWidget(MovieDetail oldWidget) {
    super.didUpdateWidget(oldWidget);
    print("didUpdateWidget");
    fetchSimilarMovies();
    fetchFavoriteByMovie();
  }

  void fetchSimilarMovies() {
    movieListBloc().fetchSimilarMovies(widget.preloadMovie.id);
  }

  void fetchFavoriteByMovie() {
    favoriteListBloc().fetchFavoriteByMovie(widget.preloadMovie.id);
  }

  @override
  Widget build(BuildContext context) {
    print("_MovieDetailState.build");
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.preloadMovie.title),
      ),
      body: MovieDetailBody(
//        key: Key("MovieDetailBody-${similarMovies$.hashCode}"),
        id: widget.id,
        preloadMovie: widget.preloadMovie,
        similarMovies$: similarMovies$,
      ),
      floatingActionButton: FavoriteButton(
//        key: Key("FavoriteButton-${favorite$.hashCode}"),
        favorite$: favorite$,
        tapToFavorite: () => favoriteBloc().add(widget.preloadMovie.id),
        tapToRemoveFavorite: (f) => favoriteBloc().remove(f),
      ),
    );
  }

  void back(BuildContext context) {
    Navigator.of(context).pop();
  }
}

class MovieDetailBody extends StatefulWidget {
  const MovieDetailBody({
    Key key,
    this.id,
    this.preloadMovie,
    this.similarMovies$,
  }) : super(key: key);

  final MovieID id;
  final Movie preloadMovie;
  final Stream<PagingCollection<Movie>> similarMovies$;

  @override
  _MovieDetailBodyState createState() => _MovieDetailBodyState();
}

class _MovieDetailBodyState extends State<MovieDetailBody> {
  @override
  Widget build(BuildContext context) {
    print("_MovieDetailBodyState.build");

    return Column(
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
                        widget.preloadMovie.posterURL,
                    fit: BoxFit.fill,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: SimilarMovies(
//                    key: Key(
//                        'movie_detail_similars_${widget.similarMovies$.hashCode.toString()}'),
                    similarMovies$: widget.similarMovies$,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class SimilarMovies extends StatelessWidget {
  const SimilarMovies({
    Key key,
    this.similarMovies$,
  }) : super(key: key);
  final Stream<PagingCollection<Movie>> similarMovies$;

  @override
  Widget build(BuildContext context) {
    print("SimilarMovies build ${similarMovies$.hashCode.toString()}");

    return StreamBuilder(
//      key: Key(similarMovies$.hashCode.toString()),
      stream: similarMovies$,
      builder: (BuildContext ctx, AsyncSnapshot<PagingCollection<Movie>> s) {
//        print("SimilarMovies.StreamBuilder.build ${similarMovies$.hashCode.toString()} ${s}");
        if (!s.hasData) {
          return Icon(Icons.autorenew);
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
}

class FavoriteButton extends StatelessWidget {
  const FavoriteButton({
    Key key,
    this.favorite$,
    this.tapToFavorite,
    this.tapToRemoveFavorite,
  }) : super(key: key);
  final Stream<Favorite> favorite$;
  final Function() tapToFavorite;
  final Function(Favorite) tapToRemoveFavorite;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: favorite$,
      builder: (BuildContext ctx, AsyncSnapshot<Favorite> asyncSnapshot) {
        if (asyncSnapshot.connectionState == ConnectionState.waiting) {
          return Container();
        }
        Color iconColor = Colors.grey;
        if (asyncSnapshot.connectionState == ConnectionState.active &&
            asyncSnapshot.data != null) {
          iconColor = Colors.red;
        }

        return FloatingActionButton(
          onPressed: () {
            if (asyncSnapshot.data == null) {
              tapToFavorite();
              return;
            }
            tapToRemoveFavorite(asyncSnapshot.data);
          },
          child: Icon(
            Icons.favorite,
            color: iconColor,
          ),
        );
      },
    );
  }
}
