import 'package:recipe_app_2/api/food_api.dart';
import 'package:recipe_app_2/notifier/auth_notifier.dart';
import 'package:recipe_app_2/notifier/food_notifier.dart';
import 'package:recipe_app_2/screens/detail.dart';
import 'package:recipe_app_2/screens/food_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipe_app_2/helpers/Constants.dart';

class searchResult extends StatefulWidget {
  @override
  _searchResultState createState() => _searchResultState();
}

class _searchResultState extends State<searchResult> {
  @override
  void initState() {
    FoodNotifier foodNotifier = Provider.of<FoodNotifier>(context, listen: false);
    getrecommendFoods(foodNotifier,global_searchString);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context);
    FoodNotifier foodNotifier = Provider.of<FoodNotifier>(context);

    Future<void> _refreshList() async {
      getrecommendFoods(foodNotifier,global_searchString);
    }

    print("building Feed");
    return Scaffold(
      appBar: AppBar(
      centerTitle: true,
      elevation: 0.1,
      title: Text('Foodcithy',style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold,color: appBlackColor),),
      backgroundColor: appWhiteColor,
      bottom: PreferredSize(
          child: Container(
            color: Colors.black,
            height: 2.0,
          ),
          preferredSize: Size.fromHeight(4.0)),
    ),

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