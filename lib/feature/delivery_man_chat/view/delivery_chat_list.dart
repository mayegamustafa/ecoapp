import 'package:e_com/feature/delivery_man_chat/controller/delivery_man_chat_ctrl.dart';
import 'package:e_com/main.export.dart';
import 'package:e_com/routes/go_route_name.dart';
import 'package:flutter/material.dart';

class DeliveryManChatListView extends ConsumerWidget {
  const DeliveryManChatListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatList = ref.watch(deliveryManChatListProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr.chatWithDeliveryman),
      ),
      body: chatList.when(
        error: (e, s) =>
            ErrorView(e, s, invalidate: deliveryManChatListProvider),
        loading: () => Loader.list(),
        data: (chat) {
          if (chat.isEmpty) return const Center(child: NoItemsAnimation());

          return Padding(
            padding: Insets.padAll,
            child: RefreshIndicator(
              onRefresh: ref.read(deliveryManChatListProvider.notifier).reload,
              child: ListView.builder(
                itemCount: chat.length,
                itemBuilder: (context, index) => ChatListCard(
                  deliveryman: chat[index],
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
    required this.deliveryman,
  });
  final DeliveryMan deliveryman;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => RouteNames.deliveryChatDetails.pushNamed(
        context,
        pathParams: {'id': deliveryman.id.toString()},
      ),
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
        padding: defaultPaddingAll,
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: HostedImage.provider(deliveryman.image),
                ),
                const Gap(Insets.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        deliveryman.firstName,
                        style: context.textTheme.bodyLarge!.copyWith(
                          fontWeight: (deliveryman.lastMessage?.isSeen ?? false)
                              ? FontWeight.normal
                              : FontWeight.bold,
                        ),
                      ),
                      const Gap(Insets.sm),
                      if (deliveryman.lastMessage != null)
                        Text(
                          deliveryman.lastMessage!.message,
                          style: context.textTheme.bodyLarge!.copyWith(
                            color: context.colors.onSurface.withOpacity(.5),
                          ),
                        ),
                    ],
                  ),
                ),
                const Spacer(),
                if (deliveryman.lastMessage != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (!deliveryman.lastMessage!.isSeen)
                        if (!deliveryman.lastMessage!.isMine)
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: context.colors.primary.withOpacity(.1),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 3,
                            ),
                            child: Text(
                              'New',
                              style: context.textTheme.bodyLarge!.copyWith(
                                color: context.colors.primary,
                              ),
                            ),
                          ),
                      const Gap(Insets.sm),
                      Text('${deliveryman.lastMessage!.readableTime} ago'),
                    ],
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
