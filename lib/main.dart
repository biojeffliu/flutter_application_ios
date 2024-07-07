import 'package:flutter/material.dart';
import 'package:swipe_cards/draggable_card.dart';
import 'package:provider/provider.dart';
import 'package:swipe_cards/swipe_cards.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BottomTabBar(),
    );
  }
}

class SwipeCardExample extends StatefulWidget {
  @override
  _SwipeCardExampleState createState() => _SwipeCardExampleState();
}

class _SwipeCardExampleState extends State<SwipeCardExample> {
  List<SwipeItem> _swipeItems = [];
  late MatchEngine _matchEngine;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final List<String> _artists = ["Red", "Blue", "Green", "Yellow", "Orange"];
  final List<Color> _songColors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.orange
  ];
  @override
  void initState() {
    super.initState();
    for (int i = 0; i < _artists.length; i++) {
      _swipeItems.add(SwipeItem(
        content: Artist(name: _artists[i], songColor: _songColors[i]),
        likeAction: () {
          final artist = Artist(name: _artists[i], songColor: _songColors[i]);
          Provider.of<LikedArtistsState>(context, listen: false).addArtist(artist);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Liked ${_artists[i]}"),
            duration: Duration(milliseconds: 500),
          ));
        },
        nopeAction: () {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Nope ${_artists[i]}"),
            duration: Duration(milliseconds: 500),
          ));
        },
        superlikeAction: () {
          final artist = Artist(name: _artists[i], songColor: _songColors[i]);
          Provider.of<LikedArtistsState>(context, listen: false).addArtist(artist);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("SuperLiked ${_artists[i]}"),
            duration: Duration(milliseconds: 500),
          ));
        },
        onSlideUpdate: (SlideRegion? region) async {
          print("Region $region");
        },
      ));
    }
    _matchEngine = MatchEngine(swipeItems: _swipeItems);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Swipe Cards Example'),
      ),
      body: Column(
        children: [
          Container(
            height: 550,
            child: SwipeCards(
              matchEngine: _matchEngine,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  alignment: Alignment.center,
                  color: _swipeItems[index].content.songColor,
                  child: Text(
                    _swipeItems[index].content.name,
                    style: TextStyle(fontSize: 100),
                  ),
                );
              },
              onStackFinished: () {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("Stack Finished"),
                  duration: Duration(milliseconds: 500),
                ));
              },
              itemChanged: (SwipeItem item, int index) {
                print("Item: ${item.content.name}, Index: $index");
              },
              upSwipeAllowed: true,
              fillSpace: true,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  _matchEngine.currentItem?.nope();
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text('Nope'),
              ),
              ElevatedButton(
                onPressed: () {
                  _matchEngine.currentItem?.superLike();
                  
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text('SuperLike'),
              ),
              ElevatedButton(
                onPressed: () {
                  _matchEngine.currentItem?.like();
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text('Like'),
              ),
            ],
          ),
        ],
      )
    );
  }
}
class BottomTabBar extends StatelessWidget {
  const BottomTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            isScrollable: false,
            tabs: <Widget>[
                Tab(
                  icon: Icon(Icons.swipe),
                ),
                Tab(
                  icon: Icon(Icons.thumbs_up_down),
                ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            Center(
              child: SwipeCardExample(),
            ),
            Center(

            ),
          ],
        ),
      ),
    );
  }
}

class LikedArtistsState extends ChangeNotifier {
  final List<Artist> _likedArtists = [];

  List<Artist> get likedArtists => _likedArtists;

  void addArtist(Artist artist) {
    _likedArtists.add(artist);
    notifyListeners();
  }
}

// class LikedArtistsTab extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     r
//   }
// }


class Artist {
  final String name;
  final Color songColor;

  Artist({required this.name, required this.songColor});
}
