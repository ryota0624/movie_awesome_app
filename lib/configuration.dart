import 'package:flutter/cupertino.dart';

class Configuration {
  const Configuration({
    @required this.tmdbAPIEndpoint,
    @required this.tmdbImageEndpoint,
    @required this.tmdbAPIKey,
  });

  final String tmdbAPIEndpoint;
  final String tmdbImageEndpoint;
  final String tmdbAPIKey;
}
