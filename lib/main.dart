import 'package:recipe_app_2/notifier/food_notifier.dart';
import 'package:recipe_app_2/screens/feed.dart';
import 'package:recipe_app_2/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app_2/notifier/recipe_notifier.dart';
import 'notifier/auth_notifier.dart';
import 'package:recipe_app_2/screens/MainScaffold.dart';
import 'package:recipe_app_2/screens/takephoto.dart';
import 'package:recipe_app_2/screens/searchRecipe.dart';
import 'helpers/Constants.dart';

void main() => runApp(MultiProvider(
  providers: [
    ChangeNotifierProvider(
      create: (context) => AuthNotifier(),
    ),
    ChangeNotifierProvider(
      create: (context) => FoodNotifier(),
    ),
    ChangeNotifierProvider(
      create: (context) => RecipeNotifier(),
    ),
  ],
  child: MyApp(),
));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  final routes = <String, WidgetBuilder>{
    mainScaffoldTag:(context) => MainScaffold(),
    //takePhotoPageTag:(context) => takePhotoPage(),
    //searchRecipeTag:(context) => searchRecipe(),
    //profileTag:(context) => profile(),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Coding with Curry',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        accentColor: Colors.lightBlue,
      ),
      home: Consumer<AuthNotifier>(
        builder: (context, notifier, child) {
          return notifier.user != null ? MainScaffold() : Login();
        },
      ),
    );
  }
}