import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:pal_example/ui/pages/home/home_model.dart';
import 'package:pal_example/ui/pages/home/home_presenter.dart';

abstract class HomeView {
  void pushToRoute1(final BuildContext context);
  void pushToRoute2(final BuildContext context);
}

class HomePage extends StatelessWidget implements HomeView {
  HomePage({Key key});

  @override
  Widget build(BuildContext context) {
    return MVVMPage<HomePresenter, HomeModel>(
      key: ValueKey('demo_HomePage'),
      presenter: HomePresenter(this),
      builder: (context, presenter, model) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: _buildHeader(),
            body: SingleChildScrollView(
              child: this._buildPage(
                context.buildContext,
                presenter,
                model,
              ),
            ),
            bottomNavigationBar: _buildBottomBar(context.buildContext),
          ),
        );
      },
    );
  }

  Widget _buildPage(
    final BuildContext context,
    final HomePresenter presenter,
    final HomeModel model,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: GestureDetector(
            onTap: () => pushToRoute1(context),
            child: _buildCard(
              'assets/images/posters/joker.jpg',
              400,
              'Trending now',
              'demo_HomePage_Cards_Joker',
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 0, 0),
          child: Text(
            'Get a look here',
            key: ValueKey('getalook'),
            style: TextStyle(
                color: Colors.blueGrey[500],
                fontSize: 21,
                fontWeight: FontWeight.bold),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 8, 16),
                child: GestureDetector(
                  onTap: () => pushToRoute2(context),
                  child: _buildCard(
                    'assets/images/posters/gump.png',
                    200,
                    'One more',
                    'demo_HomePage_Cards_Gump',
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 16, 16),
                child: _buildCard(
                  'assets/images/posters/truman.png',
                  200,
                  'Second one',
                  'demo_HomePage_Cards_Truman',
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  Container _buildCard(
    String imagePath,
    double height,
    String title,
    String key,
  ) {
    return Container(
      key: ValueKey(key),
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        color: Colors.blue,
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blueGrey[800].withOpacity(.2),
            blurRadius: 6,
            spreadRadius: 1,
            offset: Offset(0, 3),
          ),
          BoxShadow(
            color: Colors.blueGrey[200].withOpacity(.9),
            blurRadius: 2,
            spreadRadius: 2,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: 90,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(16),
              bottomLeft: Radius.circular(16),
            ),
            color: Colors.blueGrey[900].withOpacity(.8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  title,
                  style: TextStyle(color: Colors.white, fontSize: 21),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum '
                    'lorem ipsum lorem ipsum lorem ipsum lorem ',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildHeader() {
    return AppBar(
      title: Text(
        'Pal demo',
        style: TextStyle(color: Colors.blueGrey[900]),
      ),
      backgroundColor: Colors.white,
    );
  }

  _buildBottomBar(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
            key: ValueKey("homeIcon"),
            color: Colors.blueGrey,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.business, key: ValueKey("BusinessIcon"),),
          label: 'Business',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.school, key: ValueKey("SchoolIcon"),),
          label: 'School',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle_rounded, key: ValueKey("ProfileIcon")),
          label: 'Profile',
        ),
      ],
      currentIndex: 0,
      selectedItemColor: Colors.amber[800],
      unselectedItemColor: Colors.blueGrey[300],
      // onTap: _onItemTapped,
    );
  }

  @override
  void pushToRoute1(BuildContext context) {
    Navigator.pushNamed(context, '/route1');
  }

  @override
  void pushToRoute2(BuildContext context) {
    Navigator.pushNamed(context, '/route2');
  }
}
