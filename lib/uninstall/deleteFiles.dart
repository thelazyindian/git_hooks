import 'dart:io';

import 'package:git_hooks/utils/logging.dart';

import '../git_hooks.dart';

/// delete all file from `.git/hooks`
Future<bool> deleteFiles({String rootDir}) async {
  var _rootDir = rootDir ?? Directory.current.path;
  var logger = Logger.standard();

  var gitDir = Directory(Utils.uri(_rootDir + '/.git/'));
  var gitHookDir = Utils.gitHookFolder;
  if (!gitDir.existsSync()) {
    print(gitDir.path);
    throw ArgumentError('.git is not exists in your project');
  }
  var progress = logger.progress('delete files');
  for (var hook in hookList.values) {
    var path = gitHookDir(_rootDir) + hook;
    var hookFile = File(path);
    if (hookFile.existsSync()) {
      await hookFile.delete();
    }
  }
  var hookFile = File(Utils.uri(_rootDir + '/git_hooks.dart'));
  if (hookFile.existsSync()) {
    await hookFile.delete();
    print('git_hooks.dart deleted successfully!');
  }
  progress.finish(showTiming: true);
  print('All files deleted successfully!');
  await Process.run('pub', ['global', 'deactivate', 'git_hooks'])
      .catchError((onError) {
    print(onError);
  });
  print('git_hooks uninstalled successful!');
  return true;
}
