import 'package:flutter/material.dart';
import 'package:tmdb_client/tmdb_client.dart';
import 'posters_page.dart' as poster_page;

final sampleMovies = List<Movie>.generate(100,
    (i) => Movie(i.toString(), 'https://placehold.jp/150x150.png', 'title'));

// TODO(ryota0624): modelに切り出し
class Movie {
  Movie(this.id, this.posterURL, this.title);

  final String id;
  final String posterURL;
  final String title;
}

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

  Widget screen(List<Movie> movies) {
    switch (this) {
      case MoviesPageTab.list:
        return MovieList(movies: movies);
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

  List<Movie> movies = [];

  // TODO(ryota0624): tokenを`.env`からよむ。
  // TODO(ryota0624): Contextから取れるようにする
  // TODO(ryota0624): Bloc
  final _resolver = TmdbResolver(
    endPoint: '',
    apiKey: '',
  );

  @override
  void initState() {
    _resolver.discoverMovie().then((res) {
      if (mounted) {
        setState(() {
          final movies = res.results
              .map((movie) => Movie(
                    movie.id.toString(),
                    movie.posterPath,
                    movie.title,
                  ))
              .toList();
          this.movies = movies;
        });
      }
    });

    super.initState();
    _tabController = TabController(
      length: MoviesPageTab.values.length,
      vsync: this,
    );

    _searchEditingController = TextEditingController()
      ..addListener(() {
        // TODO search Movie
//        _searchEditingController.text
      });
  }

  TabBar get tabBar => TabBar(
        labelColor: Colors.blue,
        indicatorColor: Colors.white,
        unselectedLabelColor: Colors.grey,
        // TODO(ryota0624): 装飾
        tabs: MoviesPageTabWidget.all,
        controller: _tabController,
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SearchBar(
          editingController: _searchEditingController,
        ),
        tabBar,
        Flexible(
          child: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            controller: _tabController,
            children:
                MoviesPageTab.values.map((tab) => tab.screen(movies)).toList(),
          ),
        ),
      ],
    );
  }
}

class MovieList extends StatelessWidget {
  const MovieList({Key key, @required this.movies}) : super(key: key);

  final List<Movie> movies;

  @override
  Widget build(BuildContext context) {
    // TODO(ryota0624): loading more
    return ListView.builder(
        itemCount: movies.length,
        itemBuilder: (BuildContext ctx, int index) {
          return MovieListTile(movie: movies[index]);
        });
  }
}

class MovieListTile extends StatelessWidget {
  const MovieListTile({Key key, @required this.movie}) : super(key: key);

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: ListTile(
          leading: posterIcon,
          title: Text(movie.title),
        ),
      ),
    );
  }

  Widget get posterIcon => Image.network(
      'https://image.tmdb.org/t/p/w500_and_h282_face/' + movie.posterURL);

  void transitionToMovieDetail() {}
}

class SearchBar extends StatelessWidget {
  const SearchBar({Key key, this.editingController}) : super(key: key);
  final TextEditingController editingController;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: editingController,
      decoration: InputDecoration(
        labelText: "Search",
        hintText: "Search",
        prefixIcon: Icon(Icons.search),
      ),
    );
  }
}
