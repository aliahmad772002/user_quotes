import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user_quotes/controllers/authcontroller.dart';
import 'package:user_quotes/views/home/home_screen.dart';
import 'package:user_quotes/views/widgets/custom_button.dart';


class GenderScreen extends StatefulWidget {
  String name;
  GenderScreen({
    super.key,
    required this.name,
  });

  @override
  GenderScreenState createState() => GenderScreenState();
}

class GenderScreenState extends State<GenderScreen> {
  final controller = Get.put(AuthController());


  List<String> options = <String>[
    'Male',
    'Female',
    'Other',
  ];

  String dropdownValue = 'One';

  @override
  Widget build(BuildContext context) {
   var height = MediaQuery.of(context).size.height;
   var  width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.orange.withOpacity(0.35),
              Colors.green.withOpacity(0.4),
            ],
          ),
        ),
        child: Column(
          children: [

        SizedBox(
              height: height * 0.4,
            ),
            Container(

              width: width * 0.85,
              decoration: BoxDecoration(
                  color: Colors.white60,
                  borderRadius: BorderRadius.circular(16)),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: DropdownButton<String>(
                borderRadius: BorderRadius.circular(16),
                value: controller.dropdownValue,
                onChanged: (String? value) {
                  setState(() {
                    controller.dropdownValue = value!;
                  });
                },
                underline: const SizedBox(),
                isExpanded: true,
                style: TextStyle(
                    color: Colors.orange,
                    fontSize: width * 0.04,
                    fontWeight: FontWeight.bold),
                dropdownColor: Colors.black87,
                icon:
                const Icon(Icons.keyboard_arrow_down, color: Colors.black),
                items: options.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            SizedBox(
              height: height * 0.03,
            ),
            Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: RoundedButton(
                  btnname: "Continue",
                  callback: () {

                    controller.useradd();
                    Get.to(
                          () =>  HomeScreen(),
                    );
                  },
                )),



          ],
        ),
      ),
    );
  }
}
