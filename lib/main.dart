import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

void main() => runApp(MyApp());

postReq(String login, String password) async {
  String url =
      'https://xcore.fhs.kz/v1/user/login';
  Map map = {
      'login': '$login',
      'password': '$password'
  };

  String s = (await apiRequest(url, map));
  return s;
}

Future<String> apiRequest(String url, Map jsonMap) async {
  HttpClient httpClient = new HttpClient();
  HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
  request.headers.add('content-type', 'application/json');
  request.headers.add('apikey', '52009ff562107968a258b8a91a2ed06cd5271f27');
  request.add(utf8.encode(json.encode(jsonMap)));

  HttpClientResponse response = await request.close();
  // todo - you should check the response.statusCode
  String reply = await response.transform(utf8.decoder).join();
  httpClient.close();
  return reply;
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    MyCustomForm obj = new MyCustomForm();
    return MaterialApp(
      title: 'Fhs.kz',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Welcome to FHS'),
        ),
        body: obj
      ),
    );
  }
}

class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<MyCustomForm> {
  // Create a global key that will uniquely identify the Form widget and allow
  // us to validate the form
  //
  // Note: This is a GlobalKey<FormState>, not a GlobalKey<MyCustomFormState>!
  final _formKey = GlobalKey<FormState>();
  String login, password;

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey we created above
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter username';
              }
              this.login = value;
              return null;
            },
          ),
          TextFormField(
            obscureText: true,
            initialValue: 'Wd0Gb41fla',
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter password';
              }
              this.password = value;
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 5),
            child: RaisedButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  postReq(login, password).then((jsonResponse) {
                    var parsedResponse = json.decode(jsonResponse);
                    var statusmsg = parsedResponse['statusmsg'].toString();
                    if (statusmsg == 'ok') {
                      Scaffold.of(context)
                          .showSnackBar(SnackBar(content: Text('You are logged in')));
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SecondRoute()),
                      );
                    } else {
                      Scaffold.of(context)
                          .showSnackBar(SnackBar(content: Text(statusmsg)));
                    }
                  });
                }
              },
              child: Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}


class SecondRoute extends StatelessWidget {

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    print(path);
    return File('$path/data/control.js');
  }

  Future<File> writeCounter(int counter) async {
    final file = await _localFile;

    // Write the file.
    return file.writeAsString('$counter');
  }

  Future<String> read() async {
    final file = await _localFile;
    String contents = await file.readAsString();
    return contents;
  }

  final flutterWebViewPlugin = new FlutterWebviewPlugin();

  Future<String> loadJS(String username, String password) async {
//    read();
//    flutterWebViewPlugin.reload();
    flutterWebViewPlugin.onStateChanged.listen((state) {
      if (state.type == WebViewState.finishLoad) {
        flutterWebViewPlugin.evalJavascript("let us = document.getElementById('loginform-username');us.value = '$username';let pa = document.getElementById('loginform-password');pa.value = '$password';let xa = document.getElementsByClassName('btn btn-primary btn-block')[1].click();");
      }

    });
  }

  @override
  Widget build(BuildContext context) {
    loadJS('Almanit', 'Wd0Gb41fla');
    var head = {
      'login': 'Almanit',
      'password': 'Wd0Gb41fla',
      'apikey': '52009ff562107968a258b8a91a2ed06cd5271f27',
      'Content-Type': 'application/json'
    };
    return WebviewScaffold(
      url: 'https://demo.fhs.kz/auth/login',
      withLocalStorage: true,
      withJavascript: true,
      headers: head,
      withZoom: true,
      scrollBar: false,
    );


  }
}
