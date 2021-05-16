import 'package:flutter/material.dart';
import 'package:recipe_app_2/ig/post_widget.dart';
import 'package:recipe_app_2/ig/models.dart';
import 'package:recipe_app_2/ig/ui_utils.dart';
import 'package:recipe_app_2/ig/avatar_widget.dart';
import 'package:recipe_app_2/api/food_api.dart';
import 'package:recipe_app_2/notifier/auth_notifier.dart';
import 'package:recipe_app_2/notifier/recipe_notifier.dart';
import 'package:recipe_app_2/screens/detail.dart';
import 'package:recipe_app_2/screens/recipe_form.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipe_app_2/helpers/Constants.dart';

class HomeFeedPage extends StatefulWidget {
  final ScrollController scrollController;

  HomeFeedPage({this.scrollController});

  @override
  _HomeFeedPageState createState() => _HomeFeedPageState();
}

class _HomeFeedPageState extends State<HomeFeedPage> {
  void initState() {
    RecipeNotifier recipeNotifier = Provider.of<RecipeNotifier>(context, listen: false);
    getRecipes(recipeNotifier);
    super.initState();

  }

  final _posts = <Post>[
    Post(
      user: grootlover,
      imageUrls:
        'assets/images/apple.jpg',

      likes: [
      ],/*
      comments: [
        Comment(
          text: 'An apple',
          user: rocket,
          commentedAt: DateTime(2019, 5, 23, 14, 35, 0),
          likes: [Like(user: nickwu241)],
        ),
      ],*/
      location: 'Vegetable Category',
      postedAt: DateTime(2019, 5, 23, 12, 35, 0),
    ),

  /*
    Post(
      user: nickwu241,
      imageUrls: ['assets/images/apple.jpg'],
      likes: [],
      //comments: [],
      location: 'Knowhere',
      postedAt: DateTime(2019, 5, 21, 6, 0, 0),
    ),

    Post(
      user: nebula,
      imageUrls: ['assets/images/pasta.jpeg'],
      likes: [],
      //comments: [],
      location: 'Nine Realms',
      postedAt: DateTime(2019, 5, 2, 0, 0, 0),
    ),*/
  ];
  List addpost1 = [Post(
    user: nebula,
    imageUrls: 'assets/images/pasta.jpeg',
    likes: [],
    //comments: [],
    location: 'Nine Realms',
    postedAt: DateTime(2019, 5, 2, 0, 0, 0),
  )];

  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier = Provider.of<AuthNotifier>(context);
    RecipeNotifier recipeNotifier = Provider.of<RecipeNotifier>(context);
    username = authNotifier.user != null ? authNotifier.user.displayName : '';
    Future<void> _refreshList() async {
      getRecipes(recipeNotifier);
    }
    List addpost2 = [Post(
      user: nebula,
      imageUrls: 'assets/images/apple.jpeg',
      likes: [],
      //comments: [],
      location: 'Nine Realms',
      postedAt: DateTime(2019, 5, 2, 0, 0, 0),
    )];
    addpost1.addAll(addpost2);

    return Scaffold(
        appBar: AppBar(
          elevation: 0.1,
          title: Text(
              authNotifier.user != null ? authNotifier.user.displayName : "Feed",style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold,color: appBlackColor)
          ),
          actions: <Widget>[
// action button
            FlatButton(
              onPressed: () => signout(authNotifier),
              child: Text(
                "Logout",
                style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold,color: appBlackColor, fontSize: 20),
              ),
            ),
          ],
          backgroundColor: appWhiteColor,
          bottom: PreferredSize(
              child: Container(
                color: Colors.black,
                height: 2.0,
              ),
              preferredSize: Size.fromHeight(4.0)),
        ),
/////////////////////////////////////////////////////////////////////
        body: new ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return PostWidget(Post(
                user: User(name: recipeNotifier.recipeList[index].name, imageUrl: 'assets/images/user_shape.png'),
                imageUrls:  recipeNotifier.recipeList[index].image,
                likes: [],
                //comments: [],
                location: recipeNotifier.recipeList[index].category,
                postedAt: DateTime(2019, 5, 2, 0, 0, 0),
              ));
              },
            itemCount: recipeNotifier.recipeList.length,
          /*
          itemBuilder: (ctx, i) {
            return PostWidget(addpost1[i]);
          },
          itemCount: addpost1.length-1,
          controller: widget.scrollController,

           */
        ),
        /*
        ListView.separated(
          itemBuilder: (BuildContext context, int index) {
            return PostWidget(Post(
      user: Text(foodNotifier.foodList[index].name),
      imageUrls: foodNotifier.foodList[index].image != null
                    ? foodNotifier.foodList[index].image
                    : 'https://www.testingxperts.com/wp-content/uploads/2019/02/placeholder-img.jpg',
      likes: [],
      //comments: [],
      location: Text(foodNotifier.foodList[index].category),
      postedAt: DateTime(2019, 5, 2, 0, 0, 0),
    );
    },
    itemCount: foodNotifier.foodList.length,


            PostWidget(
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
        **/
        floatingActionButton: FloatingActionButton(
        onPressed: () {

        recipeNotifier.currentRecipe = null;
        Navigator.of(context).push(
        MaterialPageRoute(builder: (BuildContext context) {
          return RecipeForm(
            isUpdating: false,
          );
        }),
      );

    },
    child: Icon(Icons.add),
    foregroundColor: Colors.white,
    ),
    );
  }
}

