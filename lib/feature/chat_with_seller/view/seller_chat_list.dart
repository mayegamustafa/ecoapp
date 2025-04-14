import 'package:e_com/main.export.dart';
import 'package:e_com/routes/go_route_name.dart';
import 'package:flutter/material.dart';

import '../controller/chat_with_seller_ctrl.dart';

class SellerChatListView extends ConsumerWidget {
  const SellerChatListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatList = ref.watch(sellerChatListProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr.chat),
      ),
      body: chatList.when(
        error: (e, s) => ErrorView(e, s, invalidate: sellerChatListProvider),
        loading: () => const Loader(),
        data: (chat) {
          if (chat.isEmpty) return const Center(child: NoItemsAnimation());

          return Padding(
            padding: defaultPadding.copyWith(top: 10),
            child: RefreshIndicator(
              onRefresh: ref.read(sellerChatListProvider.notifier).reload,
              child: ListView.separated(
                itemCount: chat.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) => ChatListCard(
                  seller: chat[index],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class ChatListCard extends ConsumerWidget {
  const ChatListCard({
    super.key,
    required this.seller,
  });
  final Seller seller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isNew = !seller.lastMessage!.isSeen && !seller.lastMessage!.isMine;
    return GestureDetector(
      onTap: () => RouteNames.sellerChatDetails.pushNamed(context, pathParams: {
        'id': seller.id.toString(),
      }),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: Corners.smBorder,
          color: context.colors.surface,
          boxShadow: [
            BoxShadow(
              blurRadius: 6,
              color: context.colors.onSurface.withOpacity(.03),
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Padding(
          padding: defaultPaddingAll,
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: HostedImage.provider(seller.image),
                  ),
                  const Gap(Insets.lg),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          seller.name,
                          style: context.textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Gap(Insets.sm),
                        Text(
                          seller.lastMessage!.message,
                          style: context.textTheme.bodyLarge!.copyWith(
                            color: context.colors.onSurface.withOpacity(.5),
                          ),
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (isNew)
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: context.colors.primary.withOpacity(.1),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 3,
                            ),
                            child: Text(
                              context.tr.newChat,
                              style: context.textTheme.bodyLarge!.copyWith(
                                color: context.colors.primary,
                              ),
                            ),
                          ),
                        )
                      else
                        const SizedBox.shrink(),
                      const Gap(Insets.sm),
                      Text(
                        seller.lastMessage!.readableTime,
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
