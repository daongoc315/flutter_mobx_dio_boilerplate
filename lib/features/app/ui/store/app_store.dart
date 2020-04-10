import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter_mobx_dio_boilerplate/common/exceptions/exceptions.dart';
import 'package:flutter_mobx_dio_boilerplate/common/l10n/l10n_helpers.dart';
import 'package:flutter_mobx_dio_boilerplate/common/models/language_model.dart';
import 'package:flutter_mobx_dio_boilerplate/common/models/theme_model.dart';
import 'package:flutter_mobx_dio_boilerplate/common/themes/theme_helper.dart';
import 'package:flutter_mobx_dio_boilerplate/features/app/data/controllers/app_controller.dart';
import 'package:flutter_mobx_dio_boilerplate/utils/alerts/alerts.dart';
import 'package:flutter_mobx_dio_boilerplate/utils/log/log.dart';

part 'app_store.g.dart';

enum AppSettingsTypeEnum {
  LANGUAGE,
  THEME,
}

@lazySingleton
class AppStore extends _AppStoreBase with _$AppStore {
  @override
  final AppController appController;

  @override
  final Alerts alerts;

  AppStore(
    this.appController,
    this.alerts,
  ) : super(appController, alerts);
}

abstract class _AppStoreBase with Store {
  final AppController appController;

  final Alerts alerts;

  _AppStoreBase(this.appController, this.alerts) {
    init();
  }

  @observable
  LanguageModel language = getDefaultAppLanguage();

  @observable
  ThemeModel theme = getDefaultAppTheme();

  @action
  Future<void> setAppLanguage(
    BuildContext context,
    LanguageModel languageData,
  ) async {
    final appData = await appController.setAppLanguageData(languageData);

    appData.pick(
      onError: (error) {
        if (error is CacheException) {
          alerts.setException(context, error);
        }

        language = getDefaultAppLanguage();

        return;
      },
      onData: (data) {
        language = data;
      },
      onNoData: () {
        language = getDefaultAppLanguage();
      },
    );
  }

  @action
  Future<void> getAppLanguage() async {
    final appData = await appController.getAppLanguageData();

    appData.pick(
      onError: (error) {
        if (error is CacheException) {
          log.error(error);
        }

        language = getDefaultAppLanguage();

        return;
      },
      onData: (data) {
        language = data;
      },
      onNoData: () {
        language = getDefaultAppLanguage();
      },
    );
  }

  @action
  Future<void> setAppTheme(
    BuildContext context,
    ThemeModel data,
  ) async {
    final appData = await appController.setAppThemeData(data);

    appData.pick(
      onError: (error) {
        if (error is CacheException) {
          alerts.setException(context, error);
        }

        theme = getDefaultAppTheme();

        return;
      },
      onData: (data) {
        theme = data;
      },
      onNoData: () {
        theme = getDefaultAppTheme();
      },
    );
  }

  @action
  Future<void> getAppTheme() async {
    final appData = await appController.getAppThemeData();

    appData.pick(
      onError: (error) {
        if (error is CacheException) {
          log.error(error);
        }

        theme = getDefaultAppTheme();

        return;
      },
      onData: (data) {
        theme = data;
      },
      onNoData: () {
        theme = getDefaultAppTheme();
      },
    );
  }

  Future<void> init() async {
    getAppLanguage();
    getAppTheme();
  }
}