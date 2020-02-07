import 'package:flutter/material.dart';

enum AppTab { movies, myReview, screens, news, user }

extension AppTabHelper on AppTab {
  String screenHeaderText() => _tabWidgetText();
}

extension AppTabWidget on AppTab {
  static final List<Tab> all = AppTab.values.map((t) => t.widget()).toList();

  String _tabWidgetText() {
    switch (this) {
      case AppTab.movies:
        return 'movies';
      case AppTab.user:
        return 'user';
      case AppTab.myReview:
        return 'review';
      case AppTab.screens:
        return 'screens';
      case AppTab.news:
        return 'news';
    }
    throw StateError('$this .tabWidgetText() is unimplemented');
  }

  Tab widget() => Tab(text: _tabWidgetText());
}

class AppTabBar extends StatelessWidget {
  const AppTabBar({Key key, this.controller}) : super(key: key);

  final TabController controller;

  @override
  Widget build(BuildContext context) {
    return TabBar(
      labelColor: Colors.blue,
      // TODO(ryota0624): 装飾
      tabs: AppTabWidget.all,
      controller: controller,
    );
  }
}
