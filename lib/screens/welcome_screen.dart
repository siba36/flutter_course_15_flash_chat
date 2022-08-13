import 'package:flutter/material.dart';
import 'package:flutter_course_15_flash_chat/screens/login_screen.dart';
import 'package:flutter_course_15_flash_chat/screens/registration_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_course_15_flash_chat/components/rounded_button.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_course_15_flash_chat/services/local_notification_service.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    // animation = CurvedAnimation(
    //   parent: controller,
    //   curve: Curves.decelerate,
    // );

    animation = ColorTween(
      begin: Colors.blueGrey,
      end: Colors.white,
    ).animate(controller);

    controller.forward();

    // animation.addStatusListener((status) {
    //   if (animation.isCompleted) {
    //     controller.reverse(from: 1);
    //   } else if (animation.isDismissed) {
    //     controller.forward();
    //   }
    // });

    controller.addListener(() {
      setState(() {});
      print(animation.value);
    });

    LocalNotificationService.initialize(context);

    //gives you the message that the user has tapped on
    //and it open the app from terminated state
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        print('background and terminated');
        print('notification title:${message.notification!.title}');
        print('notification body:${message.notification!.body}');
        final routeFromMessage = message.data['route'];
        print('route $routeFromMessage');
        Navigator.of(context).pushNamed(routeFromMessage);
      }
    });

    //the app is in foreground
    FirebaseMessaging.onMessage.listen((message) {
      LocalNotificationService.display(message);

      print('foreground');
      print('notification title:${message.notification!.title}');
      print('notification body:${message.notification!.body}');
    });

    //the app is in background but open
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('background and open');
      print('notification title:${message.notification!.title}');
      print('notification body:${message.notification!.body}');
      final routeFromMessage = message.data['route'];
      print('route $routeFromMessage');
      Navigator.of(context).pushNamed(routeFromMessage);
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 60,
                  ),
                ),
                AnimatedTextKit(
                  repeatForever: true,
                  animatedTexts: [
                    TypewriterAnimatedText(
                      'Flash Chat',
                      textStyle: TextStyle(
                        color: Colors.black54,
                        fontSize: 45.0,
                        fontWeight: FontWeight.w900,
                      ),
                    )
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedButton(
              color: Colors.lightBlueAccent,
              onPressed: () {
                Navigator.pushNamed(context, LoginScreen.id);
              },
              title: 'Log In',
            ),
            RoundedButton(
              color: Colors.blueAccent,
              onPressed: () {
                Navigator.pushNamed(context, RegistrationScreen.id);
              },
              title: 'Register',
            ),
          ],
        ),
      ),
    );
  }
}
