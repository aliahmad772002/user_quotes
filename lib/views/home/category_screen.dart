import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user_quotes/views/Category/general.dart';
import 'package:user_quotes/views/Category/happy.dart';
import 'package:user_quotes/views/Category/love.dart';
import 'package:user_quotes/views/Category/motivation.dart';
import 'package:user_quotes/views/Category/sad.dart';
import 'package:user_quotes/views/Category/success.dart';
import 'package:user_quotes/views/widgets/custom_container.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  Widget build(BuildContext context) {
    var height= MediaQuery.of(context).size.height;
    var width= MediaQuery.of(context).size.width;
    return  SafeArea(
      child: Scaffold(
        body:Container(
          height: height,
          width: width,
        child: Column(


          children: [
          Row(
            children: [
              CustomContainer(text: "General", callback: (){
                Get.to(()=>GeneralScreen());
              }),
              CustomContainer(text: "Love", callback: (){
                Get.to(()=>LoveScreen());
              }),
            ],
          ),
          Row(
            children: [
              CustomContainer(text: "Motivation", callback: (){
                Get.to(()=>MotivationScreen());
              }),
              CustomContainer(text: "Happy", callback: (){
                Get.to(()=>HappyScreen());
              }),
            ],
          ),
          Row(
            children: [
              CustomContainer(text: "Sad", callback: (){
                Get.to(()=>SadScreen());
              }),
              CustomContainer(text: "Success", callback: (){
                Get.to(()=>SuccessScreen());
              }),
            ],
          ),

          ],
        )
        )
      ),
    );
  }
}
