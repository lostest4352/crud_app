import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:testapp1/isar_dbs/user_details_isar.dart';

class IsarService {
  late Future<Isar> isarDB;

  IsarService() {
    isarDB = openIsarDB();
  }

  Future<Isar> openIsarDB() async {
    final dir = await getApplicationDocumentsDirectory();
    if (Isar.instanceNames.isEmpty) {
      return await Isar.open(
        [UserDetailsSchema],
        directory: dir.path,
        inspector: true,
      );
    }
    return Future.value(Isar.getInstance());
  }

  Future<List<UserDetails>> getData() async {
    final isar = await isarDB;
    final getUserDetailsData = isar.userDetails.where().findAll();
    return getUserDetailsData;
  }

  Stream<List<UserDetails>> listenToData() async* {
    final isar = await isarDB;
    yield* isar.userDetails.where().watch(fireImmediately: true);
  }

  Future<void> saveData(UserDetails userDetails) async {
    final isar = await isarDB;
    isar.writeTxn(() async {
      isar.userDetails.put(userDetails);
    });
  }

  Future<void> editData(
      int selectedId, String name, int age, String description) async {
    final isar = await isarDB;
    final getUserDetails = await isar.userDetails.get(selectedId);
    getUserDetails?.name = name;
    getUserDetails?.age = age;
    getUserDetails?.description = description;
    isar.writeTxn(() async {
      if (getUserDetails != null) {
        isar.userDetails.put(getUserDetails);
      }
    });
  }

  Future<void> deleteData(UserDetails userDetails) async {
    final isar = await isarDB;
    isar.writeTxn(() async {
      isar.userDetails.delete(userDetails.id);
    });
  }

  Future<void> cleanDB() async {
    final isar = await isarDB;
    isar.writeTxn(() async {
      isar.clear();
    });
  }
}
