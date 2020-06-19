import 'dart:io' show Platform;

class ThemeConfig {

	ThemeColor color;
	ThemePlatform platform;

  ThemeConfig(this.color, this.platform);

  static ThemeConfig currentConfig = defaultConfig;

  static final ThemeConfig defaultConfig = ThemeConfig(
		  ThemeColor.BLUE,
		  Platform.isAndroid ? ThemePlatform.ANDROID : ThemePlatform.IOS
  );
}

enum ThemeColor {
	BLUE,
	PINK,
	GREEN
}

enum ThemePlatform {
	ANDROID,
	IOS
}