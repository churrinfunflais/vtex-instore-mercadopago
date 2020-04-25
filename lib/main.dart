import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';
import 'mercadoPago.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'VTEX Link',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: MyHomePage(title: 'VTEX Link'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  StreamSubscription _sub;
  String _urlString = '';

  @override
  initState() {
    super.initState();
    initPlatformState();
  }

  static Future<void> pop() async {
    await SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop');
  }

  initPlatformState() async {
    await initPlatformStateForUriUniLinks();
  }

  initPlatformStateForUriUniLinks() async {
    Uri initialUri;
    Map uriParams;

    _sub = getUriLinksStream().listen((Uri uri) {
      uriParams = new Map.from(uri.queryParameters);

      parseRequest(uri, uriParams);

    }, onError: (err) {
      setState(() => this._urlString = err.toString());
    });

    try {
      initialUri = await getInitialUri();
      uriParams = new Map.from(initialUri.queryParameters);

      parseRequest(initialUri, uriParams);

    } catch (e) {}

    if (!mounted) return;
  }

  parseRequest(Uri initialUri, Map uriParams) async {
    if (initialUri.host == 'payment' && uriParams['acquirer'] == 'mercado_pago')
      await launch(paymentMercadoPagoUri(uriParams).toString(), universalLinksOnly: false, forceSafariVC: false);

    if (initialUri.host == 'payment_result' && uriParams['acquirer'] == 'mercado_pago')
      await launch(paymentResultMercadoPagoUri(uriParams).toString(), universalLinksOnly: false, forceSafariVC: false);

    if (initialUri.host == 'payment_fail' && uriParams['acquirer'] == 'mercado_pago')
      await launch(paymentFailMercadoPagoUri(uriParams).toString(), universalLinksOnly: false, forceSafariVC: false);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent));

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(
              image: AssetImage('graphics/VTEX_icon_pink_RGB.png'),
              width: 180,
              height: 180,
            ),
            Text(
              _urlString,
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
