import 'package:yaml/yaml.dart';
import 'dart:io';

/// hooks template
String commonHook(String path) {
  var temp = '';
  if (Platform.isMacOS) {
    temp += 'source ~/.zprofile\n';
  }
  temp += '''
hookName=`basename "\$0"`
gitParams="\$*"
program_exists() {
    local ret="0"
    command -v \$1 >/dev/null 2>&1 || { local ret="1"; }
    if [ "\$ret" -ne 0 ]; then
        return 1
    fi
    return 0
}
if program_exists dart; then
  dart ${path} \$hookName
  if [ "\$?" -ne "0" ];then
    exit 1
  fi
else
  echo "git_hooks > \$hookName"
  echo "Cannot find dart in PATH"
fi
''';
  return temp;
}

/// dart code template
const userHooks = r'''
import 'package:git_hooks/git_hooks.dart';
// import 'dart:io';

void main(List arguments) {
  // ignore: omit_local_variable_types
  Map<Git, UserBackFun> params = {
    Git.commitMsg: commitMsg,
    Git.preCommit: preCommit
  };
  GitHooks.call(arguments, params);
}

Future<bool> commitMsg() async {
  // var commitMsg = Utils.getCommitEditMsg();
  // if (commitMsg.startsWith('fix:')) {
  //   return true; // you can return true let commit go
  // } else {
  //   print('you should add `fix` in the commit message');
  //   return false;
  // }
  return true;
}

Future<bool> preCommit() async {
  // try {
  //   ProcessResult result = await Process.run('dartanalyzer', ['bin']);
  //   print(result.stdout);
  //   if (result.exitCode != 0) return false;
  // } catch (e) {
  //   return false;
  // }
  return true;
}
''';

/// hooks header
String createHeader() {
  var rootDir = Directory.current;
  var f = File(rootDir.path + '/pubspec.yaml');
  var text = f.readAsStringSync();
  Map yaml = loadYaml(text);
  String name = yaml['name'] ?? '';
  String author = yaml['author'] ?? '';
  String version = yaml['version'] ?? '';
  String homepage = yaml['homepage'] ?? '';
  return '''
#!/bin/sh
# !!!don"t edit this file
# ${name}
# Hook created by ${author}
#   Version: ${version}
#   At: ${DateTime.now()}
#   See: ${homepage}#readme

# From
#   Homepage: ${homepage}#readme

''';
}
