import 'dart:io';
import 'package:flutter/material.dart';
// import 'package:student_record_5/Screens/search.dart';
import 'package:student_record_5/model/user.dart';
import 'package:student_record_5/servises/userservice.dart';

import 'viewuser.dart';

class Gridview extends StatefulWidget {
  const Gridview({Key? key});
  @override
  State<Gridview> createState() => _Gridview();
}

class _Gridview extends State<Gridview> {
  late List<dynamic> _userList = [];
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
    getAllUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 198, 196, 196),
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.list),
            padding: EdgeInsets.only(right: 30),
          )
        ],
        backgroundColor: Colors.lightGreen,
        title: const Text('GRID VIEW'),
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 18,
        ),
        itemCount: _userList.length,
        itemBuilder: (context, index) => Card(
          elevation: 9,
          child: InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Viewuser(
                  user: _userList[index],
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(13.0),
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundImage: _userList[index].selectedImage != null &&
                            File(_userList[index].selectedImage!).existsSync()
                        ? FileImage(File(_userList[index].selectedImage!))
                            as ImageProvider<Object>?
                        : NetworkImage(
                                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQTU2fQ_VCPdrSaseCDEo_dTbhRo7_Kuoz5zQ&usqp=CAU')
                            as ImageProvider<Object>,
                  ),
                  SizedBox(height: 8),
                  Text(_userList[index].name ?? 'No Name'),
                  Text(_userList[index].study ?? 'No Study'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
