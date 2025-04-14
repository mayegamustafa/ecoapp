import 'dart:io' as io;
import 'dart:math' as math;

import 'package:e_com/feature/chat_with_seller/view/local/chat_selected_file.dart';
import 'package:e_com/feature/delivery_man_chat/controller/delivery_man_chat_ctrl.dart';
import 'package:e_com/main.export.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:grouped_list/sliver_grouped_list.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:share_plus/share_plus.dart';

class DeliveryManChatView extends HookConsumerWidget {
  const DeliveryManChatView(this.id, {super.key});
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatDetails = ref.watch(deliveryChatDetailsProvider(id));
    final chatCtrl =
        useCallback(() => ref.read(deliveryChatDetailsProvider(id).notifier));
    final files = useState<List<io.File>>([]);
    final msgCtrl = useTextEditingController();
    final selected = useState<List<DeliveryManMessage>>([]);

    final refreshCtrl = RefreshController();

    void addToSelected(DeliveryManMessage msg) {
      final contains = selected.value.map((e) => e.id).contains(msg.id);
      if (contains) {
        selected.value = selected.value.where((e) => e.id != msg.id).toList();
      } else {
        selected.value = [...selected.value, msg];
      }
    }

    final isSending = useState(false);

    String buildSelectedMSG() {
      final msgs = <String>[];
      for (var msg in selected.value) {
        final date = msg.dateTime.formate('dd/MM, hh:mm a');
        msgs.add('[$date] ${msg.userName} : ${msg.message}');
      }
      return msgs.join('\n');
    }

    return chatDetails.when(
      error: (e, s) => ErrorView(e, s).withSF(),
      loading: () => const Loader().withSF(),
      data: (chat) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                if (selected.value.isEmpty) return context.pop();
                selected.value = [];
              },
              icon: selected.value.isEmpty
                  ? const Icon(Icons.arrow_back_rounded)
                  : const Icon(Icons.close_rounded),
            ),
            title: selected.value.isEmpty
                ? Text(chat.deliveryMan.firstName)
                : Text('${selected.value.length}'),
            actions: [
              if (selected.value.isEmpty)
                CircleAvatar(
                  backgroundImage: HostedImage.provider(
                    chat.deliveryMan.image,
                  ),
                )
              else ...[
                IconButton(
                  onPressed: () {
                    final msg = buildSelectedMSG();
                    Clipper.copy(msg);
                  },
                  icon: const Icon(Icons.copy_rounded),
                ),
                IconButton(
                  onPressed: () {
                    final msg = buildSelectedMSG();
                    Share.share(msg);
                  },
                  icon: const Icon(Icons.share_rounded),
                ),
              ],
              const Gap(Insets.med)
            ],
          ),
          body: Column(
            children: [
              Expanded(
                flex: 9,
                child: SmartRefresher(
                  controller: refreshCtrl,
                  enablePullUp: true,
                  reverse: true,
                  physics: const AlwaysScrollableScrollPhysics(),
                  onRefresh: () async {
                    await chatCtrl().reload();
                    refreshCtrl.refreshCompleted();
                  },
                  onLoading: () async {
                    final load = await chatCtrl().loadMore();
                    if (load case LoadStatus.failed) {
                      refreshCtrl.loadFailed();
                    }
                    if (load case LoadStatus.noMore) {
                      refreshCtrl.loadNoData();
                    }

                    await Future.delayed(1.seconds);
                    refreshCtrl.loadComplete();
                  },
                  child: CustomScrollView(
                    reverse: true,
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      SliverGroupedListView<DeliveryManMessage, DateTime>(
                        elements: chat.messages.listData,
                        groupBy: (element) => DateTime(
                          element.dateTime.year,
                          element.dateTime.month,
                          element.dateTime.day,
                          element.dateTime.hour,
                        ),
                        itemComparator: (a, b) =>
                            a.dateTime.compareTo(b.dateTime),
                        itemBuilder: (context, msg) {
                          final selectedMsg =
                              selected.value.map((e) => e.id).contains(msg.id);
                          return GestureDetector(
                            onLongPress: () {
                              if (selected.value.isEmpty) {
                                addToSelected(msg);
                                HapticFeedback.selectionClick();
                              }
                            },
                            onTap: () {
                              if (selected.value.isNotEmpty) {
                                addToSelected(msg);
                              }
                            },
                            child: UniChatBubble(
                              message: msg.message,
                              files: msg.files,
                              isMine: msg.isMine,
                              isSeen: msg.isSeen,
                              selected: selectedMsg,
                            ),
                          );
                        },
                        order: GroupedListOrder.DESC,
                        groupSeparatorBuilder: (value) => Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Text(
                              value.formatDate(context, 'dd:MM:yyyy'),
                              style: context.textTheme.labelMedium!.copyWith(
                                color: context.colors.onSurface.withOpacity(.5),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: defaultPadding,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        if (files.value.isEmpty) {
                          files.value = await chatCtrl().pickFiles();
                        } else {
                          showModalBottomSheet(
                            context: context,
                            showDragHandle: true,
                            isScrollControlled: true,
                            builder: (_) =>
                                SelectedFilesSheetChat(files: files),
                          );
                        }
                      },
                      child: CircleAvatar(
                        backgroundColor:
                            context.colors.onSurface.withOpacity(.05),
                        child: files.value.isEmpty
                            ? RotationTransition(
                                turns: const AlwaysStoppedAnimation(30 / 360),
                                child: Icon(
                                  Icons.attach_file,
                                  color: context.colors.onSurface,
                                ),
                              )
                            : CircleAvatar(
                                backgroundColor: context.colors.primary,
                                foregroundColor:
                                    context.colors.onSecondaryContainer,
                                radius: 12,
                                child: Text(
                                  files.value.length.toString(),
                                ),
                              ),
                      ),
                    ),
                    const Gap(Insets.med),
                    Flexible(
                      child: TextFormField(
                        onTap: () {
                          if (selected.value.isNotEmpty) selected.value = [];
                        },
                        controller: msgCtrl,
                        maxLines: null,
                        textInputAction: TextInputAction.newline,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          hintText: context.tr.type_a_message,
                          constraints: BoxConstraints(
                            maxHeight: context.height * 0.2,
                          ),
                        ),
                      ),
                    ),
                    const Gap(Insets.med),
                    IconButton.filled(
                      onPressed: () async {
                        isSending.value = true;
                        await chatCtrl().sendReply(msgCtrl.text, files.value);
                        msgCtrl.clear();
                        files.value = [];
                        isSending.value = false;
                      },
                      icon: isSending.value
                          ? SizedBox.square(
                              dimension: 20,
                              child: CircularProgressIndicator(
                                color: context.colors.onPrimary,
                                strokeWidth: 3,
                              ),
                            )
                          : Transform.rotate(
                              angle: -math.pi / 5,
                              child: const Icon(Icons.send_rounded),
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
