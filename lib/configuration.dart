import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provide/provide.dart';

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
    return Provide.value<Configuration>(ctx);
  }
}

