import 'package:app/screens/addmember/addmember_screen.dart';
import 'package:app/screens/addtransaction/addtransaction.dart';
import 'package:app/screens/editmember/editmember.dart';
import 'package:app/screens/error/error_screen.dart';
import 'package:app/screens/members/components/user.dart';
import 'package:app/screens/members/member_list.dart';
import 'package:app/screens/profile/profile_screen.dart';
import 'package:app/screens/setup/setup_screen.dart';
import 'package:app/services/user_activity_tracker_service.dart';
import 'package:flutter/material.dart';
import 'package:app/components/themes/maintheme.dart'; //import the main theme for the app
import 'package:app/screens/home/home_screen.dart'; // Import the necessary widgets
import 'package:app/screens/login/login_screen.dart';

void main() async {
  //WidgetsFlutterBinding.ensureInitialized();

  //WidgetsBinding.instance.addObserver(LifecycleObserver());

  runApp(const AppBarApp());
}
//void main() => runApp(const AppBarApp());

class AppBarApp extends StatelessWidget {
  const AppBarApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UserActivityTracker(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: mainTheme,
        initialRoute: '/',
        routes: {
          '/': (context) => const HomePage(),
          '/login': (context) => const LoginPage(),
          '/members': (context) => const MemberList(),
          '/profile': (context) => const ProfilePage(),
          '/addmember': (context) => const AddMemberPage(),
          '/setup': (context) => const SetupPage(),
          '/error': (context) => const LoginErrorWidget(),
          '/addtransaction': (context) {
            final arguments = ModalRoute.of(context)!.settings.arguments;
            if (arguments == null || arguments is! User) {
              return const AddTransactionPage(member: null);
            }
            final User member = arguments;
            return AddTransactionPage(member: member);
          },
          '/editmember': (context) => const EditMemberPage()
        },
      ),
    );
  }
}
