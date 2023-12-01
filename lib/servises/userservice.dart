import 'package:student_record_5/model/user.dart';
import 'package:student_record_5/db_helper/repositery.dart';

class Userservice {
  late Repository repository;
  Userservice() {
    repository = Repository();
  }
//save user
  SaveUser(User user) async {
    return await repository.insertData("user", user.userMap());
  }

  //readallusers
  readAllUsers() async {
    return await repository.readData('user');
  }

  //editallusers
  UpdateUser(User user) async {
    return await repository.updateData('user', user.userMap());
  }

  deleteUser(userId) async {
    return await repository.deleteDataById('user', userId);
  }
}
