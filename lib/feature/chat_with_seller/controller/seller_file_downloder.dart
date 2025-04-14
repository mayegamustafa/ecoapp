import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:e_com/_core/_core.dart';
import 'package:e_com/models/models.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

final sellerFileDownloadCtrlProvider = NotifierProvider<
    ChatFileDownloaderNotifier,
    List<FileDownloaderQueueModel>>(ChatFileDownloaderNotifier.new);

class ChatFileDownloaderNotifier
    extends Notifier<List<FileDownloaderQueueModel>> {
  @override
  List<FileDownloaderQueueModel> build() {
    return [];
  }

  void addToQueue(
    ({String name, String url}) file, [
    bool openable = true,
  ]) async {
    final saveDir = await getApplicationDocumentsDirectory();
    final downloadPath = saveDir.path + file.name;
    final isExisting = await File(downloadPath).exists();

    final id = Random.secure().nextInt(10000000);
    state = [
      ...state,
      FileDownloaderQueueModel(
        id: id,
        url: file.url,
        progress: isExisting ? -1 : null,
        downloadPath: downloadPath,
      ),
    ];

    if (isExisting) {
      if (openable) await OpenFilex.open(downloadPath);
      return;
    }
    await _startDownload(id);
  }

  Future<void> _startDownload(int id) async {
    final queuedFile = state.firstWhere((element) => element.id == id);

    try {
      await Dio().download(
        queuedFile.url,
        queuedFile.downloadPath,
        lengthHeader: Headers.contentLengthHeader,
        options: Options(
          headers: {HttpHeaders.acceptEncodingHeader: '*'},
        ),
        onReceiveProgress: (received, total) {
          double? progress = ((received / total) * 100) / 100;
          if (total <= 0) progress = null;
          state = [
            for (final file in state)
              if (file.id == id) file.updateProgress(progress) else file
          ];
        },
      );

      state = [
        for (final file in state)
          if (file.id == id) file.updateProgress(-1) else file
      ];
    } on PlatformException catch (e) {
      Toaster.showError(e.code);
    } on DioException catch (e) {
      Toaster.showError(e.message);
    }
  }
}
