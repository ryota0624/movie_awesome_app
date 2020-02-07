import 'package:movie_awesome_app/tab_bar.dart';

import 'movies_page.dart';

abstract class Route {}

class MovieDetail extends Route {
  MovieDetail(this.id, [this.preloadMovie]);

  final String id;
  final Movie preloadMovie;
}

class Home extends Route {
  Home({
    this.initialAppTab = AppTab.movies,
  });

  final AppTab initialAppTab;
}
