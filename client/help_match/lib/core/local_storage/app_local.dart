import 'package:help_match/core/box_types/box_types.dart';
import 'package:help_match/core/current_user/model/user_cache_model.dart';
import 'package:help_match/hive_registrar.g.dart';
import 'package:hive_ce/hive.dart';
import 'package:path_provider/path_provider.dart';

Future<void> initializeHive() async {
  final appDocumentDirectory = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);

  Hive.registerAdapters();
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(OrgInfoAdapter());
  Hive.registerAdapter(LocationAdapter());

  await Hive.openBox<User>(userBox);
}
