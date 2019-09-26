import 'package:flutter/material.dart';
import 'package:wup/pages/user/inbox/create.dart';

class InboxPage extends StatefulWidget {


  @override
  State<StatefulWidget> createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> {
  TextEditingController _searchFieldController;


  @override
  void initState() {

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _isTypingSearch(String searchText) {

  }

  void _postHandler() {

  }

  void _createChat() {
    print("Chat Pressed");
    showDialog(
      context: context,
      builder: (_) => CreateChatDialogue(onPost: _postHandler),
    );
  }

  Widget _bodyBuilder() {
    return Flex(
      direction: Axis.vertical,
      children: <Widget>[
        Expanded(
          child: Stack(
            children: <Widget>[
              Container(
//                height: 200,
                child: ListView.separated(
                  padding: const EdgeInsets.all(8),
                  itemCount: testData.length,
                  itemBuilder: (BuildContext context, int index) {
                    String key = testData.keys.elementAt(index);
                    print(key);
                    return Container(
//                  height: 100,
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.all(2),
                            height: 60,
                            width: 60,
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
              ),
              Container(
                padding: const EdgeInsets.all(30),
                alignment: Alignment.bottomRight,
                child: FloatingActionButton(
                  child: Icon(Icons.chat_bubble),
                  onPressed: _createChat,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

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
    Widget inboxPageContainer = Container(
      child: _bodyBuilder(),
    );


    return Scaffold(
        backgroundColor: Colors.white,
//        resizeToAvoidBottomPadding: false,
        appBar: _appBarBuilder(),
        body: inboxPageContainer
    );
  }
}


