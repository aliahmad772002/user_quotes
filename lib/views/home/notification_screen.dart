import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:user_quotes/controllers/authcontroller.dart';
import 'package:user_quotes/model/user_model.dart';
import 'package:user_quotes/services/getkey_service.dart';
import 'package:user_quotes/views/widgets/custom_button.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final authController = Get.put(AuthController());
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  // Convert TimeOfDay to minutes
  int timeToMinutes(TimeOfDay time) {
    return time.hour * 60 + time.minute;
  }

  // Convert minutes to TimeOfDay
  TimeOfDay minutesToTime(int minutes) {
    int hour = minutes ~/ 60;
    int minute = minutes % 60;
    return TimeOfDay(hour: hour, minute: minute);
  }

  Future<void> _pickStartTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _startTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != _startTime) {
      setState(() {
        _startTime = picked;
      });
    }
  }

  Future<void> _pickEndTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _endTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != _endTime) {
      setState(() {
        _endTime = picked;
      });
    }
  }




  Future<void> sendNotification(String quote) async {
    UserModel user = authController.currentUser.value!;
    var body = {
      "message": {
        "token": user.tokenID!,
        "notification": {
          "body": quote,
          "title": 'Quote of the Day',
        },
        "android": {
          "notification": {
            "channel_id": "pushnotificationapp",
            "sound": "default",
          },
        },
        "data": {
          "source": "chat",
        }
      }
    };

    GetServerKey getServerKey = GetServerKey();
    String accessToken = await getServerKey.getServerKeyToken();

    final response = await http.post(
      Uri.parse('https://fcm.googleapis.com/v1/projects/quotesapp-42a80/messages:send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      print('Notification sent successfully: ${response.body}');
    } else {
      print('Failed to send notification: ${response.body}');
    }
  }

  Future<void> fetchAndSendQuoteNotification() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Quotes').get();
      if (querySnapshot.docs.isNotEmpty) {
        var randomDoc = querySnapshot.docs[Random().nextInt(querySnapshot.docs.length)];
        String quote = randomDoc['quote'];

        print('Fetched Quote: $quote');

        // Generate a random time between start and end time
        if (_startTime != null && _endTime != null) {
          int startMinutes = timeToMinutes(_startTime!);
          int endMinutes = timeToMinutes(_endTime!);

          if (startMinutes >= endMinutes) {
            print("Start time should be less than end time.");
            return;
          }

          // Random time between start and end
          int randomTimeInMinutes = Random().nextInt(endMinutes - startMinutes) + startMinutes;
          TimeOfDay randomTime = minutesToTime(randomTimeInMinutes);

          // Get current time in minutes
          int currentTimeInMinutes = timeToMinutes(TimeOfDay.now());

          // Calculate the difference in minutes
          int timeDifferenceInMinutes = randomTimeInMinutes - currentTimeInMinutes;

          if (timeDifferenceInMinutes <= 0) {
            print("Random time has already passed for today.");
            return;
          }

          // Wait until the random time arrives
          print("Notification will be sent at: ${randomTime.format(context)}");
          await Future.delayed(Duration(minutes: timeDifferenceInMinutes));

          // Send notification
          sendNotification(quote);
        } else {
          SnackBar snackBar = SnackBar(content: Text('Please select start and end time.'));
        }
      } else {
        SnackBar snackBar = SnackBar(content: Text('No quotes found.'));
      }
    } catch (e) {
      SnackBar snackBar = SnackBar(content: Text('Failed to fetch quotes: $e'));
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: height,
          width: width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(onTap: () => Get.back(), child: Icon(Icons.arrow_back)),
              SizedBox(height: height * 0.05),
              Text('Pick Start Time:'),
              ElevatedButton(
                onPressed: () => _pickStartTime(context),
                child: Text(_startTime != null ? _startTime!.format(context) : 'Select Start Time'),
              ),
              SizedBox(height: height * 0.05),
              Text('Pick End Time:'),
              ElevatedButton(
                onPressed: () => _pickEndTime(context),
                child: Text(_endTime != null ? _endTime!.format(context) : 'Select End Time'),
              ),
              SizedBox(height: height * 0.05),
              RoundedButton(
                btnname: 'Save',
                color: Colors.black,
                textstyle: TextStyle(
                  fontSize: width * 0.04,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange.shade200,
                ),
                callback: fetchAndSendQuoteNotification,

              ),
            ],
          ),
        ),
      ),
    );
  }
}
