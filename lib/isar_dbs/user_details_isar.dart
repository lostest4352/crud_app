import 'package:isar/isar.dart';

part 'user_details_isar.g.dart';

@collection
class UserDetails {
  Id id = Isar.autoIncrement;
  late String name;
  late int age;
  late String description;
}
