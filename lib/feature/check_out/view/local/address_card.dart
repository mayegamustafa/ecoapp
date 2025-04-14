import 'package:e_com/feature/address/controller/address_ctrl.dart';
import 'package:e_com/feature/check_out/controller/checkout_ctrl.dart';
import 'package:e_com/main.export.dart';
import 'package:e_com/routes/go_route_name.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AddressCard extends StatelessWidget {
  const AddressCard({
    super.key,
    this.onChangeTap,
    required this.checkout,
  });

  final Function()? onChangeTap;
  final CheckoutModel checkout;

  @override
  Widget build(BuildContext context) {
    final tr = context.tr;
    final billing = checkout.billingAddress;
    return InkWell(
      onTap: billing != null
          ? null
          : () {
              showModalBottomSheet(
                context: context,
                builder: (ctx) => AddressBottomSheet(billing?.id),
              );
            },
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(minHeight: 100),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: context.colors.secondaryContainer.withOpacity(
            context.isDark ? 0.2 : 0.05,
          ),
          border: Border.all(
            color: context.colors.secondaryContainer,
            width: 1,
          ),
        ),
        alignment: billing == null ? Alignment.center : null,
        padding: defaultPaddingAll,
        child: billing == null
            ? Text(
                tr.choose_address,
                style: context.textTheme.titleMedium,
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          billing.fullName,
                          style: context.textTheme.titleLarge,
                        ),
                      ),
                      TextButton.icon(
                        style: TextButton.styleFrom(
                          foregroundColor: context.colors.secondary,
                        ),
                        onPressed: onChangeTap ??
                            () {
                              showModalBottomSheet(
                                context: context,
                                builder: (ctx) => AddressBottomSheet(
                                  billing.id,
                                ),
                              );
                            },
                        icon: const Icon(Icons.edit_rounded, size: 18),
                        label: Text(tr.change),
                      ),
                    ],
                  ),
                  if (billing.phone != null) const SizedBox(height: 8),
                  Text(
                    billing.phone ?? '',
                    style: context.textTheme.bodyLarge,
                  ).removeIfEmpty(),
                  Text(
                    billing.email,
                    style: context.textTheme.bodyLarge,
                  ).removeIfEmpty(),
                  const Gap(8),
                  if (billing.country != null)
                    Text(
                      '${tr.country}: ${billing.country!.name}',
                      style: context.textTheme.bodyLarge,
                    ),
                  if (billing.state != null)
                    Text(
                      '${tr.state}: ${billing.state!.name}',
                      style: context.textTheme.bodyLarge,
                    ),
                  if (billing.city != null)
                    Text(
                      '${tr.city}: ${billing.city!.name}',
                      style: context.textTheme.bodyLarge,
                    ),
                  Text(
                    '${tr.address}: ${billing.address}',
                    style: context.textTheme.bodyLarge,
                  ),
                  if (checkout.shipping != null) ...[
                    const SizedBox(height: 8),
                    Text.rich(
                      TextSpan(
                        style: context.textTheme.bodyLarge,
                        children: [
                          TextSpan(text: '${tr.shipping_by}: '),
                          TextSpan(
                            text: checkout.shipping?.methodName ?? 'N/A',
                            style: context.textTheme.bodyLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
      ),
    );
  }
}

class AddressBottomSheet extends HookConsumerWidget {
  const AddressBottomSheet(this.addressKey, {super.key});
  final int? addressKey;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tr = context.tr;
    final addresses = ref.watch(addressListProvider);
    final aniCtrl = useAnimationController();
    return BottomSheet(
      animationController: aniCtrl,
      showDragHandle: true,
      onClosing: () {},
      builder: (c) => Container(
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(10),
          ),
        ),
        padding: defaultPadding,
        child: Column(
          children: [
            Text(
              tr.choose_address,
              style: context.textTheme.titleLarge,
            ),
            const Divider(height: 20),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                fixedSize: Size(context.width, 40),
                foregroundColor: context.colors.secondary,
                side: BorderSide(
                  color: context.colors.secondary,
                  width: 1,
                ),
              ),
              onPressed: () => RouteNames.address.pushNamed(context),
              icon: const Icon(Icons.add_location_alt_outlined),
              label: Text(tr.add_address),
            ),
            const SizedBox(height: 10),
            ListView.separated(
              shrinkWrap: true,
              physics: defaultScrollPhysics,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemCount: addresses.length,
              itemBuilder: (context, index) {
                final address = addresses[index];
                return Card(
                  elevation: 0,
                  color: context.colors.secondary
                      .withOpacity(addressKey == address.id ? .1 : .05),
                  shape: RoundedRectangleBorder(
                    borderRadius: defaultRadius,
                    side: addressKey != address.id
                        ? BorderSide.none
                        : BorderSide(
                            color: context.colors.secondaryContainer,
                          ),
                  ),
                  margin: EdgeInsets.zero,
                  child: ListTile(
                    title: Text(address.fullName),
                    subtitle: Text(address.address),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded),
                    onTap: () {
                      ref
                          .read(checkoutCtrlProvider.notifier)
                          .setBilling(address);
                      context.pop();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
