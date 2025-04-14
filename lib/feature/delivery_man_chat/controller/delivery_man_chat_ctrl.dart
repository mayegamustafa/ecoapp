import 'dart:async';
import 'dart:io';

import 'package:e_com/feature/delivery_man_chat/repository/delivery_man_chat_repo.dart';
import 'package:e_com/main.export.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

final deliveryManChatListProvider = AutoDisposeAsyncNotifierProvider<
    DeliveryManChatListNotifier, List<DeliveryMan>>(
  DeliveryManChatListNotifier.new,
);

class DeliveryManChatListNotifier
    extends AutoDisposeAsyncNotifier<List<DeliveryMan>> {
  Future<void> reload() async {
    ref.invalidateSelf();
  }

  DeliveryManChatRepo get _repo => ref.read(deliveryManChatRepoProvider);

  @override
  FutureOr<List<DeliveryMan>> build() async {
    final res = await _repo.getChat();
    return res.fold(
      (l) => Future.error(l.message, l.stackTrace),
      (r) => r.data,
    );
  }
}

final deliveryChatDetailsProvider = AutoDisposeAsyncNotifierProviderFamily<
    DeliveryChatDetailsNotifier, DeliveryManChat, String>(
  DeliveryChatDetailsNotifier.new,
);

class DeliveryChatDetailsNotifier
    extends AutoDisposeFamilyAsyncNotifier<DeliveryManChat, String> {
  Future<void> reload() async {
    final data = await _init();
    state = AsyncData(data);
  }

  Future<void> sendReply(String massage, List<File> files) async {
    if (massage.isEmpty) {
      Toaster.showError('Massage Filled Required');
      return;
    }
    final res = await _repo.sendReply(arg, massage, files);

    res.fold(
      (l) => Toaster.showError(l),
      (r) {
        ref.invalidateSelf();
      },
    );
  }

  Future<LoadStatus> loadMore() async {
    final it = await future;
    final next = it.messages.pagination?.nextPageUrl;
    if (next == null) return LoadStatus.noMore;

    final moreData = await _repo.loadMoreFromUrl(next);
    final more = moreData.fold(
      (l) => it.messages,
      (r) => it.messages + r.data,
    );

    state = AsyncData(it.newMessages(more));

    return moreData.fold((l) => LoadStatus.failed, (r) => LoadStatus.idle);
  }

  Future<List<File>> pickFiles() async {
    final picker = ref.read(filePickerProvider);

    final res = await picker.pickFiles(allowedExtensions: ticketFileTypes);

    return res.fold(
      (l) {
        Toaster.showError(l);
        return [];
      },
      (r) => r,
    );
  }

  DeliveryManChatRepo get _repo => ref.read(deliveryManChatRepoProvider);

  FutureOr<DeliveryManChat> _init() async {
    final res = await _repo.getChatDetails(arg);
    return res.fold(
      (l) => Future.error(l.message, l.stackTrace),
      (r) => r.data,
    );
  }

  @override
  FutureOr<DeliveryManChat> build(arg) async {
    return _init();
  }
}
