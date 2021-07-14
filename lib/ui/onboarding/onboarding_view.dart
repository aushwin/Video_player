import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:video_playerio/ui/onboarding/onboarding_view_model.dart';

class OnBoardingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<OnBoardingViewModel>.nonReactive(
        builder: (context, model, child) => Scaffold(
            backgroundColor: Colors.white,
            body: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 30),
                  Container(
                      color: Colors.white, // debugging
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 300,
                          ),
                          Text(
                            "Welcome !",
                            style: TextStyle(fontSize: 80),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              'Video.io',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                            child: ElevatedButton(
                              onPressed: model.onLoginPressed,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 30),
                                child: Text(
                                  'Login',
                                  style: TextStyle(fontSize: 25),
                                ),
                              ),
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Color(0xff49DC87)),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15))),
                              ),
                            ),
                          ),
                        ],
                      )),
                  InkWell(
                    onTap: () => model.onRegisterPressed(),
                    child: Row(
                      children: [
                        Text('First Time? '),
                        Text(
                          'Register',
                          style: TextStyle(color: Color(0xff1E88E5)),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )),
        viewModelBuilder: () => OnBoardingViewModel());
  }
}
