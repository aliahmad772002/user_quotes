import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user_quotes/controllers/authcontroller.dart';
import 'package:user_quotes/controllers/quotes_controller.dart';
import 'package:user_quotes/views/home/category_screen.dart';

class MotivationScreen extends StatefulWidget {

  MotivationScreen({
    super.key,
  });

  @override
  MotivationScreenState createState() => MotivationScreenState();
}

class MotivationScreenState extends State<MotivationScreen> {
  final authcontroller = Get.put(AuthController());
  final quoteController = Get.put(QuoteController());

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Image.asset(
              "images/bg.jpg",
              fit: BoxFit.cover,
              height: height,
              width: width,
            ),
            FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance
                  .collection("Quotes")
                  .where('category', isEqualTo: "Motivation")
                  .get(),
              builder:
                  (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) return Text('Something went wrong');
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.pink),
                        ),
                        SizedBox(height: 10),
                        Text('Loading...', style: TextStyle(color: Colors.pink)),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  physics: const PageScrollPhysics(),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var quoteText = snapshot.data!.docs[index].get('quote');
                    var quoteId = snapshot.data!.docs[index].id;
                    String? currentUserId = authcontroller.currentUser.value!.uid;

                    return Container(
                      height: height,
                      width: width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                top: height * 0.37,
                                bottom: height * 0.1,
                                left: 30,
                                right: 30),
                            child: Text(
                              quoteText,
                              style: TextStyle(
                                fontFamily: "RobotoSlab",
                                fontWeight: FontWeight.bold,
                                fontSize: width * 0.05,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 100),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.share_outlined,
                                    color: Colors.black,
                                    size: 25,
                                  ),
                                ),
                                Obx(() {
                                  bool isLiked = quoteController.likedQuotes.contains(quoteId);
                                  return IconButton(
                                    onPressed: () {
                                      quoteController.handleLikeDislike(quoteId, currentUserId);
                                    },
                                    icon: Icon(
                                      isLiked ? Icons.favorite : Icons.favorite_border,
                                      color: isLiked ? Colors.red : Colors.black,
                                      size: 25,
                                    ),
                                  );
                                }),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),


            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.to(() => const CategoryScreen(), );

                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      height: height * 0.06,
                      width: width * 0.15,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: const Icon(
                        Icons.category,
                        color: Colors.black87,
                        size: 30,
                      ),
                    ),
                  ),


                  GestureDetector(
                    onTap: () {

                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 20),
                      height: height * 0.06,
                      width: width * 0.15,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Colors.white,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.notification_important,
                          color: Colors.black87,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}