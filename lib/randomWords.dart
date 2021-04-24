import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:hello_me/myGrabbing.dart';
import 'package:hello_me/savedNotifier.dart';
import 'package:hello_me/userProfile.dart';
import 'package:provider/provider.dart';
import 'package:snapping_sheet/snapping_sheet.dart';

import 'userProfile.dart';
import 'authNotifier.dart';

class RandomWords extends StatefulWidget {
  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final suggestions = <WordPair>[];
  final SnappingSheetController snapController = SnappingSheetController();
  double blur = 0.0;

  @override
  Widget build(BuildContext context) {
    final _snappingPositions = [
      SnappingPosition.factor(
        positionFactor: 0.0,
        snappingCurve: Curves.elasticOut,
        snappingDuration: Duration(milliseconds: 750),
        grabbingContentOffset: GrabbingContentOffset.top,
      ),
      SnappingPosition.factor(
        positionFactor: 0.2,
        snappingCurve: Curves.elasticOut,
        snappingDuration: Duration(milliseconds: 750),
        grabbingContentOffset: GrabbingContentOffset.top,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Startup Name Generator'),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () => Navigator.pushNamed(context, '/saved'),
          ),
          Consumer<AuthNotifier>(builder: (context, auth, _) {
            return Visibility(
              visible: !auth.isAuthenticated,
              child: IconButton(
                icon: Icon(Icons.login),
                onPressed: () => Navigator.pushNamed(context, '/login'),
              ),
              replacement: IconButton(
                icon: Icon(Icons.exit_to_app),
                onPressed: () {
                  snapController.snapToPosition(_snappingPositions[0]);
                  auth.signOut();
                },
              ),
            );
          })
        ],
      ),
      body: Consumer<AuthNotifier>(
        builder: (context, auth, _) {
          return SnappingSheet(
            // lockOverflowDrag: true,
            controller: snapController,
            child: Stack(
              fit: StackFit.expand,
              children: [
                _buildSuggestions(),
                BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: blur,
                    sigmaY: blur,
                  ),
                  child: Container(
                    color: blur > 0 ? Colors.transparent : null,
                  ),
                )
              ],
            ),

            initialSnappingPosition: _snappingPositions[0],
            onSheetMoved: (position) => setState(() {
              double lim = MediaQuery.of(context).size.height * 0.07;
              blur = snapController.currentPosition < lim ? 0 : 8.0;
            }),

            grabbingHeight: auth.isAuthenticated ? (MediaQuery.of(context).size.height * 0.08) : 0,
            grabbing: auth.isAuthenticated
                ? GestureDetector(
                    child: MyGrabbing("Welcome back, " + auth.email),
                    onTap: () {
                      int pos =
                          snapController.currentSnappingPosition == _snappingPositions[0] ? 1 : 0;
                      snapController.snapToPosition(_snappingPositions[pos]);
                    },
                  )
                : SizedBox(),
            snappingPositions: _snappingPositions,
            sheetBelow: SnappingSheetContent(
              child: UserProfile(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSuggestions() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemBuilder: (BuildContext _context, int i) {
        if (i.isOdd) {
          return Divider();
        }

        final int index = i ~/ 2;
        if (index >= suggestions.length) {
          suggestions.addAll(generateWordPairs().take(10));
        }
        return _buildRow(suggestions[index]);
      },
    );
  }

  Widget _buildRow(WordPair pair) {
    return Consumer<SavedNotifier>(builder: (context, saved, _) {
      final alreadySaved = saved.contains(pair);
      return ListTile(
        title: Text(
          pair.asPascalCase,
          style: const TextStyle(fontSize: 18),
        ),
        trailing: Icon(
          alreadySaved ? Icons.favorite : Icons.favorite_border,
          color: alreadySaved ? Colors.red : null,
        ),
        onTap: () {
          if (alreadySaved) {
            saved.remove(pair);
          } else {
            saved.add(pair);
          }
        },
      );
    });
  }
}
