import 'package:flutter/material.dart';
import 'package:recipe_app_2/model/user.dart';
import 'package:recipe_app_2/model/food.dart';
// Colors
Color appBlueColor = Color.fromRGBO(158, 216, 255, 1);
Color appWhiteColor = Colors.white;
Color appDeepBlueColor = Color.fromRGBO(0, 47, 110, 1);
Color appPinkColor = Color.fromRGBO(255, 230, 223, 1);
Color appGreyColor = Color.fromRGBO(112, 112, 112, 1);
Color appBlackColor = Colors.black;
Color appGreenBlueColor = Color.fromRGBO(10, 85, 111, 1);
Color appMintColor = Color.fromRGBO(180, 241, 234, 1);
Color  job_location_color =Color.fromRGBO(0, 172, 226, 1);



//Tag
const mainScaffoldTag = 'mainScaffold Page';
const takePhotoPageTag = 'takePhotoPage Page';
const searchRecipeTag = 'searchRecipe Page';

const profileTag = 'profile Page';
List likedPost = [];
String global_searchString = '';
String username = '';
Set<String> savedWords = Set<String>();
String lastrecipe ='';
List<String> recommend_list;

//try for recommendation
