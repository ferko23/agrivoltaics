import 'package:flutter/material.dart';
import 'dashboard/dashboard.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: const [
          NotificationButton()
        ],
      ),
      endDrawer: const Drawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              child: const Text('View Data'),
              onPressed: () => {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DashboardPage()
                    )
                  )
              },
            ),
            // TODO: determine whether we will have this functionality
            // ElevatedButton(
            //   child: const Text('Manage Sensors'),
            //   onPressed: () => {print('hello')},
            // ),
            ElevatedButton(
              child: const Text('Settings'),
              onPressed: () => {debugPrint('Settings selected')},
            )
          ],
        ),
      ),
    );
  }
}

class NotificationButton extends StatelessWidget {
  const NotificationButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
            onPressed: () {
              Scaffold.of(context).openEndDrawer();
            },
            icon: Stack(
              children: const [
                Icon(
                  Icons.notifications,
                ),
                Positioned(
                  child: Icon(
                    Icons.brightness_1,
                    color: Colors.red,
                    size: 9.0
                  )
                )
              ]
            )
          ),
        );
      }
    );
  }
}
