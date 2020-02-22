import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:movie_awesome_app/bloc/movie_list.dart';
import 'package:movie_awesome_app/model/paging_collection.dart';
import 'package:provide/provide.dart';

import 'bloc/favorite_list.dart';
import 'model/favorite.dart';
import 'model/movie.dart';
import 'movies_page.dart';

class FavoritePage extends StatefulWidget {
  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  FavoriteListBloc favoriteListBloc() =>
      Provide.value<FavoriteListBloc>(context);

  MovieListBloc movieListBloc() {
    return Provide.value<MovieListBloc>(context);
  }

  Stream<PagingCollection<Movie>> _movie$;

  StreamTransformer<PagingCollection<Favorite>, PagingCollection<Movie>>
      _favoritesToMovies() {
    return StreamTransformer<PagingCollection<Favorite>,
        PagingCollection<Movie>>.fromHandlers(handleData: (favorite, sink) {
      final movieIDs = favorite.toList().map((f) => f.movieID).toList();
      print('_favoritesToMovies movieIDs $movieIDs');
      movieListBloc().moviesByIDs$(movieIDs).listen((movies) {
        final moviesCollection = PagingCollection(favorite.page, movies);
        print('_favoritesToMovies movies $movies');
        sink.add(moviesCollection);
      });
      movieListBloc().fetchMoviesByIDs(movieIDs);
    }, handleDone: (_) {
      print("_favoritesToMovies done");
    }, handleError: (err, st, _) {
      print(st);
      throw err;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_movie$ == null) {
      _movie$ = favoriteListBloc().allFavorites.transform(_favoritesToMovies());
      favoriteListBloc().fetchAllFavorites();
    }
  }

  @override
  Widget build(BuildContext context) {
    print("Favorite.build");

    return StreamBuilder(
        key: Key("_FavoritePageState"),
        stream: _movie$,
        builder: (BuildContext c, AsyncSnapshot<PagingCollection<Movie>> s) {

          if (s.hasData) {
            print("Favorite.StreamBuilder.build ${s.data.toList().length}");

            return ListView.builder(
                itemCount: s.data.toList().length,
                itemBuilder: (BuildContext ctx, int index) {
//                  if (isMoreLoadingTileIndex(index)) {
//                    return MaterialButton(
//                      onPressed: onTapLoadMore,
//                      child: Icon(Icons.autorenew),
//                    );
//                  }

                  return MovieListTile(movie: s.data.toList()[index]);
                });
          }

          return const Text('Loading');
        });
  }
}
