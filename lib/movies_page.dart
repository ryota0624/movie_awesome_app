import 'dart:async';

import 'package:flutter/material.dart';
import 'package:movie_awesome_app/bloc/movie_list.dart';
import 'package:movie_awesome_app/model/paging_collection.dart';
import 'package:provide/provide.dart';
import 'model/movie.dart';
import 'posters_page.dart' as poster_page;
import 'routes.dart' as routes;

enum MoviesPageTab { list, posters }

extension MoviesPageTabWidget on MoviesPageTab {
  Tab widget() {
    switch (this) {
      case MoviesPageTab.list:
        return const Tab(text: 'list');
      case MoviesPageTab.posters:
        return const Tab(text: 'poster');
    }

    throw UnimplementedError('for $this');
  }

  Widget screen(List<Movie> movies, _MoviesState state) {
    switch (this) {
      case MoviesPageTab.list:
        return MovieList(
          movies: movies,
          onTapLoadMore: state.loadMoreMovies,
        );
      case MoviesPageTab.posters:
        return poster_page.PosterGrid(movies: movies);
    }

    throw UnimplementedError('for $this');
  }

  static final List<Tab> all =
      MoviesPageTab.values.map((t) => t.widget()).toList();
}

class Movies extends StatefulWidget {
  @override
  _MoviesState createState() => _MoviesState();
}

class _MoviesState extends State<Movies> with SingleTickerProviderStateMixin {
  TabController _tabController;
  TextEditingController _searchEditingController;
  StreamController<List<Movie>> _recentMovies$;
  Page _currentPage;

  StreamSubscription _recentMoviesSubscription;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    movieListBloc(context).fetchRecentMovies();
    _recentMoviesSubscription = startSubscribeRecentMovies();
  }

  StreamSubscription startSubscribeRecentMovies() {
    if (_recentMovies$.isClosed) {
      _recentMovies$ = StreamController();
    }
    var sumCollection = List<Movie>();
    return movieListBloc(context).recentMovies().listen((movieCollection) {
      // TODO(ryota0624): resolve Unhandled Exception: Bad state: Cannot add event after closing
      _currentPage = movieCollection.page;
      sumCollection.addAll(movieCollection.toList());
      if (!_recentMovies$.isClosed) {
        _recentMovies$.add(sumCollection);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _recentMovies$ = StreamController();
    _tabController = TabController(
      length: MoviesPageTab.values.length,
      vsync: this,
    );

    _searchEditingController = TextEditingController()
      ..addListener(() {
        // TODO(ryota0624): search Movie
//        _searchEditingController.text
      });
  }

  @override
  void dispose() {
    super.dispose();
    _recentMovies$.close();
    _recentMoviesSubscription.cancel();
  }

  void loadMoreMovies() {
    movieListBloc(context).fetchRecentMovies(page: _currentPage.next());
  }

  TabBar get tabBar => TabBar(
        labelColor: Colors.blue,
        unselectedLabelColor: Colors.grey,
        // TODO(ryota0624): 装飾
        tabs: MoviesPageTabWidget.all,
        controller: _tabController,
      );

  MovieListBloc movieListBloc(BuildContext ctx) =>
      Provide.value<MovieListBloc>(ctx);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SearchBar(
          editingController: _searchEditingController,
        ),
        tabBar,
        Flexible(
          child: StreamBuilder(
              stream: _recentMovies$.stream,
              builder: (BuildContext c, AsyncSnapshot<List<Movie>> s) {
                if (s.hasData) {
                  return TabBarView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: _tabController,
                    children: MoviesPageTab.values
                        .map((tab) => tab.screen(s.data, this))
                        .toList(),
                  );
                }

                return const Text('Loading');
              }),
        ),
      ],
    );
  }
}

class MovieList extends StatelessWidget {
  const MovieList({
    Key key,
    @required this.movies,
    this.onTapLoadMore,
  }) : super(key: key);

  final List<Movie> movies;
  final void Function() onTapLoadMore;

  bool get onTapLoadMoreProvided => onTapLoadMore != null;

  int get listViewTileCount =>
      onTapLoadMoreProvided ? movies.length + 1 : movies.length;

  bool isMoreLoadingTileIndex(int index) =>
      onTapLoadMoreProvided && index == (listViewTileCount - 1);

  @override
  Widget build(BuildContext context) {
    // TODO(ryota0624): loading more
    return ListView.builder(
        itemCount: listViewTileCount,
        itemBuilder: (BuildContext ctx, int index) {
          if (isMoreLoadingTileIndex(index)) {
            return MaterialButton(
              onPressed: onTapLoadMore,
              child: Icon(Icons.autorenew),
            );
          }

          return MovieListTile(movie: movies[index]);
        });
  }
}

class MovieListTile extends StatelessWidget {
  const MovieListTile({Key key, @required this.movie}) : super(key: key);

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => transitionToMovieDetail(context),
      child: Hero(
        tag: movie.id.toString(),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: ListTile(
              leading: posterIcon,
              title: Text(movie.title),
            ),
          ),
        ),
      ),
    );
  }

  Widget get posterIcon => Image.network(
      'https://image.tmdb.org/t/p/w500_and_h282_face/' + movie.posterURL);

  void transitionToMovieDetail(BuildContext context) {
    Navigator.of(context).pushNamed('',
        arguments: routes.MovieDetail(
          movie.id,
          movie,
        ));
  }
}

class SearchBar extends StatelessWidget {
  const SearchBar({Key key, this.editingController}) : super(key: key);
  final TextEditingController editingController;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: editingController,
      decoration: InputDecoration(
        labelText: 'Search',
        hintText: 'Search',
        prefixIcon: Icon(Icons.search),
      ),
    );
  }
}
