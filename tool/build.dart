import 'package:build_runner/build_runner.dart';
import 'package:dson/action.dart';


main() async {
  await build([dsonAction(const ['test/**.dart'])], deleteFilesByDefault: true);
}
