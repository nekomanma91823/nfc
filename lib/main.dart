import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _nfcData = 'NFCタグをスキャンしてください';

  @override
  void initState() {
    super.initState();
    NfcManager.instance.isAvailable().then((isAvailable) {
      if (!isAvailable) {
        setState(() {
          _nfcData = 'NFCがサポートされていません';
        });
      }
    });
  }

  Future<void> _scanNFC() async {
    try {
      bool isAvailable = await NfcManager.instance.isAvailable();
      if (!isAvailable) {
        setState(() {
          _nfcData = 'NFCがサポートされていません';
        });
        return;
      }

      // NFCセッションを開始
      NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
        setState(() {
          _nfcData = 'NFCタグが読み取られました: ${tag.data}';
        });
        // NFCセッションを停止
        NfcManager.instance.stopSession();
      });
    } catch (e) {
      setState(() {
        _nfcData = 'エラーが発生しました: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter NFC Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(_nfcData),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _scanNFC,
              child: Text('NFCタグをスキャン'),
            ),
          ],
        ),
      ),
    );
  }
}
