import 'package:background_downloader/background_downloader.dart';
import 'package:e_com/main.export.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';

class DownloadButton extends HookConsumerWidget {
  const DownloadButton({
    super.key,
    required this.url,
  });

  final String url;

  @override
  Widget build(context, ref) {
    final task = useState<DownloadTask?>(null);
    final status = useState<TaskStatus?>(null);
    final progress = useState(0.0);
    final fileName = url.split('/').last;

    useEffect(
      () {
        task.value = DownloadTask(
          url: url,
          filename: fileName,
          updates: Updates.statusAndProgress,
        );
        return null;
      },
      const [],
    );

    return InkWell(
      onTap: () async {
        if (task.value == null) return;
        if (status.value == TaskStatus.complete) {
          final path = await task.value!.filePath(withFilename: fileName);

          OpenFilex.open(path);
          return;
        }
        final res = await FileDownloader().download(
          task.value!,
          onStatus: (v) {
            status.value = v;
          },
          onProgress: (v) {
            if (!v.isNegative) progress.value = v;
          },
        );

        if (res.exception != null) {
          Toaster.showError(res.exception?.description ?? 'Error Downloading');
        }
      },
      child: CircleAvatar(
        radius: 15,
        backgroundColor: context.colors.primary.withOpacity(.1),
        child: Stack(
          children: [
            Center(
              child: Icon(
                status.value == TaskStatus.complete
                    ? Icons.file_open_rounded
                    : Icons.download,
                size: 18,
                color: context.colors.primary,
              ),
            ),
            if (status.value == TaskStatus.running)
              CircularProgressIndicator(
                strokeWidth: 3,
                value: progress.value,
              ),
          ],
        ),
      ),
    );
  }
}
