import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Configuration {
  const Configuration({
    @required this.tmdbAPIEndpoint,
    @required this.tmdbImageEndpoint,
    @required this.tmdbAPIKey,
  });

  final String tmdbAPIEndpoint;
  final String tmdbImageEndpoint;
  final String tmdbAPIKey;

  static Configuration of(BuildContext ctx) {
    final provider =
        ctx.dependOnInheritedWidgetOfExactType<ConfigurationProvider>();
    return provider.configuration;
  }
}

class ConfigurationProvider extends InheritedWidget {
  const ConfigurationProvider(this.configuration);

  final Configuration configuration;
  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;
}
