import 'dart:io';
import 'package:git_hooks/runtime/git_hooks.dart';
import 'package:git_hooks/utils/utils.dart';
import 'package:yaml/yaml.dart';

import 'package:git_hooks/install/create_hooks.dart';

void main(List<String>? arguments) {
  if (arguments?.isNotEmpty ?? false) {
    var str = arguments![0];
    if (arguments.length <= 3) {
      if (str == 'create') {
        //init files
        if (arguments.length == 2) {
          if (arguments[1].endsWith('.dart')) {
            CreateHooks.copyFile(targetPath: arguments[1]);
          } else {
            CreateHooks.copyFile(rootDir: arguments[1]);
          }
        } else if (arguments.length == 3 && arguments[2].endsWith('.dart')) {
          CreateHooks.copyFile(rootDir: arguments[1], targetPath: arguments[2]);
        } else {
          CreateHooks.copyFile();
        }
      } else if (str == '-h' || str == '-help') {
        help();
      } else if (str == '-v' || str == '--version') {
        var f = File(Utils.uri(Utils.getOwnPath()! + '/pubspec.yaml'));
        var text = f.readAsStringSync();
        Map yaml = loadYaml(text);
        String version = yaml['version'];
        print(version);
      } else if (str == 'uninstall') {
        GitHooks.unInstall();
      } else {
        print('${str} is not a git_hooks command,see follow');
        print('');
        help();
      }
    } else {
      print(
          'Too many positional arguments: 3 expected, but ${arguments.length} found - ${arguments.reduce((a, b) => '$a $b')}');
      print('');
      help();
    }
  } else {
    print('please Enter the command');
    print('');
    help();
  }
}

void help() {
  print('Common commands:');
  print('');
  print(' git_hooks create {{rootDir}} {{targetPath}}');
  print('   Create hooks files in \'{{rootDir}}/.git/hooks\'');
  print('   Create hook dart runner files in \'{{targetPath}}\'');
  print('');
}
