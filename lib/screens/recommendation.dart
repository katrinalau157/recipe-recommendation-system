import 'package:http/http.dart' ;
import 'dart:convert';
import 'package:recipe_app_2/api/food_api.dart';
import 'package:recipe_app_2/notifier/auth_notifier.dart';
import 'package:recipe_app_2/notifier/food_notifier.dart';
import 'package:recipe_app_2/screens/detail.dart';
import 'package:recipe_app_2/screens/food_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipe_app_2/helpers/Constants.dart';

Future hahaha() async {
  var url = Uri.parse('http://10.0.2.2:5000/');
  var response = await post(
      url, body: {'title': lastrecipe});
  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');
  var decodedData = jsonDecode(response.body)['recipename'];
  //recommend_list = decodedData['recipename'];
  print(decodedData);
  print(decodedData.runtimeType);
  recommend_list = [];
  decodedData.forEach((element) => recommend_list.add(element.toString()));
  //List<dynamic>
  //print(await read('http://10.0.2.2:5000/'));
  //getData123();
  print(recommend_list);
}


class recommendation extends StatefulWidget {
  @override
  _recommendationState createState() => _recommendationState();
}

class _recommendationState extends State<recommendation> {
  @override
  void initState() {
    //recommend_list = [];
    //foodList123 = [];
    hahaha();
    FoodNotifier foodNotifier = Provider.of<FoodNotifier>(context, listen: false);
    getrecommendFoodsbyCos(foodNotifier,recommend_list);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    FoodNotifier foodNotifier = Provider.of<FoodNotifier>(context);

    Future<void> _refreshList() async {
      getrecommendFoodsbyCos(foodNotifier,recommend_list);
    }

    print("building Feed");
    return Scaffold(

      body: new RefreshIndicator(
        child: ListView.separated(
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              leading: Image.network(
                foodNotifier.foodList[index].image != null
                    ? foodNotifier.foodList[index].image
                    : 'https://www.testingxperts.com/wp-content/uploads/2019/02/placeholder-img.jpg',
                width: 120,
                fit: BoxFit.fitWidth,
              ),
              title: Text(foodNotifier.foodList[index].name),
              subtitle: Text(foodNotifier.foodList[index].category),
              onTap: () {
                foodNotifier.currentFood = foodNotifier.foodList[index];
                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                  return FoodDetail();
                }));
              },
            );
          },
          itemCount: foodNotifier.foodList.length,
          separatorBuilder: (BuildContext context, int index) {
            return Divider(
              color: Colors.black,
            );
          },
        ),
        onRefresh: _refreshList,
      ),

    );
  }
}