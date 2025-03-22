import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user_quotes/controllers/authcontroller.dart';
import 'package:user_quotes/views/auth/gender_screen.dart';
import 'package:user_quotes/views/widgets/custom_button.dart';


class NameScreen extends StatefulWidget {
  const NameScreen({
    super.key,
  });

  @override
  NameScreenState createState() => NameScreenState();
}

class NameScreenState extends State<NameScreen> {
  final controller = Get.put(AuthController());



  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
   var width = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Container(
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
                height: height * 0.1,
              ),
              Form(
                key: _formKey,
                child: Container(
                  height: height * 0.06,
                  width: width * 0.85,
                  decoration: const BoxDecoration(
                      color: Colors.white54,
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextFormField(
                      controller: controller.nameController,
                      decoration: InputDecoration(
                        hintText: 'Enter your name',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
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
                    Get.to(
                          () => GenderScreen(
                        name: '',
                      ),
                    );
                  },
                ),
              ),


            ],
          ),
        ),
      ),
    );
  }
}
