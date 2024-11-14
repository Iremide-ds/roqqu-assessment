import 'package:flutter/material.dart';
import 'package:roqqu_assessment/src/app.dart';
import 'package:roqqu_assessment/src/dependencies/init_dependencies.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  initDependencies();

  runApp(const MyApp());
}
