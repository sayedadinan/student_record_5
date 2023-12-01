import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../model/user.dart';
import '../servises/userservice.dart';

class Edituser extends StatefulWidget {
  final User user;
  const Edituser({Key? key, required this.user}) : super(key: key);

  @override
  State<Edituser> createState() => _EdituserState();
}

class _EdituserState extends State<Edituser> {
  final userNameController = TextEditingController();
  final studyController = TextEditingController();
  final ageController = TextEditingController();
  final bloodController = TextEditingController();
  bool validateuser = false;
  bool validatestudy = false;
  bool validateage = false;
  bool validateblood = false;
  var userService = Userservice();
  File? imagepath;
  String? selectedImage;
  @override
  void initState() {
    setState(() {
      userNameController.text = widget.user.name ?? '';
      studyController.text = widget.user.study ?? '';
      ageController.text = widget.user.age ?? '';
      bloodController.text = widget.user.blood ?? '';
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        title: const Text('Details page'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Edit user',
              style: TextStyle(
                  fontSize: 25,
                  color: Colors.green,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: userNameController,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 250, 151, 2))),
                labelText: 'username',
                hintText: 'Enter your full name',
                errorText: validateuser ? 'value cant be Empty' : null,
                prefixIcon: Icon(
                  Icons.person,
                  // color: Colors.purple,
                ),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: studyController,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 250, 151, 2))),
                labelText: 'Class',
                hintText: 'Enter your class',
                errorText: validatestudy ? 'value cant be Empty' : null,
                prefixIcon: Icon(
                  Icons.class_,
                  // color: Colors.purple,
                ),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              keyboardType: TextInputType.phone,
              controller: ageController,
              // maxLength: 2,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 250, 151, 2))),
                labelText: 'Age',
                hintText: 'Enter your Age',
                errorText: validateage ? 'value cant be Empty' : null,
                prefixIcon: Icon(
                  Icons.calendar_month,
                  // color: Colors.purple,
                ),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: bloodController,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 250, 151, 2))),
                labelText: 'Blood Group',
                hintText: 'Enter your blood group',
                errorText: validateblood ? 'value cant be Empty' : null,
                prefixIcon: Icon(
                  Icons.bloodtype,
                  // color: Colors.purple,
                ),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.lightGreen),
                minimumSize: MaterialStatePropertyAll(
                  Size(108, 45),
                ),
              ),
              onPressed: () {
                pickImageFromGallery();
              },
              child: Text('UPDATE IMAGE'),
            ),
            // selectedImage != null ? Image.file(imagepath!) : Text(""),
            const SizedBox(
              height: 2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.orange)),
                  onPressed: () async {
                    setState(() {
                      userNameController.text.isEmpty
                          ? validateuser = true
                          : validateuser = false;
                      studyController.text.isEmpty
                          ? validatestudy = true
                          : validatestudy = false;
                      ageController.text.isEmpty
                          ? validateage = true
                          : validateage = false;
                      bloodController.text.isEmpty
                          ? validateblood = true
                          : validateblood = false;
                    });
                    if (validateuser == false &&
                        validatestudy == false &&
                        validateage == false &&
                        validateblood == false) {
                      // print("data can save");
                      var user = User();
                      user.id = widget.user.id;
                      user.name = userNameController.text;
                      user.study = studyController.text;
                      user.age = ageController.text;
                      user.blood = bloodController.text;
                      user.selectedImage = selectedImage;
                      var result = await userService.UpdateUser(user);
                      Navigator.pop(context, result);
                    }
                  },
                  child: const Text(
                    'Update data',
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                  style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.red)),
                  onPressed: () {
                    userNameController.text = '';
                    studyController.text = '';
                    ageController.text = '';
                    bloodController.text = '';
                  },
                  child: const Text(
                    'Clear data',
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Future pickImageFromGallery() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnedImage == null) return;
    setState(() {
      imagepath = File(returnedImage.path);
      selectedImage = returnedImage.path.toString();
    });
  }
}
