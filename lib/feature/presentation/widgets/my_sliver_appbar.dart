import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../utils/constants/todo_colors.dart';

class MySliverAppBar extends SliverPersistentHeaderDelegate {
  MySliverAppBar({
    required this.onTap,
    required this.isVisible,
    required this.count
  });

  final GestureTapCallback onTap;
  final bool isVisible;
  final int count;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent
      ) {
    final double progress = shrinkOffset /(MediaQuery.of(context).size.height / 4);
    final TodoColors todoColors = Theme.of(context).extension<TodoColors>()!;
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).extension<TodoColors>()!.backPrimary,
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB((51 * progress).toInt(), 0, 0, 0),
            spreadRadius: 4,
            offset: const Offset(0, 1),
            blurRadius: 10
          ),
          BoxShadow(
            color: Color.fromARGB((31 * progress).toInt(), 0, 0, 0),
            spreadRadius: 4,
            offset: const Offset(0, 4),
            blurRadius: 5
          ),
          BoxShadow(
            color: Color.fromARGB((36 * progress).toInt(), 0, 0, 0),
            spreadRadius: 4,
            offset: const Offset(0, 2),
            blurRadius: 4
          )
        ]
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(width: 60 - 44 * progress),
          Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                      AppLocalizations.of(context)!.title,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 32 - 12 * shrinkOffset / maxExtent,
                          color: todoColors.labelPrimary
                      )
                  ),
                    Opacity(
                        opacity: 1 - progress,
                        child: Text(
                            "${AppLocalizations.of(context)!.done} — $count",
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: todoColors.labelTertiary
                            )
                        )
                    ),
                  SizedBox(height: 18 - 18 * progress)
                ]
              )
          ),
          Padding(
              padding: const EdgeInsets.only(bottom: 18),
              child: GestureDetector(
                  onTap: onTap,
                  child: Icon(
                      isVisible ? Icons.visibility : Icons.visibility_off,
                      color: todoColors.colorBlue
                  )
              )
          ),
          SizedBox(width: 25.03 - 4.53 * progress)
        ]
      )
    );
  }

  @override
  double get maxExtent => 140;

  @override
  double get minExtent => 64;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}