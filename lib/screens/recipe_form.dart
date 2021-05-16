import 'dart:io';
import 'package:recipe_app_2/api/food_api.dart';
import 'package:recipe_app_2/model/recipe.dart';
import 'package:recipe_app_2/notifier/recipe_notifier.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tflite/tflite.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipe_app_2/helpers/Constants.dart';

class RecipeForm extends StatefulWidget {
  final bool isUpdating;

  RecipeForm({@required this.isUpdating});

  @override
  _RecipeFormState createState() => _RecipeFormState();
}

class _RecipeFormState extends State<RecipeForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String category_name = '';
  List _outputs;
  bool _loading = false;
  List _subingredients = [];
  Recipe _currentRecipe;
  String _imageUrl;
  File _imageFile;
  TextEditingController subingredientController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    RecipeNotifier recipeNotifier = Provider.of<RecipeNotifier>(context, listen: false);

    if (recipeNotifier.currentRecipe != null) {
      _currentRecipe = recipeNotifier.currentRecipe;
    } else {
      _currentRecipe = Recipe();
    }

    _subingredients.addAll(_currentRecipe.subIngredients);
    _imageUrl = _currentRecipe.image;

    super.initState();
    _loading = true;

    loadModel().then((value) {
      setState(() {
        _loading = false;
      });
    });
  }

  _showImage() {
    if (_imageFile == null && _imageUrl == null) {
      return Text("image placeholder");
    } else if (_imageFile != null) {
      print('showing image from local file');

      return Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          Image.file(
            _imageFile,
            fit: BoxFit.cover,
            height: 250,
          ),
          FlatButton(
            padding: EdgeInsets.all(16),
            color: Colors.black54,
            child: Text(
              'Change Image',
              style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w400),
            ),
            onPressed: () => _getLocalImage(),
          )
        ],
      );
    } else if (_imageUrl != null) {
      print('showing image from url');

      return Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          Image.network(
            _imageUrl,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
            height: 250,
          ),
          FlatButton(
            padding: EdgeInsets.all(16),
            color: Colors.black54,
            child: Text(
              'Change Image',
              style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w400),
            ),
            onPressed: () => _getLocalImage(),
          )
        ],
      );
    }
  }



  Widget _buildNameField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Name'),
      initialValue: _currentRecipe.name,
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 20),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Name is required';
        }

        if (value.length < 3 || value.length > 20) {
          return 'Name must be more than 3 and less than 20';
        }

        return null;
      },
      onSaved: (String value) {
        _currentRecipe.name = value;
      },
    );
  }
  var txt = TextEditingController();
  String dropdownValue = 'bread category';
  Widget _buildCategoryField() {
    return Container(
      alignment: Alignment.centerLeft,
      child: SizedBox(
          height: 60,
          child: DropdownButton<String>(
            focusColor:Colors.white,
            value: dropdownValue,
            //elevation: 5,
            style: TextStyle(color: Colors.white),
            iconEnabledColor:Colors.black,
            items: <String>['bread category', 'drinks category', 'fish category', 'meat category', 'noodles category',
              'rice category', 'seafood category', 'sweets category', 'vegetables category'].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value,style:TextStyle(color:Colors.black, fontSize: 20),),
              );
            }).toList(),
            onChanged: (String value) {
              setState(() {
                dropdownValue = value;
                _currentRecipe.category = value;
              });
            },
          )),
    );

    /*TextFormField(
      decoration: InputDecoration(labelText: 'Category'),
      controller: txt,
      keyboardType: TextInputType.text,
      style: TextStyle(fontSize: 20),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Category is required';
        }

        if (value.length < 3 || value.length > 20) {
          return 'Category must be more than 3 and less than 20';
        }

        return null;
      },
      onSaved: (String value) {
        _currentRecipe.category = value;
      },
    );*/
  }

  _buildSubingredientField() {
    return SizedBox(
      width: 200,
      child: TextField(
        controller: subingredientController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(labelText: 'Subingredient'),
        style: TextStyle(fontSize: 20),
      ),
    );
  }

  _onFoodUploaded(Recipe recipe) {
    RecipeNotifier recipeNotifier = Provider.of<RecipeNotifier>(context, listen: false);
    recipeNotifier.addRecipe(recipe);
    Navigator.pop(context);
  }

  _addSubingredient(String text) {
    if (text.isNotEmpty) {
      setState(() {
        _subingredients.add(text);
      });
      subingredientController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(iconTheme: IconThemeData(color: Colors.black, //change your color here
      ),backgroundColor: appWhiteColor, title: Text("Upload User Recipe",style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold,color: appBlackColor)
      ),),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(32),
        child: Form(
          key: _formKey,
          autovalidate: true,
          child: Column(children: <Widget>[
            _showImage(),
            SizedBox(height: 16),
            Text(
              widget.isUpdating ? "Edit Recipe" : "Create Recipe",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30),
            ),
            SizedBox(height: 16),
            _imageFile == null && _imageUrl == null
                ? ButtonTheme(
              child: RaisedButton(
                color: appGreyColor,
                onPressed: () => _getLocalImage(),
                child: Text(
                  'Add Image',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
                : SizedBox(height: 0),
            _buildNameField(),
            _buildCategoryField(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _buildSubingredientField(),
                ButtonTheme(
                  child: RaisedButton(
                    color: appGreyColor,
                    child: Text('Add', style: TextStyle(color: Colors.white)),
                    onPressed: () => _addSubingredient(subingredientController.text),
                  ),
                )
              ],
            ),
            SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              padding: EdgeInsets.all(8),
              crossAxisCount: 3,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
              children: _subingredients
                  .map(
                    (ingredient) => Card(
                  color: Colors.black54,
                  child: Center(
                    child: Text(
                      ingredient,
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                ),
              )
                  .toList(),
            ),Container(
                child: TextFormField(
                  decoration: InputDecoration(labelText: 'Steps'),
                  style: TextStyle(fontSize: 20),
                  minLines: 10, // any number you need (It works as the rows for the textarea)
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  initialValue: _currentRecipe.steps,
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'steps is required';
                    }
                    return null;
                  },
                  onSaved: (String value) {
                    _currentRecipe.steps = value;
                  },
                )
            )
          ]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          FocusScope.of(context).requestFocus(new FocusNode());
          _saveFood();
        },
        child: Icon(Icons.save),
        foregroundColor: Colors.white,
      ),
    );
  }

  _saveFood() {
    print('saveFood Called');
    if (!_formKey.currentState.validate()) {
      return;
    }

    _formKey.currentState.save();

    print('form saved');

    _currentRecipe.subIngredients = _subingredients;

    uploadRecipeAndImage(_currentRecipe, widget.isUpdating, _imageFile, _onFoodUploaded);

    print("name: ${_currentRecipe.name}");
    print("category: ${_currentRecipe.category}");
    print("subingredients: ${_currentRecipe.subIngredients.toString()}");
    print("_imageFile ${_imageFile.toString()}");
    print("_imageUrl $_imageUrl");
    print("steps: $_currentRecipe.steps");
  }
  _getLocalImage() async {
    File imageFile =
    await ImagePicker.pickImage(source: ImageSource.gallery, imageQuality: 50, maxWidth: 400);

    if (imageFile != null) {
      setState(() {
        _loading = true;
        _imageFile = imageFile;
      });
    }
    classifyImage(imageFile);
  }

  classifyImage(File image) async {
    var output = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 2,
      threshold: 0.5,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    setState(() {
      _loading = false;
      _outputs = output;
      RegExp exp = new RegExp(r"(\D+)");
      category_name = _outputs[0]["label"];
      Iterable<RegExpMatch> matches = exp.allMatches(category_name);
      category_name = matches.elementAt(0).group(0).trim();
      _currentRecipe.category = category_name;
      dropdownValue = category_name;
      txt.text = category_name;
      print("category: ${category_name}");
    });
  }

  loadModel() async {
    await Tflite.loadModel(
      model: "assets/tflite3/model.tflite",
      labels: "assets/tflite3/labels.txt",
    );
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }
}
