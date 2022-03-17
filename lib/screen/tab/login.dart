import 'package:lr_bike_life/main.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/account.dart';

class Login extends StatefulWidget {

  const Login(this.callback, {Key? key}) : super(key: key);
  final Function callback;

  @override
  State<Login> createState() => LoginState();
}

class LoginState extends State<Login> {

  String identifier = "";
  String password = "";
  bool passwordVisibility = false;
  bool rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF343434),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 1,
              child: Stack(children: [
                Align(
                  alignment: const AlignmentDirectional(0, 0),
                  child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(50, 0, 50, 50), 
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                        Padding(padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 30, 20),
                          child: Container(
                            width: 100,
                            height: 100,
                            clipBehavior: Clip.antiAlias,
                            decoration: const BoxDecoration(shape: BoxShape.circle),
                            child: Image.asset('../assets/images/icon.ico', fit: BoxFit.cover)
                          )
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          Container(
                            padding: const EdgeInsets.only(bottom: 5),
                            decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white, width: 3))),
                            child: Text('La Rochelle', style: GoogleFonts.getFont('Lato', color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25))),
                          Text("Bklf photos", style: GoogleFonts.getFont('Lato', color: Colors.white.withOpacity(0.75), fontSize: 20))
                          ]
                        )]
                      )
                    ),
                    Center(
                      child: Column(
                        children: [
                          Padding(padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 30),
                          child: SizedBox(
                          width: 285,
                          height: 40,
                          child: Stack(children: [
                            Align(
                              alignment: const AlignmentDirectional(0, 0),
                              child: TextFormField(
                                onChanged: (value) => setState(() => identifier = value),
                                obscureText: false,
                                decoration: InputDecoration(
                                  hintText: 'Identifiant',
                                  hintStyle: GoogleFonts.getFont('Lato', color: Colors.white, fontSize: 18),
                                  enabledBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xFF646464), width: 2),
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(4.0), topRight: Radius.circular(4.0))
                                  )
                                ),
                                style: GoogleFonts.getFont('Lato', color: Colors.white, fontSize: 18)
                              )
                            ),
                            const Align(
                              alignment: AlignmentDirectional(0.95, 0.5),
                              child: Icon(Icons.person, color: Colors.white, size: 24)
                            )
                          ])
                        )
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                        child: SizedBox(
                         width: 285,
                          height: 40,
                          child: Stack(children: [
                            Align(
                              alignment: const AlignmentDirectional(0, 0),
                              child: TextFormField(
                                onChanged: (value) => setState(() => password = value),
                                obscureText: !passwordVisibility,
                                decoration: InputDecoration(
                                  hintText: 'Mots de passe',
                                  hintStyle: GoogleFonts.getFont('Lato', color: Colors.white, fontSize: 18),
                                  enabledBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xFF646464), width: 2),
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(4.0), topRight: Radius.circular(4.0))
                                  )
                                ),
                                style: GoogleFonts.getFont('Lato', color: Colors.white, fontSize: 18)
                              )
                            ),
                            Align(
                              alignment: const AlignmentDirectional(0.75, 0.5),
                              child: InkWell(
                                onTap: () => setState(() => passwordVisibility = !passwordVisibility),
                                child: Icon(passwordVisibility ? Icons.visibility_outlined : Icons.visibility_off_outlined, size: 22, color: const Color(0xFF606060))
                              )
                            ),
                            const Align(
                              alignment: AlignmentDirectional(0.95, 0.5),
                              child: Icon(Icons.lock_open, color: Colors.white, size: 24)
                            )]
                          )
                        )
                      ), 
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 30),
                        child: SizedBox(
                          width: 310,
                          height: 40,
                          child: Row(
                            children: [
                              Theme(
                                data: ThemeData(unselectedWidgetColor: Colors.white),
                                child: 
                              Checkbox(
                                checkColor: Colors.white,
                                activeColor: Colors.blue,
                                value: rememberMe,
                                onChanged: (value) {
                                  setState(() { 
                                    rememberMe = value!;
                                  });
                                },
                              )),
                              Text('se souvenir de moi', style: GoogleFonts.getFont('Lato', color: Colors.white, fontSize: 15))
                            ],
                          )
                        )
                      )],
                    )
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 40),
                      child: Row(
                        mainAxisSize: MainAxisSize.max, 
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(primary: const Color(0x00FFFFFF), side: const BorderSide(color: Color(0xFF646464), width: 2)),
                            onPressed: () => button(identifier, password),
                            child: Text('Connection', style: GoogleFonts.getFont( 'Lato', color: Colors.white, fontSize: 18))
                          )
                        ]
                      )
                    )
                  ]) 
                )
              ])
            )
          )
        )
      )
    );
  }

  button(String identifier, String? password){
    connection(identifier, password);
  }

  connection(String identifier, String? password) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();

    Account account = Account("", identifier, "", "");
    App.setAccount(account);

    await account.connect(password.toString());

    if (account.isConnected()) {
      if(rememberMe){
      prefs.setBool("remember", rememberMe);
      prefs.setString("username", identifier);
      prefs.setString("hashedPassword", password.toString());
    }
      App.initTags();
      App.initUsers();
      widget.callback("Home");
    } else {
      failConnectionPopUp();
    }
  }

  failConnectionPopUp(){
    showDialog(context: context, builder: (BuildContext context) =>  
      AlertDialog(
        title: Text('Echec de connection', style: GoogleFonts.getFont( 'Lato', fontWeight: FontWeight.bold, fontSize: 20)),
        content: 
          Text("Identifiant ou mots de passe incorect", style: GoogleFonts.getFont( 'Lato', fontSize: 15)),
        actions: <Widget>[
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(primary: const Color(0x00FFFFFF)),
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Fermer', style: GoogleFonts.getFont( 'Lato', color: Colors.black, fontSize: 18))
            )
          )
        ]
      )
    );
  }
}

