import 'package:excel/excel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:market_watch/utils/MToast.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final _userProfileDBRef = FirebaseDatabase.instance.ref().child("userRef");
  final _sessionsDBRef = FirebaseDatabase.instance.ref().child("sessions");
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<void> _createUsers() async {
    for (TempData tempData in await _getData()) {
      await Future.delayed(Duration(seconds: 1));
      print("-----------------------------------------");
      print("Started user creation for = " +
          tempData.email +
          " : " +
          tempData.name +
          " : " +
          tempData.contact);
      try {
        UserCredential userCredential =
            await firebaseAuth.createUserWithEmailAndPassword(
          email: tempData.email,
          password: "mw-ecell-23",
        );
        String userId = await userCredential.user!.uid;
        await _userProfileDBRef.child(userId).child("name").set(tempData.name);
        await _userProfileDBRef
            .child(userId)
            .child("contact")
            .set(tempData.contact);
        await _sessionsDBRef.child(userId).set(false);
        print("User creation successfully for = " +
            tempData.email +
            " : " +
            tempData.name +
            " : " +
            tempData.contact);
      } catch (error) {
        print(error);
        showMWToast(context, message: "Something went wrong!", isError: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: ElevatedButton(
        //onPressed: _createUsers,
        onPressed: _createUsers,
        child: Text("Create"),
      )),
    );
  }
}

Future<List<TempData>> _getData() async {
  ByteData data = await rootBundle.load('assets/files/MW_new.xlsx');
  var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  var excel = Excel.decodeBytes(bytes);
  List<TempData> tempData = [];

  for (var table in excel.tables.keys) {
    for (var row in excel.tables[table]!.rows) {
      int index = 0;
      String email = "", name = "", contact = "";
      for (Data? data in row) {
        if (data == null) {
          break;
        } else {
          if (index == 0) {
            name = data.value.toString();
          } else if (index == 1) {
            email = data.value.toString();
          } else if (index == 2) {
            contact = data.value.toString();
          }
          index++;
        }
      }
      if (!(email.isEmpty && name.isEmpty && contact.isEmpty)) {
        tempData.add(TempData(email: email, name: name, contact: contact));
      }
    }
  }
  return tempData;
}

class TempData {
  String email, name, contact;

  TempData({
    required this.email,
    required this.name,
    required this.contact,
  });
}
