import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stacked/stacked.dart';
import 'package:video_playerio/ui/registration/registration_view_model.dart';
import 'package:date_time_picker/date_time_picker.dart';

class RegistrationView extends StatefulWidget {
  const RegistrationView({Key? key}) : super(key: key);

  @override
  _RegistrationViewState createState() => _RegistrationViewState();
}

class _RegistrationViewState extends State<RegistrationView>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final nameFieldController = TextEditingController();
  final emailFieldController = TextEditingController();
  final dateFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RegistrationViewModel>.reactive(
        builder: (context, model, cild) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(13.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text('Create Account',
                          style: TextStyle(
                            fontSize: 50,
                          )),
                      SizedBox(
                        height: 80,
                      ),
                      InkWell(
                        onTap: () =>
                            model.pickImage(ImageSource.gallery, context),
                        child: CircleAvatar(
                          backgroundImage: model.isSelected
                              ? FileImage(model.imageFile)
                              : null,
                          maxRadius: 90,
                          child: model.isSelected ? null : Text('Select a Dp'),
                        ),
                      ),
                      SizedBox(
                        height: 80,
                      ),
                      Form(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: TextFormField(
                                keyboardType: TextInputType.name,
                                controller: nameFieldController,
                                validator: (value) {
                                  return model.nameValidate(value);
                                },
                                decoration: InputDecoration(
                                  labelText: 'Name',
                                  border: OutlineInputBorder(),
                                  suffixIcon: Icon(Icons.notes),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                controller: emailFieldController,
                                validator: (value) =>
                                    model.emailValidate(value),
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                  border: OutlineInputBorder(),
                                  suffixIcon: Icon(Icons.email),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: DateTimePicker(
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                                decoration: InputDecoration(
                                  labelText: 'DOB',
                                  border: OutlineInputBorder(),
                                  suffixIcon: Icon(Icons.date_range),
                                ),
                                dateLabelText: 'Date',
                                onChanged: (val) => print(val),
                                controller: dateFieldController,
                                validator: (val) {
                                  print(val);
                                  return null;
                                },
                                onSaved: (val) => print(val),
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate() &&
                                    model.isSelected) {
                                  //! form valid
                                  model.onSubmit(
                                      context: context,
                                      name: nameFieldController.text,
                                      email: emailFieldController.text,
                                      dob: dateFieldController.text);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content:
                                              Text('Fill up everything !')));
                                }
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Color(0xff49DC87)),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15))),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 30),
                                child: Text(
                                  'Register',
                                  style: TextStyle(fontSize: 25),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        viewModelBuilder: () => RegistrationViewModel());
  }
}
