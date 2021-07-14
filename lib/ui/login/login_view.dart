import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:video_playerio/ui/login/login_view_model.dart';

class LoginView extends StatelessWidget {
  LoginView({this.newUser});
  final newUser;
  final _formKey = GlobalKey<FormState>();
  final fieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginViewModel>.reactive(
        builder: (context, model, child) {
          model.isNewUser = this.newUser;
          return Scaffold(
            backgroundColor: Colors.white,
            body: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.isNewUser ? 'Nice to See you !' : 'Welcome Back',
                    style: TextStyle(fontSize: 50),
                  ), //make this dynamic
                  SizedBox(
                    height: 30,
                  ),
                  Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: fieldController,
                      validator: (value) {
                        log('$value');
                        return model.formValidation(value);
                      },
                      decoration: InputDecoration(
                        labelText: 'Mobile Number',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.phone),
                      ),
                      maxLength: 10,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        //form valid
                        model.onSubmit(context, fieldController);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Mobile Number not Valid')));
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Color(0xff49DC87)),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15))),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 30),
                      child: Text(
                        'Login',
                        style: TextStyle(fontSize: 25),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
        viewModelBuilder: () => LoginViewModel());
  }
}
