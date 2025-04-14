import 'package:e_com/_core/_core.dart';
import 'package:flutter/material.dart';

class UserOrderCard extends StatelessWidget {
  const UserOrderCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final Function() onTap;
  final String subtitle;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.none,
      decoration: BoxDecoration(
        color: context.colors.secondaryContainer.withOpacity(0.05),
        border: Border.all(width: 0, color: context.colors.secondaryContainer),
        borderRadius: defaultRadius,
      ),
      child: InkWell(
        borderRadius: defaultRadius,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                color: context.colors.primary,
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: context.textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                subtitle,
                style: context.textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
