// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// You can read about packages here: https://flutter.io/using-packages/
import 'package:flutter/material.dart';

import 'category_route.dart';
// You can use a relative import, i.e. `import 'category_route.dart;'` or
// a package import, as shown below.
// More details at http://dart-lang.github.io/linter/lints/avoid_relative_lib_imports.html

/// The function that is called when main.dart is run.
void main() {
  runApp(UnitConverterApp());
}

/// This widget is the root of our application.
///
/// The first screen we see is a list [Categories], each of which
/// has a list of [Unit]s.
class UnitConverterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Unit Converter',
      // Done: Fill out the theme parameter
      theme: ThemeData(
          primaryColor: Colors.grey[500],
          textTheme: TextTheme(
            display1: TextStyle(color: Colors.grey[600]),
            display2: TextStyle(color: Colors.grey[600]),
            display3: TextStyle(color: Colors.grey[600]),
            display4: TextStyle(color: Colors.grey[600]),
            body1: TextStyle(color: Colors.black),
            body2: TextStyle(color: Colors.black),
          )),
      home: CategoryRoute(),
    );
  }
}
