import 'package:flutter/material.dart';
import 'conf.dart';

class _HomePageState extends State<HomePage> {
  bool _ready = false;

  @override
  void initState() {
    onConfReady.then((_) => setState(() => _ready = true));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _ready
              ? <Widget>[
                  RaisedButton(
                    child: const Text("Dataview"),
                    onPressed: () =>
                        Navigator.of(context).pushNamed("/dataview"),
                  ),
                  RaisedButton(
                    child: const Text("Crud view"),
                    onPressed: () =>
                        Navigator.of(context).pushNamed("/crudview"),
                  ),
                  RaisedButton(
                    child: const Text("List view"),
                    onPressed: () =>
                        Navigator.of(context).pushNamed("/listview"),
                  )
                ]
              : <Widget>[const CircularProgressIndicator()],
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}
