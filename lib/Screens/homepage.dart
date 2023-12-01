import 'dart:io';
import 'package:flutter/material.dart';
import 'package:student_record_5/Screens/details.dart';
import 'package:student_record_5/Screens/search.dart';
import 'package:student_record_5/model/user.dart';
import 'package:student_record_5/servises/userservice.dart';
import 'edituser.dart';
import 'gridview.dart';
import 'viewuser.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late List<dynamic> _userList = [];
  // List<dynamic> _founders = [];
  final _userService = Userservice();

  getAllUserDetails() async {
    var users = await _userService.readAllUsers();
    setState(() {
      _userList = users.map((user) {
        var userModel = User();
        userModel.id = user['id'];
        userModel.name = user['name'];
        userModel.study = user['study'];
        userModel.age = user['age'];
        userModel.blood = user['blood'];
        userModel.selectedImage = user['selectedImage'];
        return userModel;
      }).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    // _founders = _userList;
    getAllUserDetails();
  }

  showSuccesSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  deleteFormDialog(BuildContext context, userId) {
    return showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
              content: Text('Are you sure you want to delete this?'),
              actions: [
                TextButton(
                    style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.red),
                    onPressed: () async {
                      var result = await _userService.deleteUser(userId);
                      if (result != null) {
                        Navigator.pop(context);
                        getAllUserDetails();
                        showSuccesSnackBar('User Details Deleted succesfully');
                      }
                    },
                    child: const Text(
                      'delete',
                    )),
                TextButton(
                  style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.orange),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('cancel'),
                )
              ]);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 198, 196, 196),
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchScreen()),
              );
            },
            icon: Icon(Icons.search),
            padding: EdgeInsets.only(right: 30),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Gridview()),
              );
            },
            icon: Icon(Icons.grid_view),
            padding: EdgeInsets.only(right: 30),
          ),
        ],
        backgroundColor: Colors.lightGreen,
        title: const Text('HOME PAGE'),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(9),
        itemCount: _userList.length,
        itemBuilder: (context, index) => Card(
          elevation: 4,
          child: ListTile(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Viewuser(
                  user: _userList[index],
                ),
              ),
            ),
            leading: CircleAvatar(
              backgroundImage: _userList[index].selectedImage != null &&
                      File(_userList[index].selectedImage!).existsSync()
                  ? FileImage(File(_userList[index].selectedImage!))
                      as ImageProvider<Object>?
                  : NetworkImage(
                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQTU2fQ_VCPdrSaseCDEo_dTbhRo7_Kuoz5zQ&usqp=CAU')
                      as ImageProvider<Object>,
            ),
            title: Text(_userList[index].name ?? 'No Name'),
            subtitle: Text(_userList[index].study ?? 'No Study'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Edituser(
                          user: _userList[index],
                        ),
                      ),
                    ).then(
                      (data) {
                        if (data != null) {
                          getAllUserDetails();
                          showSuccesSnackBar('User updated successfully');
                        }
                      },
                    );
                  },
                  icon: Icon(
                    Icons.edit,
                    color: Color.fromARGB(255, 250, 151, 2),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    deleteFormDialog(context, _userList[index].id);
                  },
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Detailspage()),
          ).then((data) {
            if (data != null) {
              getAllUserDetails();
              showSuccesSnackBar('User added successfully');
            }
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
