class ThemeConfig {

	ThemeColor color;
	ThemePlatform platform;

  ThemeConfig(this.color, this.platform);

  static final ThemeConfig currentConfig = ThemeConfig(ThemeColor.BLUE, ThemePlatform.ANDROID);
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