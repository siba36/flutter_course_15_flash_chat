import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_course_15_flash_chat/screens/welcome_screen.dart';
import 'package:flutter_course_15_flash_chat/screens/login_screen.dart';
import 'package:flutter_course_15_flash_chat/screens/registration_screen.dart';
import 'package:flutter_course_15_flash_chat/screens/chat_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_course_15_flash_chat/services/local_notification_service.dart';

Future<void> backgroundHandler(RemoteMessage? message) async {
  print('background handler');
  print('message data: ${message!.data.toString()}');
  print('notification title: ${message.notification!.title}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  runApp(FlashChat());
}

class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        ChatScreen.id: (context) => ChatScreen(),
      },
    );
  }
}
