import 'package:blank_project/constants/api_url.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';

// ignore: avoid_classes_with_only_static_members
class Config {
  static void configureDevelop() {
    FlavorConfig(
      name: 'dev',
      variables: {
        'banner_name': 'dev',
        'environment': 'development',
        'base_url': devBaseUrl,
        'sentry_dsn': sentryDsn,
        'socket_url': devSocketUrl,
      },
    );
  }

  static void configureStaging() {
    FlavorConfig(
      name: 'stg',
      color: Colors.green,
      variables: {
        'banner_name': 'stg',
        'environment': 'staging',
        'base_url': stagingBaseUrl,
        'sentry_dsn': sentryDsn,
        'socket_url': stgSocketUrl,
      },
    );
  }

  static void configureProduction() {
    FlavorConfig(
      name: 'prod',
      variables: {
        'banner_name': 'prod',
        'environment': 'production',
        'base_url': prodBaseUrl,
        'sentry_dsn': sentryDsn,
        'socket_url': prodSocketUrl,
      },
    );
  }

  static void setEnvironment(String? env) {
    if (env == null || env.isEmpty) {
      configureProduction();
      return;
    }

    switch (env) {
      case 'develop':
        configureDevelop();
        return;
      case 'staging':
        configureStaging();
        return;
      case 'production':
        configureProduction();
        return;
      default:
        configureProduction();
        return;
    }
  }
}
