import 'package:flutter/material.dart';
import 'package:movie_awesome_app/adapter/favorites.dart';
import 'package:movie_awesome_app/bloc/favorite.dart';
import 'package:movie_awesome_app/bloc/favorite_list.dart';
import 'package:movie_awesome_app/bloc/movie_list.dart';
import 'package:movie_awesome_app/model/favorite.dart';
import 'package:movie_awesome_app/model/movies.dart';
import 'package:movie_awesome_app/movies_page.dart' as list_page;
import 'package:movie_awesome_app/routes.dart' as routes;
import 'package:movie_awesome_app/tab_bar.dart';
import 'package:movie_awesome_app/user_page.dart';
import 'package:provide/provide.dart';
import 'package:tmdb_client/tmdb_client.dart' as tmdb;

import 'adapter/tmdb_api.dart';
import 'configuration.dart';
import 'configuration_prd.dart';
import 'movie_detail.dart';

void main() {
  final providers = Providers()
    ..provide(Provider.value(prdConfiguration))
    ..provide(Provider<DateTimeFactory>.value(DateTimeFactoryOnCore()))
    ..provide(Provider<Favorites>.value(FavoritesOnMemory()))
    ..provide(Provider.function((BuildContext ctx) {
      final conf = Provide.value<Configuration>(ctx);
      return tmdb.TmdbResolver(
        endPoint: conf.tmdbAPIEndpoint,
        apiKey: conf.tmdbAPIKey,
      );
    }))
    ..provide(Provider<Movies>.function((BuildContext ctx) {
      final tmdbResolver = Provide.value<tmdb.TmdbResolver>(ctx);
      return MoviesOnTmdbApi(tmdbResolver);
    }))
    ..provide(Provider<MovieListBloc>.function((BuildContext ctx) {
      final movies = Provide.value<Movies>(ctx);
      return MovieListBloc(movies);
    }))
    ..provide(Provider<FavoriteListBloc>.function((BuildContext ctx) {
      final fvs = Provide.value<Favorites>(ctx);
      return FavoriteListBloc(fvs);
    }))
    ..provide(Provider<FavoriteBloc>.function((BuildContext ctx) {
      final fvs = Provide.value<Favorites>(ctx);
      final timeFactory = Provide.value<DateTimeFactory>(ctx);
      return FavoriteBloc(fvs, timeFactory);
    }));

  runApp(ProviderNode(
    providers: providers,
    child: MovieApp(),
  ));
}

class MovieApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: (RouteSettings routeSettings) {
//        if (!(routeSettings is routes.Route)) {
//          throw StateError('invalid routeSetting $routeSettings');
//        }
        final route = routeSettings.arguments;
        if (route is routes.Home) {
          return MaterialPageRoute(
            builder: (_) => MyHomePage(
              initialSelectedTab: route.initialAppTab,
            ),
          );
        }

        if (route is routes.MovieDetail) {
          return MaterialPageRoute(
            builder: (_) => MovieDetail(
              id: route.id,
              preloadMovie: route.preloadMovie,
            ),
          );
        }

        throw UnimplementedError('route for ${routeSettings.arguments}');
      },
      title: 'Movie App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key, this.initialSelectedTab}) : super(key: key);
  final AppTab initialSelectedTab;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  String title;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: AppTab.values.length, vsync: this)
      ..addListener(_changeTitle);

    if (widget.initialSelectedTab != null) {
      _tabController
          .animateTo(AppTab.values.indexOf(widget.initialSelectedTab));
    }
    title = currentTab.screenHeaderText();
  }

  @override
  void dispose() {
    _tabController.removeListener(_changeTitle);
    super.dispose();
  }

  AppTab get currentTab => AppTab.values[_tabController.index];

  void _changeTitle() {
    setState(() {
      title = currentTab.screenHeaderText();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      bottomNavigationBar: AppTabBar(
        controller: _tabController,
      ),
      body: Center(
        child: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _tabController,
          children: AppTab.values.map((appBar) => appBar.screen()).toList(),
        ),
      ),
    );
  }
}

extension on AppTab {
  Widget screen() {
    switch (this) {
      case AppTab.movies:
        return list_page.Movies();
      case AppTab.user:
        return UserPage();

//      case AppTab.myReview:
//        // TODO: Handle this case.
//        break;
//      case AppTab.screenSchedule:
//        // TODO: Handle this case.
//        break;
      default:
        return const Text('no implemented screen');
    }
  }
}
