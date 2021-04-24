import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io' as io;

import 'authNotifier.dart';

class UserProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthNotifier>(
      builder: (context, auth, _) {
        if (!auth.isAuthenticated) {
          return Container();
        }

        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 16),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: CircleAvatar(
                    backgroundImage: auth.isAuthenticated && auth.avatarUrl.isNotEmpty
                        ? NetworkImage(auth.avatarUrl)
                        : null,
                    backgroundColor: Colors.grey,
                    radius: MediaQuery.of(context).size.height * 0.05,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          auth.email,
                          style: const TextStyle(fontSize: 22),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            ImagePicker().getImage(source: ImageSource.gallery).then((value) {
                              if (value == null) {
                                final snackBar = SnackBar(content: Text('No image selected'));
                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              } else {
                                auth.avatarPicture = io.File(value.path);
                              }
                            });
                          },
                          child: Text("Change avatar", style: const TextStyle(fontSize: 16)),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.teal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
