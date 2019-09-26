import 'package:flutter/material.dart';
import 'package:sembast/sembast.dart';
import 'package:wup/utils/constants/database.dart';
import 'package:wup/utils/database/models/flips.dart';
import 'package:wup/utils/database/database.dart';

class FlipsDao {
  static const String FLIPS_STORE_NAME = FLIPS_STORE;

  // A Store with int keys and Map<String, dynamic> values.
  // This Store acts like a persistent map, values of which are User objects converted to Map
  final _flipsStore = intMapStoreFactory.store(FLIPS_STORE_NAME);

  // Private getter to shorten the amount of code needed to get the
  // singleton instance of an opened database.
  Future<Database> get _db async => await AppDatabase.instance.database;

  Future insert(Flips flips) async {
    await _flipsStore.add(await _db, flips.toMap());
  }

  Future update(Flips flips) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = Finder(filter: Filter.byKey(flips.id));
    await _flipsStore.update(
      await _db,
      flips.toMap(),
      finder: finder,
    );
  }

  Future delete(Flips flips) async {
    if(flips == null) {
      await _flipsStore.delete(
        await _db,
      );
    }
    else {
      final finder = Finder(filter: Filter.byKey(flips.id));
      await _flipsStore.delete(
        await _db,
        finder: finder,
      );
    }
  }

  Future<Flips> getFlips() async {
    // Finder object can also sort data.
    final finder = Finder(sortOrders: [
      SortOrder('timestamp', false),
    ]);

    final recordSnapshot = await _flipsStore.findFirst(
      await _db,
      finder: finder,
    );

    // Making a List<User> out of List<RecordSnapshot>
    final flips = Flips.fromMap(recordSnapshot.value);
    // An ID is a key of a record from the database.
    flips.id = recordSnapshot.key;
    return flips;
  }
}