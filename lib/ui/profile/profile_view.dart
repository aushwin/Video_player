import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:video_playerio/ui/profile/profile_view_model.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProfileViewModel>.reactive(
        builder: (context, model, child) {
          model.init();
          return Scaffold(
            backgroundColor: Colors.green,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 100.0,
                    backgroundImage: NetworkImage(model.user.imageUrl),
                  ),
                  SizedBox(height: 40),
                  Text(
                    model.user.name,
                    style: TextStyle(
                      fontFamily: 'Pacifico',
                      fontSize: 40.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Card(
                      margin: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 25.0),
                      child: ListTile(
                        leading: Icon(
                          Icons.date_range,
                          color: Colors.teal,
                        ),
                        title: Text(
                          model.user.dob,
                          style: TextStyle(
                            color: Colors.teal.shade900,
                            fontFamily: 'Source Sans Pro',
                            fontSize: 20.0,
                          ),
                        ),
                      )),
                  Card(
                      margin: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 25.0),
                      child: ListTile(
                        leading: Icon(
                          Icons.email,
                          color: Colors.teal,
                        ),
                        title: Text(
                          model.user.email,
                          style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.teal.shade900,
                              fontFamily: 'Source Sans Pro'),
                        ),
                      ))
                ],
              ),
            ),
          );
        },
        viewModelBuilder: () => ProfileViewModel());
  }
}
