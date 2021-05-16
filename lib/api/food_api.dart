import 'dart:io';
import 'package:recipe_app_2/model/recipe.dart';
import 'package:recipe_app_2/model/food.dart';
import 'package:recipe_app_2/model/user.dart';
import 'package:recipe_app_2/notifier/auth_notifier.dart';
import 'package:recipe_app_2/notifier/food_notifier.dart';
import 'package:recipe_app_2/notifier/recipe_notifier.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';
import 'package:recipe_app_2/helpers/Constants.dart';

login(User user, AuthNotifier authNotifier) async {
  AuthResult authResult = await FirebaseAuth.instance
      .signInWithEmailAndPassword(email: user.email, password: user.password)
      .catchError((error) => print(error.code));

  if (authResult != null) {
    FirebaseUser firebaseUser = authResult.user;

    if (firebaseUser != null) {
      print("Log In: $firebaseUser");
      authNotifier.setUser(firebaseUser);
    }
  }
}

signup(User user, AuthNotifier authNotifier) async {
  AuthResult authResult = await FirebaseAuth.instance
      .createUserWithEmailAndPassword(email: user.email, password: user.password)
      .catchError((error) => print(error.code));

  if (authResult != null) {
    UserUpdateInfo updateInfo = UserUpdateInfo();
    updateInfo.displayName = user.displayName;

    FirebaseUser firebaseUser = authResult.user;

    if (firebaseUser != null) {
      await firebaseUser.updateProfile(updateInfo);

      await firebaseUser.reload();

      print("Sign up: $firebaseUser");

      FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
      authNotifier.setUser(currentUser);
    }
  }
}

signout(AuthNotifier authNotifier) async {
  await FirebaseAuth.instance.signOut().catchError((error) => print(error.code));

  authNotifier.setUser(null);
}

initializeCurrentUser(AuthNotifier authNotifier) async {
  FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();

  if (firebaseUser != null) {
    print(firebaseUser);
    authNotifier.setUser(firebaseUser);
  }
}
//original food
getFoods(FoodNotifier foodNotifier) async {
  QuerySnapshot snapshot = await Firestore.instance
      .collection('foods')
      .orderBy("createdAt", descending: true)
      .getDocuments();

  List<Food> _foodList = [];

  snapshot.documents.forEach((document) {
    Food food = Food.fromMap(document.data);
    _foodList.add(food);
  });

  foodNotifier.foodList = _foodList;
}
///recommend food by search
getrecommendFoods(FoodNotifier foodNotifier, String queryString) async {
  QuerySnapshot snapshot = await Firestore.instance
      .collection('foods')
      .where('subIngredients',arrayContains: queryString)
      .getDocuments();

  List<Food> _foodList = [];

  snapshot.documents.forEach((document) {
    Food food = Food.fromMap(document.data);
    _foodList.add(food);
  });

  foodNotifier.foodList = _foodList;
}
///recommend food by cosine similarity
getrecommendFoodsbyCos(FoodNotifier foodNotifier, List recipename) async {

  QuerySnapshot snapshot = await Firestore.instance
      .collection('foods')
      .where('name',whereIn: recipename)
      .getDocuments();

  List<Food> _foodList = [];

  snapshot.documents.forEach((document) {
    Food food = Food.fromMap(document.data);
    _foodList.add(food);
  });

  foodNotifier.foodList = _foodList;
}

uploadFoodAndImage(Food food, bool isUpdating, File localFile, Function foodUploaded) async {
  if (localFile != null) {
    print("uploading image");

    var fileExtension = path.extension(localFile.path);
    print(fileExtension);

    var uuid = Uuid().v4();

    final StorageReference firebaseStorageRef =
    FirebaseStorage.instance.ref().child('foods/images/$uuid$fileExtension');

    await firebaseStorageRef.putFile(localFile).onComplete.catchError((onError) {
      print(onError);
      return false;
    });

    String url = await firebaseStorageRef.getDownloadURL();
    print("download url: $url");
    _uploadFood(food, isUpdating, foodUploaded, imageUrl: url);
  } else {
    print('...skipping image upload');
    _uploadFood(food, isUpdating, foodUploaded);
  }
}

