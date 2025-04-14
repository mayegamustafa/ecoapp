import 'dart:async';
import 'dart:io';

import 'package:e_com/main.export.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../repository/chat_with_seller_dart_repo.dart';

final sellerChatListProvider =
    AutoDisposeAsyncNotifierProvider<SellerChatListNotifier, List<Seller>>(
  SellerChatListNotifier.new,
);

class SellerChatListNotifier extends AutoDisposeAsyncNotifier<List<Seller>> {
  Future<void> reload() async {
    ref.invalidateSelf();
  }

  @override
  FutureOr<List<Seller>> build() async {
    final res = await ref.watch(chatWithSellerRepoProvider).getChat();
    return res.fold(
      (l) => Future.error(l.message, l.stackTrace),
      (r) => r.data,
    );
  }
}

final sellerChatDetailsProvider = AutoDisposeAsyncNotifierProviderFamily<
    SellerChatDetailsNotifier, SellerChat, String>(
  SellerChatDetailsNotifier.new,
);

class SellerChatDetailsNotifier
    extends AutoDisposeFamilyAsyncNotifier<SellerChat, String> {
  Future<void> reload() async {
    final data = await _init();
    state = AsyncData(data);
  }

  ChatWithSellerRepoRepo get _repo => ref.read(chatWithSellerRepoProvider);

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

  FutureOr<SellerChat> _init() async {
    final res = await ref.read(chatWithSellerRepoProvider).getChatDetails(arg);
    return res.fold(
      (l) => Future.error(l.message, l.stackTrace),
      (r) => r.data,
    );
  }

  @override
  FutureOr<SellerChat> build(arg) async {
    return _init();
  }
}
