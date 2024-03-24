import 'package:expense_tracker/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/database/expense_database.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  ///initialize db
  await ExpenseDatabase.initialize();

  runApp(
    // Wrap your app with MultiProvider if you have multiple providers
    // In this case, we have only one provider, so ChangeNotifierProvider is sufficient
    ChangeNotifierProvider(
      create: (context) => ExpenseDatabase(),
      child: const MyApp(), // Provide MyApp as the child
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
