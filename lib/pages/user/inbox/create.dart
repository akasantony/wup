import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:wup/utils/constants/flips.dart';
import 'package:wup/utils/constants/media.dart';
import 'dart:core';

import 'package:wup/utils/http/search.dart';

class CreateChatDialogue extends StatefulWidget {

  final Function onPost;

  CreateChatDialogue({Key key, this.onPost}) : super(key: key);

  @override
  _CreateChatDialogueState createState() => new _CreateChatDialogueState();
}

class _CreateChatDialogueState extends State<CreateChatDialogue>{
  VisibilityStatus _visibilityStatus = VisibilityStatus.public;
  TextEditingController _descriptionFieldController;
  GetFollowers _getFollowers = GetFollowers();

  @override
  void initState() {
    _descriptionFieldController = TextEditingController();
    super.initState();
  }

  Future<List> _suggestionBoxController(String text) async{
    List<String> _words = text.split((" "));
    var _lastWord = _words[_words.length-1];
    if(_lastWord.length != 0 && _lastWord.startsWith("@")){
      var responseData = await _getFollowers.details(pattern: _words[_words.length-1], entities: ['username']);
      return responseData['followers'];
    }
    else if(_lastWord.length != 0 && _lastWord.startsWith("#")){
      var responseData = await _getFollowers.details(pattern: _words[_words.length-1], entities: ['hashtags']);
      return responseData['followers'];
    }
  }

  @override
  Widget build(BuildContext context){
    return SimpleDialog(
      title: Text("Chat"),
      children: <Widget>[
        Container(
          child: TypeAheadField(
            textFieldConfiguration: TextFieldConfiguration(
                controller: _descriptionFieldController,
                decoration: InputDecoration(
                  hintText: 'Username(s),',
                )
            ),
            suggestionsCallback: (pattern) async {
              return await _suggestionBoxController(pattern);
            },
            itemBuilder: (context, suggestion) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage("https://media.vanityfair.com/photos/5c0ef15ae2641b48c86501e9/master/pass/Megan-Fox-MeToo-Story%20(1).jpg"),
                ),
                title: Text(suggestion['data']),
              );
            },

            onSuggestionSelected: (suggestion) {
              _descriptionFieldController.text = suggestion['data'];
            },
          ),
        ),
        Container(
          child: Theme(
              data: ThemeData(
                  unselectedWidgetColor: Colors.grey
              ),
              child: ExpandablePanel(
                header: Text("Visibility", style: TextStyle(fontWeight: FontWeight.bold),),
                headerAlignment: ExpandablePanelHeaderAlignment.center,
                hasIcon: true,
                expanded: Row(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Text("Public"),
                        Radio(
                          value: VisibilityStatus.public,
                          groupValue: _visibilityStatus,
                          onChanged: (VisibilityStatus status) {
                            setState(() {
                              _visibilityStatus = status;
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(width: 30,),
                    Column(
                      children: <Widget>[
                        Text("Followers"),
                        Radio(
                          value: VisibilityStatus.followers,
                          groupValue: _visibilityStatus,
                          onChanged: (VisibilityStatus status) {
                            print(_visibilityStatus);
                            setState(() {
                              _visibilityStatus = status;
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(width: 30,),
                    Column(
                      children: <Widget>[
                        Text("Mutual"),
                        Radio(
                          value: VisibilityStatus.mutual,
                          groupValue: _visibilityStatus,
                          onChanged: (VisibilityStatus status) {
                            print(_visibilityStatus);
                            setState(() {
                              _visibilityStatus = status;
                            });
                          },
                        ),
                      ],
                    )
                  ],
                ),
              )
          ),
        ),
        Container(
          child: RaisedButton(
            color: Colors.blue,
            child: Text("Send", style: TextStyle(color: Colors.white),),
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}