import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertestapp/LoadoutForm.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'loadoutInfo.dart';
import 'EnterCallsign.dart';

void main() {
  runApp(MyApp());
}



class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OutCOD',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blueGrey,
        canvasColor: Color(0xff555555),
        fontFamily: 'Bebas Neue',
        buttonTheme: ButtonThemeData(
          buttonColor: Color(0xff666680),
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blueGrey),
        ),
        textTheme: TextTheme(
          body1: TextStyle(fontFamily: 'Bebas Neue', color: Color(0xffffffff)),
          body2: TextStyle(fontFamily: 'Bebas Neue', color: Color(0xffaaaaaa)),
          display1: TextStyle(fontFamily: 'Bebas Neue', color: Color(0xffffffff), fontSize: 26),
          display2: TextStyle(fontFamily: 'Bebas Neue', color: Color(0xffaaaaaa), fontSize: 20),
          display3: TextStyle(fontFamily: 'Bebas Neue', color: Color(0xffffffff), fontSize: 22),
          headline: TextStyle(fontFamily: 'Bebas Neue', color: Color(0xffffffff), fontSize: 48),
        )
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}



class _MyHomePageState extends State<MyHomePage> {
  // Vars go here?
  String callsign = "";
  List cardRole = new List();
  List cardText = new List();
  int numCards = 2;


  // Funcs go here?
  @override
  @mustCallSuper
  void initState() {
    super.initState();

    cardRole.add(cardRoles.newCard);
    cardRole.add(cardRoles.deleteAll);
    cardText.add("Add New Loadout");
    cardText.add("Remove All Loadouts");

    loadData();

    setState(() {    });
  }

  void loadData() async {
    SharedPreferences data = await SharedPreferences.getInstance();
    if (data.containsKey('callsign')) {
      callsign = data.getString('callsign');
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => EnterCallsign()));
    }

    int i = 0;
    while(data.containsKey("loadoutName$i")) {
      String name = data.getString('loadoutName$i');
      cardRoles role = cardRoles.values[data.getInt('loadoutRole$i')];
      newLoadout(role, name);
      i++;
    }

    numCards = i + 2;

    setState(() {});
  }

  void updateLoadout(cardRoles role, String loadoutName, int index) {
    cardRole[index] = role;
    cardText[index] = loadoutName;
  }

  void newLoadout(cardRoles role, String loadoutName) {
    cardRole.insert(numCards - 2, role);
    cardText.insert(numCards - 2, loadoutName);
    numCards++;
  }

  void _showDelAllDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Warning!"),
          content: new Text("Are you sure you want to remove all loadouts?"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () { removeAllCards();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => EnterCallsign())); },
            ),
            new FlatButton(
              child: new Text("Cancel"),
              onPressed: () { Navigator.of(context).pop(); },
            ),
          ],
        );
      }
    );
  }

  void removeAllCards() async {
    while (cardRole.length > 2) {
      cardRole.removeAt(0);
      cardText.removeAt(0);
    }

    SharedPreferences data = await SharedPreferences.getInstance();
    for (int i = 0; i < numCards - 2; i++) {
      if (data.containsKey("loadoutName$i")) {
        data.remove("loadoutName$i");
        data.remove("loadoutPrim$i");
        data.remove("loadoutSec$i");
        data.remove("loadoutOther$i");
        data.remove("loadoutRole$i");
      }
    }

    data.remove('callsign');

    setState(() {
      numCards = 2;
    });
  }

  void tappedCard(int index) async {
    if (index == numCards - 1) {
      _showDelAllDialog();
    } else if (index == numCards - 2) {
      //go to card form empty
      List result = await Navigator.push(context, MaterialPageRoute(builder: (context) => LoadoutForm(index, isNew: true)));
      if (result.length > 0 && result[0]) {
        newLoadout(result[1], result[2]);
      }
      setState(() {});
    } else {
      // go to card form filled out
      List result = await Navigator.push(context, MaterialPageRoute(builder: (context) => LoadoutForm(index, isNew: false)));
      if (result.length > 0 && result[0]) {
        updateLoadout(result[1], result[2], index);
      }
    }
  }

  Widget _buildCarousel(BuildContext context, int carouselIndex) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(
          height: MediaQuery.of(context).size.height * .50,
          child: PageView.builder(
            // store this controller in a State to save the carousel scroll position
            itemCount: numCards,
            controller: PageController(viewportFraction: 0.8),
            itemBuilder: (BuildContext context, int itemIndex) {
              String imageAsset = "";
              switch (cardRole[itemIndex]) {
                case cardRoles.empty:
                  imageAsset = 'assets/graphics/none.png';
                  break;
                case cardRoles.newCard:
                  imageAsset = 'assets/graphics/newcard.png';
                  break;
                case cardRoles.deleteAll:
                  imageAsset = 'assets/graphics/deletecards.png';
                  break;
                case cardRoles.rifleman:
                  imageAsset = 'assets/graphics/rifleman.png';
                  break;
                case cardRoles.specialist:
                  imageAsset = 'assets/graphics/specialist.png';
                  break;
                case cardRoles.medic:
                  imageAsset = 'assets/graphics/medic.png';
                  break;
                case cardRoles.sniper:
                  imageAsset = 'assets/graphics/sniper.png';
                  break;
              }
              return _buildCarouselItem(context, carouselIndex, itemIndex, imageAsset, cardText[itemIndex]);
            },
          ),
        )
      ],
    );
  }

  Widget _buildCarouselItem(BuildContext context, int carouselIndex, int itemIndex, String imageAsset, String dispText) {
    return Scaffold (
      backgroundColor: const Color(0xff3b3838),
      body: GestureDetector (
        onTap: () { tappedCard(itemIndex); },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Container(
            width: MediaQuery.of(context).size.width * .70,
            decoration: BoxDecoration(
              color: Color(0xd06a6a6a),
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
            ),
            child: Column (
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded (
                  flex: 66,
                  child: Padding(
                    padding: EdgeInsets.all(50.0),
                    child: Image.asset(imageAsset),
                  )
                ),
                Expanded (
                  flex: 33,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        dispText,
                        style: Theme.of(context).textTheme.display1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff3b3838),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            Expanded(
              flex: 17,
              child: Image.asset(
                'assets/graphics/whitelogonobg.png',
                width: MediaQuery.of(context).size.width * 0.9,
              ),
            ),
            Expanded(
              flex: 83,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    callsign,
                    style: Theme.of(context).textTheme.headline,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  _buildCarousel(context, 0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
