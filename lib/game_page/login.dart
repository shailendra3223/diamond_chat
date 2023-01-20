import 'package:edge_alert/edge_alert.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wc_form_validators/wc_form_validators.dart';

import '../chat/chat.dart';
import '../controller/login_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginController controller = Get.put(LoginController());
  final _formKey = GlobalKey<FormState>();
  String? _email, _password;
  String deviceid = "";

  @override
  void initState() {
    super.initState();
    getDeviceId();
  }

  void getDeviceId() async{
    String? deviceId = await PlatformDeviceId.getDeviceId;
    setState((){
      deviceid = deviceId!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery
              .of(context)
              .size
              .height,
          // margin: EdgeInsets.only(top:MediaQuery.of(context).size.height*0.2),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Image.asset("assets/img/logo.jpg"),
                ),
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    /*child: Card(
                      shadowColor: Colors.blue,
                      color: Color(0xd3e9faf8),
                      // shadowColor: Colors.white,
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0)
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: TextFormField(
                              controller: email,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(30.0),
                                    ),
                                  ),
                                  labelText: 'Email'),
                              validator: Validators.compose([
                                Validators.required('email is required'),
                                Validators.email('invalid email address')
                              ]),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20,right: 20),
                            child: TextFormField(
                              controller: password,
                              obscureText: true,

                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(30.0),
                                    ),
                                  ),
                                  labelText: 'Password'),
                              validator: Validators.compose(
                                  [Validators.required('password is required')]),
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),

                          MaterialButton(
                            color:const Color(0xff003399),
                            minWidth: MediaQuery.of(context).size.width*0.80,
                            height: 40,
                            shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                            onPressed: () {
                              Get.to(()=>ChatPage());
                            },
                            child:const Text("Login",style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold,color: Colors.white),),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    ),
                  ),*/
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            validator: (input) {
                              if (input!.isEmpty) {
                                return 'Please enter an email';
                              }
                              return null;
                            },
                            onSaved: (input) => _email = input,
                            decoration: InputDecoration(labelText: 'Email'),
                          ),
                          TextFormField(
                            validator: (input) {
                              if (input!.isEmpty) {
                                return 'Please enter a password';
                              }
                              return null;
                            },
                            onSaved: (input) => _password = input,
                            decoration: InputDecoration(labelText: 'Password'),
                            obscureText: true,
                          ),
                          MaterialButton(
                            minWidth: 100,
                            height: 50,
                            color: Colors.orange,
                            onPressed: _submit,
                            child: Text("Submit"),
                          ),
                        ],
                      ),
                    ),
                ),

                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  void _submit() {
    getDeviceId();
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      controller.login(_email!, _password!,deviceid);
      // Perform login with _email and _password
    }
  }
}
