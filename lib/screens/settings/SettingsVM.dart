import 'package:architecture/data/repositories/OnlineRepository.dart';

class SettingsVM {

	get currentUsersSeed => OnlineRepository().usersSeed;

	setUserSeed(String newSeed) {
		OnlineRepository().usersSeed = newSeed;
	}
}