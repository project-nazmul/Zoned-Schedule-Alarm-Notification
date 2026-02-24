import 'package:flutter/material.dart';
import 'package:zoned_schedule/notification_service.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().initNotification();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              ElevatedButton(
                onPressed: (){
                  // To schedule 10 seconds from now:
                  NotificationService().scheduleNotification(
                    1,
                    "Hello!",
                    "This is your scheduled notification",
                    DateTime.now().add(const Duration(seconds: 10)),
                  );
                },
                child: Text("Set Alarm")
              )
            ],
          ),
        ),
      ),
    );
  }
}
