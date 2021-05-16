import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class recipeDetailScreen extends StatelessWidget {
  final image;

  ///For hero tagging and showing relative image
  recipeDetailScreen(this.image);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: <Widget>[
            ///First show the image in background
            ///
            FittedBox(
              child: Image.asset(image),
              fit: BoxFit.fill,
            ),
//            Hero(
//              child: Container(
//                height: size.height * 0.55,
//                child: Image.asset(
//                  image,
//                  fit: BoxFit.cover,
//                ),
//              ),
//              tag: image,
//            ),

            ///Container for more content
            DraggableScrollableSheet(
              maxChildSize: 1,
              initialChildSize: 0.6,
              minChildSize: 0.6,
              builder: (context, controller) {
                return SingleChildScrollView(
                  controller: controller,
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40),
                            topRight: Radius.circular(40))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[

                        Row(
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: Text(
                                "Apple Crisp with Cranberry Sauce",
                                style: GoogleFonts.roboto(
                                    fontSize: 22, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                                flex: 2,
                                child: IconButton(
                                  icon: Icon(Icons.favorite),
                                  color: Colors.redAccent,
                                  iconSize: 30,
                                  onPressed: () {},
                                )),
//                            Text(
//                              "Apple Crisp with Cranberry Sauce",
//                              style: GoogleFonts.roboto(
//                                  fontSize: 22, fontWeight: FontWeight.bold),
//                            ),
//                            Spacer(),
//                            IconButton(
//                              icon: Icon(Icons.favorite),
//                              color: Colors.redAccent,
//                              iconSize: 10,
//                              onPressed: () {},
//                            )
                          ],
                        ),
                        Text(
                          "By Michelle Ramey",
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.star,
                              color: Colors.orange,
                              size: 15,
                            ),
                            Icon(
                              Icons.star,
                              color: Colors.orange,
                              size: 15,
                            ),
                            Icon(
                              Icons.star,
                              color: Colors.orange,
                              size: 15,
                            ),
                            Icon(
                              Icons.star,
                              color: Colors.orange,
                              size: 15,
                            ),
                            Icon(
                              Icons.star,
                              color: Colors.grey[400],
                              size: 15,
                            ),
                          ],
                        ),

                        SizedBox(
                          height: 24,
                        ),

                        ///Container for food information
                        Container(
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border:
                                          Border.all(color: Colors.grey[200])),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        "Calories",
                                        style: GoogleFonts.roboto(
                                            color: Colors.grey),
                                      ),
                                      Text(
                                        "174KCal",
                                        style: GoogleFonts.roboto(
                                            color: Colors.grey[900],
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border:
                                          Border.all(color: Colors.grey[200])),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        "Ingredients",
                                        style: GoogleFonts.roboto(
                                            color: Colors.grey),
                                      ),
                                      Text(
                                        "06",
                                        style: GoogleFonts.roboto(
                                            color: Colors.grey[900],
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border:
                                          Border.all(color: Colors.grey[200])),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        "Time",
                                        style: GoogleFonts.roboto(
                                            color: Colors.grey),
                                      ),
                                      Text(
                                        "1 Hours",
                                        style: GoogleFonts.roboto(
                                            color: Colors.grey[900],
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(
                          height: 24,
                        ),

                        Text(
                          "About Recipe",
                          style: GoogleFonts.roboto(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),

                        SizedBox(
                          height: 4,
                        ),

                        Text(
                          "I devised this recipe when I was trying to use up that leftover homemade cranberry sauce from Thanksgiving! You could probably also use canned whole cranberry sauce for this recipe.",
                          style: GoogleFonts.roboto(
                              fontWeight: FontWeight.w300, color: Colors.grey),
                        ),

                        SizedBox(
                          height: 24,
                        ),

                        Text(
                          "Directions",
                          style: GoogleFonts.roboto(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),

                        SizedBox(
                          height: 4,
                        ),

                        Text(
                          "Step 1\n\nPreheat the oven to 350 degrees F (175 degrees C).\n\nStep 2\n\nPlace apple slices in an 8 or 9 inch square baking dish. Spread the cranberry sauce over the apples. In a medium bowl, stir together the flour, oats, brown sugar, cinnamon, and butter until crumbly. Sprinkle over the apples and cranberry sauce, covering completely.\n\nStep 3\n\nBake for 45 minutes in the preheated oven, or until apples can be easily pierced with a knife and topping is browned.",
                          style: GoogleFonts.roboto(
                              fontWeight: FontWeight.w300, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
