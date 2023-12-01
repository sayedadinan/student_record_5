import 'dart:io';
import 'package:flutter/material.dart';
import 'package:student_record_5/model/user.dart';
import 'package:student_record_5/servises/userservice.dart';
import 'edituser.dart';
import 'viewuser.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late List<dynamic> _userList = [];
  late List<dynamic> _filteredUserList = [];
  final _userService = Userservice();
  TextEditingController _searchController = TextEditingController();

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
      _filteredUserList = _userList;
    });
  }

  @override
  void initState() {
    super.initState();
    getAllUserDetails();
  }

  void _filterUserList(String enteredKeyword) {
    List<dynamic> filteredList = _userList.where((user) {
      return user.name!.toLowerCase().contains(enteredKeyword.toLowerCase());
    }).toList();

    setState(() {
      _filteredUserList = filteredList;
    });
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
        backgroundColor: Colors.lightGreen,
        title: const Text('SEARCH PAGE'),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                onChanged: _filterUserList,
                decoration: InputDecoration(
                  labelText: 'Search',
                  hintText: 'What are you looking for?',
                  prefixIcon: Icon(Icons.search),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.orange), // Border color when enabled
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.greenAccent), // Border color when focused
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(8),
                itemCount: _filteredUserList.length,
                itemBuilder: (context, index) => Card(
                  elevation: 0,
                  child: ListTile(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Viewuser(
                          user: _filteredUserList[index],
                        ),
                      ),
                    ),
                    leading: CircleAvatar(
                      backgroundImage: _filteredUserList[index].selectedImage !=
                                  null &&
                              File(_filteredUserList[index].selectedImage!)
                                  .existsSync()
                          ? FileImage(
                                  File(_filteredUserList[index].selectedImage!))
                              as ImageProvider<Object>?
                          : NetworkImage(
                                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQTU2fQ_VCPdrSaseCDEo_dTbhRo7_Kuoz5zQ&usqp=CAU')
                              as ImageProvider<Object>,
                    ),
                    title: Text(_filteredUserList[index].name ?? 'No Name'),
                    subtitle:
                        Text(_filteredUserList[index].study ?? 'No Study'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Edituser(
                                  user: _filteredUserList[index],
                                ),
                              ),
                            ).then(
                              (data) {
                                if (data != null) {
                                  getAllUserDetails();
                                  showSuccesSnackBar(
                                      'User updated successfully');
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
                            deleteFormDialog(
                                context, _filteredUserList[index].id);
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
            ),
          ],
        ),
      ),
    );
  }
}
