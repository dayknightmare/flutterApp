import 'package:flutter/material.dart';

class EmojisData{
  final double media;
  final List emojis;

  List emojis1 = [];
  List emojis2 = [];
  List emojis3 = [];
  List emojis4 = [];
  List emojis5 = [];
  List emojis6 = [];
  List emojis7 = [];
  List emojis8 = [];

  EmojisData(this.media, this.emojis){
    for (var i = 0; i < this.emojis.length; i++) {
      if (this.emojis[i]['group'] == "1") {
        emojis1.add(this.emojis[i]);
      }
      if (this.emojis[i]['group'] == "2") {
        emojis2.add(this.emojis[i]);
      }
      if (this.emojis[i]['group'] == "3") {
        emojis3.add(this.emojis[i]);
      }
      if (this.emojis[i]['group'] == "4") {
        emojis4.add(this.emojis[i]);
      }
      if (this.emojis[i]['group'] == "5") {
        emojis5.add(this.emojis[i]);
      }
      if (this.emojis[i]['group'] == "6") {
        emojis6.add(this.emojis[i]);
      }
      if (this.emojis[i]['group'] == "7") {
        emojis7.add(this.emojis[i]);
      }
      if (this.emojis[i]['group'] == "8") {
        emojis8.add(this.emojis[i]);
      }
    }
  }

  void addEmoji(i){}

  Widget emoGro1() {
    return Container(
      height: 200,
      width: media,
      child: CustomScrollView(
        semanticChildCount: emojis1.length,
        slivers: <Widget>[
          SliverGrid(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 50.0,
              mainAxisSpacing: 4.0,
              crossAxisSpacing: 4.0,
              childAspectRatio: 1.0,
            ),
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return MaterialButton(
                  child: Text(
                    emojis1[index]["emoji"],
                    style: TextStyle(fontFamily: "Emojis Poppins"),
                  ),
                  // child: Icon(IconData(0xe801, fontFamily: "emojis")),
                  onPressed: () {
                    addEmoji(emojis1[index]["emoji"]);
                  },
                );
              },
              childCount: emojis1.length,
            ),
          ),
        ],
      ),
    );
  }

  Widget emoGro2() {
    return Container(
      height: 200,
      width: media,
      child: CustomScrollView(
        semanticChildCount: emojis2.length,
        slivers: <Widget>[
          SliverGrid(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 50.0,
              mainAxisSpacing: 4.0,
              crossAxisSpacing: 4.0,
              childAspectRatio: 1.0,
            ),
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return MaterialButton(
                  child: Text(
                    emojis2[index]["emoji"],
                    style: TextStyle(fontFamily: "Emojis Poppins"),
                  ),
                  // child: Icon(IconData(0xe801, fontFamily: "emojis")),
                  onPressed: () {
                    addEmoji(emojis2[index]["emoji"]);
                  },
                );
              },
              childCount: emojis2.length,
            ),
          ),
        ],
      ),
    );
  }

  Widget emoGro3() {
    return Container(
      height: 200,
      width: media,
      child: CustomScrollView(
        semanticChildCount: emojis3.length,
        slivers: <Widget>[
          SliverGrid(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 50.0,
              mainAxisSpacing: 4.0,
              crossAxisSpacing: 4.0,
              childAspectRatio: 1.0,
            ),
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return MaterialButton(
                  child: Text(
                    emojis3[index]["emoji"],
                    style: TextStyle(fontFamily: "Emojis Poppins"),
                  ),
                  // child: Icon(IconData(0xe801, fontFamily: "emojis")),
                  onPressed: () {
                    addEmoji(emojis3[index]["emoji"]);
                  },
                );
              },
              childCount: emojis3.length,
            ),
          ),
        ],
      ),
    );
  }

  Widget emoGro4() {
    return Container(
      height: 200,
      width: media,
      child: CustomScrollView(
        semanticChildCount: emojis4.length,
        slivers: <Widget>[
          SliverGrid(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 50.0,
              mainAxisSpacing: 4.0,
              crossAxisSpacing: 4.0,
              childAspectRatio: 1.0,
            ),
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return MaterialButton(
                  child: Text(
                    emojis4[index]["emoji"],
                    style: TextStyle(fontFamily: "Emojis Poppins"),
                  ),
                  // child: Icon(IconData(0xe801, fontFamily: "emojis")),
                  onPressed: () {
                    addEmoji(emojis4[index]["emoji"]);
                  },
                );
              },
              childCount: emojis4.length,
            ),
          ),
        ],
      ),
    );
  }

  Widget emoGro5() {
    return Container(
      height: 200,
      width: media,
      child: CustomScrollView(
        semanticChildCount: emojis5.length,
        slivers: <Widget>[
          SliverGrid(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 50.0,
              mainAxisSpacing: 4.0,
              crossAxisSpacing: 4.0,
              childAspectRatio: 1.0,
            ),
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return MaterialButton(
                  child: Text(
                    emojis5[index]["emoji"],
                    style: TextStyle(fontFamily: "Emojis Poppins"),
                  ),
                  // child: Icon(IconData(0xe801, fontFamily: "emojis")),
                  onPressed: () {
                    addEmoji(emojis5[index]["emoji"]);
                  },
                );
              },
              childCount: emojis5.length,
            ),
          ),
        ],
      ),
    );
  }

  Widget emoGro6() {
    return Container(
      height: 200,
      width: media,
      child: CustomScrollView(
        semanticChildCount: emojis6.length,
        slivers: <Widget>[
          SliverGrid(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 50.0,
              mainAxisSpacing: 4.0,
              crossAxisSpacing: 4.0,
              childAspectRatio: 1.0,
            ),
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return MaterialButton(
                  child: Text(
                    emojis6[index]["emoji"],
                    style: TextStyle(fontFamily: "Emojis Poppins"),
                  ),
                  // child: Icon(IconData(0xe801, fontFamily: "emojis")),
                  onPressed: () {
                    addEmoji(emojis6[index]["emoji"]);
                  },
                );
              },
              childCount: emojis6.length,
            ),
          ),
        ],
      ),
    );
  }

  Widget emoGro7() {
    return Container(
      height: 200,
      width: media,
      child: CustomScrollView(
        semanticChildCount: emojis7.length,
        slivers: <Widget>[
          SliverGrid(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 50.0,
              mainAxisSpacing: 4.0,
              crossAxisSpacing: 4.0,
              childAspectRatio: 1.0,
            ),
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return MaterialButton(
                  child: Text(
                    emojis7[index]["emoji"],
                    style: TextStyle(fontFamily: "Emojis Poppins"),
                  ),
                  // child: Icon(IconData(0xe801, fontFamily: "emojis")),
                  onPressed: () {
                    addEmoji(emojis7[index]["emoji"]);
                  },
                );
              },
              childCount: emojis7.length,
            ),
          ),
        ],
      ),
    );
  }

  Widget emoGro8() {
    return Container(
      height: 200,
      width: media,
      child: CustomScrollView(
        semanticChildCount: emojis8.length,
        slivers: <Widget>[
          SliverGrid(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 50.0,
              mainAxisSpacing: 4.0,
              crossAxisSpacing: 4.0,
              childAspectRatio: 1.0,
            ),
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return MaterialButton(
                  child: Text(
                    emojis8[index]["emoji"],
                    style: TextStyle(fontFamily: "Emojis Poppins"),
                  ),
                  // child: Icon(IconData(0xe801, fontFamily: "emojis")),
                  onPressed: () {
                    addEmoji(emojis8[index]["emoji"]);
                  },
                );
              },
              childCount: emojis8.length,
            ),
          ),
        ],
      ),
    );
  }
}
