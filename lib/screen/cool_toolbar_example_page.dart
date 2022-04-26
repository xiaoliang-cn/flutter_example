import 'package:flutter/material.dart';

import '../examples/cool_toolbar/cool_toolbar.dart';

class CoolToolbarExamplePage extends StatelessWidget {
  const CoolToolbarExamplePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: CoolToolbar(),
        ),
      ),
    );
  }
}
