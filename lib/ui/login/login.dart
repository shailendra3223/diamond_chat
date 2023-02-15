import 'package:diamond_chat/game_page/game_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:platform_device_id/platform_device_id.dart';
import '../../controller/login_controller.dart';
import '../chat/home_screen.dart';

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
  final auth = LocalAuthentication();

  @override
  void initState() {
    // _checkBiometric();
    // _getAvailableBiometric();
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
            child: Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.all(20.0),
                   // child: Image.asset("assets/img/logo.jpg"),
                    child: Text('Log In ',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 25.0),),

                  ),
                  Image.asset("assets/img/user.png",
                  height: 140,
                  width: 140,),
                  Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: TextFormField(
                                validator: (input) {
                                  if (input!.isEmpty) {
                                    return 'Please enter an email';
                                  }
                                  return null;
                                },
                                onSaved: (input) => _email = input,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(30.0),
                                      ),
                                    ),
                                    labelText: 'email'),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20,right: 20),
                              child: TextFormField(
                                validator: (input) {
                                  if (input!.isEmpty) {
                                    return 'Please enter a password';
                                  }
                                  return null;
                                },
                                onSaved: (input) => _password = input,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(30.0),
                                      ),
                                    ),
                                    labelText: 'Password'),
                                obscureText: true,
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
                              onPressed: _submit,
                              child:const Text("Login",style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold,color: Colors.white),),
                            ),
                            const SizedBox(
                              height: 5,
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
