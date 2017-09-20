import 'package:build_runner/build_runner.dart';
import 'package:dson/action.dart';


main() async {
  await watch([dsonAction(const ['test/**.dart'])], deleteFilesByDefault: true);
}