_uploadFood(Food food, bool isUpdating, Function foodUploaded, {String imageUrl}) async {
  CollectionReference foodRef = Firestore.instance.collection('foods');

  if (imageUrl != null) {
    food.image = imageUrl;
  }

  if (isUpdating) {
    //food.updatedAt = Timestamp.now();

    //await foodRef.document(food.id).updateData(food.toMap());

   // foodUploaded(food);
   // print('updated food with id: ${food.id}');
  } else {
    food.createdAt = Timestamp.now();

    DocumentReference documentRef = await foodRef.add(food.toMap());

    food.id = documentRef.documentID;

    print('uploaded food successfully: ${food.toString()}');

    await documentRef.setData(food.toMap(), merge: true);

    foodUploaded(food);
  }
}

deleteFood(Food food, Function foodDeleted) async {
  if (food.image != null) {
    StorageReference storageReference =
    await FirebaseStorage.instance.getReferenceFromUrl(food.image);

    print(storageReference.path);

    await storageReference.delete();

    print('image deleted');
  }

  await Firestore.instance.collection('foods').document(food.id).delete();
  foodDeleted(food);
}

//user recipe
getRecipes(RecipeNotifier recipeNotifier) async {
  QuerySnapshot snapshot = await Firestore.instance
      .collection('recipes')
      .orderBy("createdAt", descending: true)
      .getDocuments();

  List<Recipe> _RecipeList = [];

  snapshot.documents.forEach((document) {
    Recipe recipe = Recipe.fromMap(document.data);
    _RecipeList.add(recipe);
  });

  recipeNotifier.recipeList = _RecipeList;
}

uploadRecipeAndImage(Recipe recipe, bool isUpdating, File localFile, Function foodUploaded) async {
  if (localFile != null) {
    print("uploading image");

    var fileExtension = path.extension(localFile.path);
    print(fileExtension);

    var uuid = Uuid().v4();

    final StorageReference firebaseStorageRef =
    FirebaseStorage.instance.ref().child('recipes/images/$uuid$fileExtension');

    await firebaseStorageRef.putFile(localFile).onComplete.catchError((onError) {
      print(onError);
      return false;
    });

    String url = await firebaseStorageRef.getDownloadURL();
    print("download url: $url");
    _uploadRecipe(recipe, isUpdating, foodUploaded, imageUrl: url);
  } else {
    print('...skipping image upload');
    _uploadRecipe(recipe, isUpdating, foodUploaded);
  }
}

_uploadRecipe(Recipe recipe, bool isUpdating, Function foodUploaded, {String imageUrl}) async {
  CollectionReference foodRef = Firestore.instance.collection('recipes');

  if (imageUrl != null) {
    recipe.image = imageUrl;
  }

  if (isUpdating) {
    //food.updatedAt = Timestamp.now();

    //await foodRef.document(food.id).updateData(food.toMap());

    // foodUploaded(food);
    // print('updated food with id: ${food.id}');
  } else {
    recipe.createdAt = Timestamp.now();

    DocumentReference documentRef = await foodRef.add(recipe.toMap());

    recipe.id = documentRef.documentID;

    print('uploaded recipes successfully: ${recipe.toString()}');

    await documentRef.setData(recipe.toMap(), merge: true);

    foodUploaded(recipe);
  }
}

deleteRecipe(Recipe recipe, Function foodDeleted) async {
  if (recipe.image != null) {
    StorageReference storageReference =
    await FirebaseStorage.instance.getReferenceFromUrl(recipe.image);

    print(storageReference.path);

    await storageReference.delete();

    print('image deleted');
  }

  await Firestore.instance.collection('recipes').document(recipe.id).delete();
  foodDeleted(recipe);
}