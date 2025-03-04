import 'package:sembast/sembast.dart';
import 'package:wup/utils/constants/database.dart';
import 'package:wup/utils/database/models/user.dart';
import 'package:wup/utils/database/database.dart';

class UserDao {
  static const String USER_STORE_NAME = USER_STORE;

  // A Store with int keys and Map<String, dynamic> values.
  // This Store acts like a persistent map, values of which are User objects converted to Map
  final _userStore = intMapStoreFactory.store(USER_STORE_NAME);

  // Private getter to shorten the amount of code needed to get the
  // singleton instance of an opened database.
  Future<Database> get _db async => await AppDatabase.instance.database;

  Future insert(User user) async {
    await _userStore.add(await _db, user.toMap());
  }

  Future update(User user) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = Finder(filter: Filter.byKey(user.id));
    await _userStore.update(
      await _db,
      user.toMap(),
      finder: finder,
    );
  }

  Future delete(User user) async {
    if(user == null) {
      await _userStore.delete(
        await _db,
      );
    }
    else {
      final finder = Finder(filter: Filter.byKey(user.id));
      await _userStore.delete(
        await _db,
        finder: finder,
      );
    }
  }

  Future<User> getUser() async {
    // Finder object can also sort data.
    final finder = Finder(sortOrders: [
      SortOrder('name'),
    ]);

    final recordSnapshot = await _userStore.findFirst(
      await _db,
      finder: finder,
    );

    // Making a List<User> out of List<RecordSnapshot>
      final user = User.fromMap(recordSnapshot.value);
      // An ID is a key of a record from the database.
      user.id = recordSnapshot.key;
      return user;
  }
}