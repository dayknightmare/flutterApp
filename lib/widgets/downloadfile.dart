import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:toast/toast.dart';

class DownFileVupy {
  void showDownloadProgress(received, total) {
    if (total != -1) {
      print((received / total * 100).toStringAsFixed(0) + "%");
    }
  }

  Future downloadFile(fileurl, filename, context) async {
    Dio dio = Dio();
    String dirpath;
    print(fileurl);
    Directory appDocDirectory = await getExternalStorageDirectory();
    new Directory(appDocDirectory.path + '/' + 'vupyfiles').create(recursive: true)
      .then((Directory directory) async {
        try {
          dirpath = directory.path;
          await dio.download(
            "https://vupytcc.pythonanywhere.com/" + fileurl, "$dirpath/$filename",
            onReceiveProgress: (rec, total) {
              print("Rec: $rec , Total: $total");
            }
          );
          Toast.show("Salvo em: $dirpath", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);

        } catch (e) {
          print(e);
        }
      });
  }
}
