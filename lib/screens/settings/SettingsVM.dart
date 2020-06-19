import 'package:architecture/data/configs/ThemeConfig.dart';
import 'package:architecture/data/repositories/OfflineRepository.dart';
import 'package:architecture/data/repositories/OnlineRepository.dart';
import 'package:rxdart/rxdart.dart';

class SettingsVM {

	get currentUsersSeed => OnlineRepository().usersSeed;

	final _themeColorEmitter = BehaviorSubject<ThemeColor>.seeded(ThemeConfig.currentConfig.color);
	Stream<ThemeColor> get themeColorStream => _themeColorEmitter.stream;

	final _themePlatformEmitter = BehaviorSubject<ThemePlatform>.seeded(ThemeConfig.currentConfig.platform);
	Stream<ThemePlatform> get themePlatformStream => _themePlatformEmitter.stream;

	final _themeConfigEmitter = BehaviorSubject<ThemeConfig>.seeded(ThemeConfig.currentConfig);
	Stream<ThemeConfig> get themeConfigStream => _themeConfigEmitter.stream;

	setUserSeed(String newSeed) {
		OnlineRepository().usersSeed = newSeed;
		OfflineRepository().saveUsersSeed(newSeed);
	}

	setThemeColor(ThemeColor color) {
		_themeColorEmitter.add(color);
		_distributeConfig(ThemeConfig(color, ThemeConfig.currentConfig.platform));
	}

	setThemePlatform(ThemePlatform platform) {
		_themePlatformEmitter.add(platform);
		_distributeConfig(ThemeConfig(ThemeConfig.currentConfig.color, platform));
	}

	_distributeConfig(ThemeConfig config) {
		ThemeConfig.currentConfig = config;
		_themeConfigEmitter.add(config);
		OfflineRepository().saveThemeConfig(config);
	}

	dispose() {
		_themeColorEmitter.close();
		_themePlatformEmitter.close();
		_themeConfigEmitter.close();
	}
}