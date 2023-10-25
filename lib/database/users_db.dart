import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'users_db.g.dart';

class UserItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get age => integer()();
  TextColumn get description => text().nullable()();
}

@DriftDatabase(tables: [UserItems])
class UserDatabase extends _$UserDatabase {
  UserDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<List<UserItem>> getData() async {
    List<UserItem> allUserItems = await select(userItems).get();
    return allUserItems;
  }

  Stream<List<UserItem>> listenToData() async* {
    final allUserItems = select(userItems).watch();
    yield* allUserItems;
  }

  Future<int> addData(String name, int age, String? description) async {
    return await into(userItems).insert(
      UserItemsCompanion.insert(
        name: name,
        age: age,
        description: Value(description),
      ),
    );
  }

  Future<bool> updateData(UserItemsCompanion userItemsCompanion) async {
    return await update(userItems).replace(userItemsCompanion);
  }

  Future<int> deleteData(int userItemId) async {
    return await (delete(userItems)
          ..where((tbl) {
            return tbl.id.equals(userItemId);
          }))
        .go();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
