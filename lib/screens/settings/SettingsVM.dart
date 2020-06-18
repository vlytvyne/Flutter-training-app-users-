import 'package:architecture/data/configs/ThemeConfig.dart';
import 'package:architecture/data/repositories/OnlineRepository.dart';
import 'package:rxdart/rxdart.dart';

class SettingsVM {

	get currentUsersSeed => OnlineRepository().usersSeed;

	final _themeColorEmitter = BehaviorSubject<ThemeColor>.seeded(ThemeConfig.currentConfig.color);
	Stream<ThemeColor> get themeColorStream => _themeColorEmitter.stream;

	final _themePlatformEmitter = BehaviorSubject<ThemePlatform>.seeded(ThemeConfig.currentConfig.platform);
	Stream<ThemePlatform> get themePlatformStream => _themePlatformEmitter.stream;

	final _themeConfigEmitter = BehaviorSubject<ThemeConfig>();
	Stream<ThemeConfig> get themeConfigStream => _themeConfigEmitter.stream;

	setUserSeed(String newSeed) {
		OnlineRepository().usersSeed = newSeed;
	}

	setThemeColor(ThemeColor color) {
		ThemeConfig.currentConfig.color = color;
		_themeColorEmitter.add(color);
		_themeConfigEmitter.add(ThemeConfig.currentConfig);
	}

	setThemePlatform(ThemePlatform platform) {
		ThemeConfig.currentConfig.platform = platform;
		_themePlatformEmitter.add(platform);
		_themeConfigEmitter.add(ThemeConfig.currentConfig);
	}

	dispose() {
		_themeColorEmitter.close();
		_themePlatformEmitter.close();
		_themeConfigEmitter.close();
	}
}