import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:video_playerio/ui/main/main_view_model.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class MainView extends StatefulWidget {
  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  final GlobalKey<ScaffoldState> _key = GlobalKey(); // Create a key

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MainViewModel>.reactive(
        builder: (context, model, child) {
          model.init();
          return SafeArea(
            child: Scaffold(
              key: _key,
              drawer: Drawer(
                // Add a ListView to the drawer. This ensures the user can scroll
                // through the options in the drawer if there isn't enough vertical
                // space to fit everything.
                child: ListView(
                  // Important: Remove any padding from the ListView.
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    ListTile(
                      title: Text('Logout'),
                      onTap: () => model.onLogut(),
                    ),
                    ListTile(
                      title: Text('Profile'),
                      onTap: () => model.onViewProfile(),
                    ),
                    ListTile(
                      title: Text('Switch Theme'),
                      onTap: () => model.onSwitchTheme(context),
                    ),
                  ],
                ),
              ),
              body: Stack(children: [
                Container(
                  child: Center(
                    child: model.videoPlayerController != null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                height: 250,
                                child: model.videoPlayerController != null
                                    ? Chewie(
                                        controller: model.chewiController,
                                      )
                                    : null,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                    child: Text('<'),
                                    onPressed: () =>
                                        model.prevVideo(model.indeX, context),
                                    style: ElevatedButton.styleFrom(
                                      shape: CircleBorder(),
                                    ),
                                  ),
                                  ElevatedButton(
                                    child: Text('Download'),
                                    onPressed: () => model.pickFile(context),
                                  ),
                                  ElevatedButton(
                                    child: Text('>'),
                                    onPressed: () =>
                                        model.nextVideo(model.indeX, context),
                                    style: ElevatedButton.styleFrom(
                                      shape: CircleBorder(),
                                    ),
                                  ),
                                ],
                              ),
                              model.videoPlayerController != null
                                  ? Expanded(
                                      child: Container(
                                        child: ListView.separated(
                                            itemBuilder: (context, index) {
                                              return ListTile(
                                                title: Text(model
                                                    .files[index].path
                                                    .split('/')
                                                    .last),
                                                onTap: () => model.loadVideo(
                                                    index: index),
                                              );
                                            },
                                            separatorBuilder: (context, index) {
                                              return Divider();
                                            },
                                            itemCount: model.files.length),
                                      ),
                                    )
                                  : Container(),
                            ],
                          )
                        : ElevatedButton(
                            child: Text('Download'),
                            onPressed: () => model.pickFile(context),
                          ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: GestureDetector(
                    onTap: () => {_key.currentState!.openDrawer()},
                    child: Icon(
                      Icons.menu,
                      size: 25,
                    ),
                  ),
                ),
              ]),
            ),
          );
        },
        viewModelBuilder: () => MainViewModel());
  }
}
