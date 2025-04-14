import 'package:e_com/_core/_core.dart';
import 'package:e_com/feature/chat_with_seller/controller/seller_file_downloder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_parsed_text/flutter_parsed_text.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class UniChatBubble extends HookConsumerWidget {
  const UniChatBubble({
    super.key,
    required this.message,
    required this.isMine,
    required this.isSeen,
    required this.selected,
    required this.files,
  });

  final String message;
  final bool isMine, isSeen, selected;
  final List<({String name, String url})> files;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: context.colors.primary.withOpacity(selected ? .1 : 0),
      padding: Insets.padH,
      child: Column(
        crossAxisAlignment:
            isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 5),
            constraints: BoxConstraints(maxWidth: context.width / 1.2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: selected
                  ? context.colors.primary.withOpacity(.1)
                  : context.colors.onSurface.withOpacity(.05),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 8,
            ),
            child: ParsedText(
              text: message,
              style: context.textTheme.bodyLarge,
              parse: [
                MatchText(
                  type: ParsedType.PHONE,
                  onTap: (x) => URLHelper.call(x),
                  style: context.textTheme.bodyLarge?.textColor(
                    context.colors.primary.withOpacity(.7),
                  ),
                ),
                MatchText(
                  type: ParsedType.EMAIL,
                  onTap: (x) => URLHelper.mail(x),
                  style: context.textTheme.bodyLarge?.textColor(
                    context.colors.primary.withOpacity(.7),
                  ),
                ),
                MatchText(
                  type: ParsedType.URL,
                  onTap: (x) => URLHelper.url(x),
                  style: context.textTheme.bodyLarge?.textColor(
                    context.colors.primary.withOpacity(.7),
                  ),
                ),
              ],
            ),
          ),
          const Gap(Insets.sm),
          if (files.isNotEmpty) ...[
            _ChatFiles(files: files),
            const Gap(Insets.sm),
          ],
          if (isMine && isSeen)
            Icon(
              Icons.done_all_outlined,
              size: 18,
              color: context.colors.primary.withOpacity(0.7),
            ),
        ],
      ),
    );
  }
}

class _ChatFiles extends HookConsumerWidget {
  const _ChatFiles({
    required this.files,
  });

  final List<({String name, String url})> files;

  @override
  Widget build(BuildContext context, ref) {
    final downloadQueue = ref.watch(sellerFileDownloadCtrlProvider);
    final downloader =
        useCallback(() => ref.read(sellerFileDownloadCtrlProvider.notifier));

    return SizedBox(
      width: context.width * 0.7,
      child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: files.length,
        itemBuilder: (context, index) {
          final download =
              downloadQueue.where((f) => f.url == files[index].url).firstOrNull;

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 3.0),
            child: Container(
              decoration: BoxDecoration(
                color: context.colors.onSurface.withOpacity(.05),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        downloader().addToQueue(files[index]);
                      },
                      child: CircleAvatar(
                        backgroundColor: context.colors.primary,
                        child: download == null
                            ? Icon(
                                Icons.download_rounded,
                                color: context.colors.onPrimary,
                              )
                            : (download.progress?.isNegative ?? false)
                                ? Icon(
                                    Icons.file_open_rounded,
                                    color: context.colors.onPrimary,
                                  )
                                : CircularProgressIndicator(
                                    value: download.progress,
                                    color: context.colors.onPrimary,
                                  ),
                      ),
                    ),
                    const Gap(Insets.med),
                    SizedBox(
                      width: context.width / 5.5,
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: '${context.tr.file} ${index + 1}',
                              style: context.textTheme.bodyLarge!.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: '\n${files[index].name.split('.').last}',
                            ),
                          ],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
