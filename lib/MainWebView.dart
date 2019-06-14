import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class MainWebView extends StatelessWidget {

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
