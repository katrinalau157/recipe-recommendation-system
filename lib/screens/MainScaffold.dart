import 'package:recipe_app_2/helpers/Constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'package:flutter/services.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'home_feed.dart';
import 'package:recipe_app_2/ig/ui_utils.dart';
import 'takephoto.dart';
import 'searchRecipe.dart';
import 'package:recipe_app_2/screens/feed.dart';
import 'package:recipe_app_2/screens/recommendation.dart';

class MainScaffold extends StatefulWidget {
  @override
  _MainScaffoldState createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  static const _kAddPhotoTabIndex = 2;
  int _tabSelectedIndex = 0;

  // Save the home page scrolling offset,
  // used when navigating back to the home page from another tab.
  double _lastFeedScrollOffset = 0;
  ScrollController _scrollController;

  @override
  void dispose() {
    _disposeScrollController();
    super.dispose();
  }

  void _scrollToTop() {
    if (_scrollController == null) {
      return;
    }
    _scrollController.animateTo(
      0.0,
      duration: Duration(milliseconds: 250),
      curve: Curves.decelerate,
    );
  }

  // Call this when changing the body that doesn't use a ScrollController.
  void _disposeScrollController() {
    if (_scrollController != null) {
      _lastFeedScrollOffset = _scrollController.offset;
      _scrollController.dispose();
      _scrollController = null;
    }
  }

  void _onTabTapped(BuildContext context, int index) {
    if (index == _kAddPhotoTabIndex) {
      setState(() => _tabSelectedIndex = index);
    } else if (index == _tabSelectedIndex) {
      _scrollToTop();
    } else {
      setState(() => _tabSelectedIndex = index);
    }
  }

  Widget _buildPlaceHolderTab(String tabName) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 64.0),
        child: Column(
          children: <Widget>[
            Text(
              'Oops, the $tabName tab is\n under construction!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 28.0),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    switch (_tabSelectedIndex) {
      case 0:
//        _scrollController =
//            ScrollController(initialScrollOffset: _lastFeedScrollOffset);
        return HomeFeedPage(scrollController: _scrollController);
      case 1:
//        _scrollController =
//            ScrollController(initialScrollOffset: _lastFeedScrollOffset);
        return Feed();

      case 2:
//        _scrollController =
//            ScrollController(initialScrollOffset: _lastFeedScrollOffset);
        return takePhotoPage();
      case 3:
//        _scrollController =
//            ScrollController(initialScrollOffset: _lastFeedScrollOffset);
        return recommendation();
      case 4:
//        _scrollController =
//            ScrollController(initialScrollOffset: _lastFeedScrollOffset);
        return Container();
      default:
        const tabIndexToNameMap = {
          0: 'Home',
          1: 'Search',
          2: 'Add Photo',
          3: 'recommendation',
          4: 'Profile',
        };
        _disposeScrollController();
        return _buildPlaceHolderTab(tabIndexToNameMap[_tabSelectedIndex]);
    }
  }

  // Unselected tabs are outline icons, while the selected tab should be solid.
  Widget _buildBottomNavigation() {
    const unselectedIcons = <IconData>[
      OMIcons.home,
      Icons.search,
      OMIcons.addBox,
      Icons.favorite_border,
      Icons.person_outline,
    ];
    const selecteedIcons = <IconData>[
      Icons.home,
      Icons.search,
      Icons.add_box,
      Icons.favorite,
      Icons.person,
    ];
    final bottomNaivgationItems = List.generate(5, (int i) {
      final iconData =
      _tabSelectedIndex == i ? selecteedIcons[i] : unselectedIcons[i];
      return BottomNavigationBarItem(icon: Icon(iconData), title: Container());
    }).toList();

    return Builder(builder: (BuildContext context) {
      return BottomNavigationBar(
        selectedItemColor: appBlackColor,
        iconSize: 32.0,
        type: BottomNavigationBarType.fixed,
        items: bottomNaivgationItems,
        currentIndex: _tabSelectedIndex,
        onTap: (int i) => _onTabTapped(context, i),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appWhiteColor,
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
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }
}