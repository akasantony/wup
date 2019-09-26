import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}


class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchFieldController;

  void _isTypingSearch(String searchText) {

  }

  Widget _searchPageBuilder() {

    var testData = {
      '919538770672': {
        'name': 'Shakira',
        'lastchat': 'Howdy Brother',
        'profilepicurl': 'https://m.media-amazon.com/images/M/MV5BMTc5MjgyMzk4NF5BMl5BanBnXkFtZTcwODk2OTM4Mg@@._V1_UY1200_CR105,0,630,1200_AL_.jpg',
        'latchattimestamp': '7:00 pm'
      },
      '919538770673': {
        'name': 'Freddy Mercury',
        'lastchat': 'Howdy Brother',
        'profilepicurl': 'https://m.media-amazon.com/images/M/MV5BMTc5MjgyMzk4NF5BMl5BanBnXkFtZTcwODk2OTM4Mg@@._V1_UY1200_CR105,0,630,1200_AL_.jpg',
        'latchattimestamp': '7:00 pm'
      },
      '919538770674': {
        'name': 'Brad Pitt',
        'lastchat': 'Howdy Brother',
        'profilepicurl': 'https://m.media-amazon.com/images/M/MV5BMTc5MjgyMzk4NF5BMl5BanBnXkFtZTcwODk2OTM4Mg@@._V1_UY1200_CR105,0,630,1200_AL_.jpg',
        'latchattimestamp': '7:00 pm'
      },
      '919538770675': {
        'name': 'Jesus Pereira',
        'lastchat': 'Howdy Brother',
        'profilepicurl': 'https://m.media-amazon.com/images/M/MV5BMTc5MjgyMzk4NF5BMl5BanBnXkFtZTcwODk2OTM4Mg@@._V1_UY1200_CR105,0,630,1200_AL_.jpg',
        'latchattimestamp': '7:00 pm'
      },
      '919538770676': {
        'name': 'Jesus Pereira',
        'lastchat': 'Howdy Brother',
        'profilepicurl': 'https://m.media-amazon.com/images/M/MV5BMTc5MjgyMzk4NF5BMl5BanBnXkFtZTcwODk2OTM4Mg@@._V1_UY1200_CR105,0,630,1200_AL_.jpg',
        'latchattimestamp': '7:00 pm'
      },
      '919538770677': {
        'name': 'Jesus Pereira',
        'lastchat': 'Howdy Brother',
        'profilepicurl': 'https://m.media-amazon.com/images/M/MV5BMTc5MjgyMzk4NF5BMl5BanBnXkFtZTcwODk2OTM4Mg@@._V1_UY1200_CR105,0,630,1200_AL_.jpg',
        'latchattimestamp': '7:00 pm'
      },
      '919538770678': {
        'name': 'Jesus Pereira',
        'lastchat': 'Howdy Brother',
        'profilepicurl': 'https://m.media-amazon.com/images/M/MV5BMTc5MjgyMzk4NF5BMl5BanBnXkFtZTcwODk2OTM4Mg@@._V1_UY1200_CR105,0,630,1200_AL_.jpg',
        'latchattimestamp': '7:00 pm'
      },
      '919538770679': {
        'name': 'Jesus Pereira',
        'lastchat': 'Howdy Brother',
        'profilepicurl': 'https://m.media-amazon.com/images/M/MV5BMTc5MjgyMzk4NF5BMl5BanBnXkFtZTcwODk2OTM4Mg@@._V1_UY1200_CR105,0,630,1200_AL_.jpg',
        'latchattimestamp': '7:00 pm'
      },
      '9195387706710': {
        'name': 'Jesus Pereira',
        'lastchat': 'Howdy Brother',
        'profilepicurl': 'https://m.media-amazon.com/images/M/MV5BMTc5MjgyMzk4NF5BMl5BanBnXkFtZTcwODk2OTM4Mg@@._V1_UY1200_CR105,0,630,1200_AL_.jpg',
        'latchattimestamp': '7:00 pm'
      },
      '9195387706711': {
        'name': 'Jesus Pereira',
        'lastchat': 'Howdy Brother',
        'profilepicurl': 'https://m.media-amazon.com/images/M/MV5BMTc5MjgyMzk4NF5BMl5BanBnXkFtZTcwODk2OTM4Mg@@._V1_UY1200_CR105,0,630,1200_AL_.jpg',
        'latchattimestamp': '7:00 pm'
      },
    };

    return Container(
      color: Colors.deepPurple,
      child: Column(
        children: <Widget>[
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Sugested Users", style: TextStyle(color: Colors.white, fontSize: 30),),
                Container(
                  height: 100,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,

                    itemCount: testData.length,
                    itemBuilder: (BuildContext context, int index) {
                      String key = testData.keys.elementAt(index);
                      print(key);
                      return Container(
//                  height: 100,s
                        child: Row(
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(width: 2, color: Colors.redAccent)
                              ),
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(testData[key]['profilepicurl']),
                              ),
                            ),
                            Column(
                              children: <Widget>[
                                Container(
                                  child: Text(testData[key]['name'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                                  margin: const EdgeInsets.only(left: 20, top: 20),
                                ),
                                Container(
                                  child: Text(testData[key]['lastchat'], style: TextStyle(fontSize: 10),),
                                  margin: const EdgeInsets.only(left: 10, top: 20),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) => const Divider(),
                  ),
                )
              ],
            ),
          ),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Trending Flips", style: TextStyle(color: Colors.white, fontSize: 30),),
                Container(
                  height: 200,
                  child: ListView(
                    // This next line does the trick.
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      Container(
                        width: 160.0,
                        color: Colors.red,
                      ),
                      Container(
                        width: 160.0,
                        color: Colors.blue,
                      ),
                      Container(
                        width: 160.0,
                        color: Colors.green,
                      ),
                      Container(
                        width: 160.0,
                        color: Colors.yellow,
                      ),
                      Container(
                        width: 160.0,
                        color: Colors.orange,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Trending #HashTags", style: TextStyle(color: Colors.white, fontSize: 30),),
                Container(
                  height: 200,
                  child: ListView(
                    // This next line does the trick.
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      Container(
                        width: 160.0,
                        color: Colors.red,
                      ),
                      Container(
                        width: 160.0,
                        color: Colors.blue,
                      ),
                      Container(
                        width: 160.0,
                        color: Colors.green,
                      ),
                      Container(
                        width: 160.0,
                        color: Colors.yellow,
                      ),
                      Container(
                        width: 160.0,
                        color: Colors.orange,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _appBarBuilder() {
    return AppBar(
      backgroundColor: Colors.white,
      title: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(top: 5),
              child: TextField(
                controller: _searchFieldController,
                onChanged: _isTypingSearch,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    suffixIcon: Icon(Icons.search, size: 20, color: Colors.grey,)
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
//        resizeToAvoidBottomPadding: false,
        appBar: _appBarBuilder(),
        body: _searchPageBuilder(),
    );
  }
}
