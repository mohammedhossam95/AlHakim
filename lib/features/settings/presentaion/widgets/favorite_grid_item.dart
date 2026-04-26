import 'dart:math';

import 'package:alhakim/config/locale/app_localizations.dart';
import 'package:alhakim/core/services/local_database/favorite_database_helper.dart';
import 'package:alhakim/core/widgets/diff_img.dart';
import 'package:alhakim/core/widgets/gaps.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/values/text_styles.dart';
import '../../../../injection_container.dart';

class FavoriteGridItem extends StatefulWidget {
  final dynamic product;
  final VoidCallback? onFavoriteChanged;

  const FavoriteGridItem(this.product, {super.key, this.onFavoriteChanged});

  @override
  State<FavoriteGridItem> createState() => _FavoriteGridItemState();
}

class _FavoriteGridItemState extends State<FavoriteGridItem> {
  int quantity = 0;
  bool doesItemExist = false;
  bool doesItemInFavorites = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    await doesItemExistInCart();
    await doesItemExistInFavorites();
  }

  Future<void> doesItemExistInCart() async {
    doesItemExist = false;
    // await FavoriteDatabaseHelper.instance
    //     .doesItemExist(widget.product.id ?? -1)
    //     .then((value) async {
    //       if (value) {
    //         final cartItems = await FavoriteDatabaseHelper.instance
    //             .getCartItems();
    //         final item = cartItems.firstWhere(
    //           (item) => item['product_id'] == widget.product.id,
    //           orElse: () => {},
    //         );
    //         if (mounted) {
    //           setState(() {
    //             doesItemExist = value;
    //             quantity = item['quantity'] ?? 1;
    //           });
    //         }
    //       }
    //     });
  }

  Future<void> doesItemExistInFavorites() async {
    final exists = await FavoriteDatabaseHelper.instance.isItemInFavorites(
      widget.product.id ?? -1,
    );
    if (mounted) {
      setState(() {
        doesItemInFavorites = exists;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: colors.secondary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: colors.secondary),
      ),
      child: Padding(
        padding: EdgeInsets.all(8.0.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: colors.whiteColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: DiffImage(
                        image: widget.product.image ?? '',
                        height: 100.h,
                        fitType: BoxFit.fill,
                      ),
                    ),
                    (widget.product.finalPrice != null)
                        ? Positioned(
                            top: 5,
                            right: -20,
                            child: Transform.rotate(
                              angle: pi / 4,
                              origin: const Offset(0, 0),
                              child: Container(
                                width: 80.w,
                                height: 25.h,
                                alignment: Alignment.topCenter,
                                color: colors.errorColor,
                                child: Center(
                                  child: Text(
                                    '${widget.product.finalPrice}%',
                                    style: TextStyles.bold14(
                                      color: colors.whiteColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : SizedBox(),
                    Positioned(
                      top: 5,
                      left: 5,
                      child: IconButton(
                        onPressed: () async {
                          if (doesItemInFavorites) {
                            await FavoriteDatabaseHelper.instance
                                .deleteFavoriteItem(widget.product.id ?? -1);
                          } else {
                            await FavoriteDatabaseHelper.instance
                                .insertFavoriteItem(widget.product);
                          }
                          if (!mounted) return;
                          setState(() {
                            doesItemInFavorites = !doesItemInFavorites;
                          });
                          if (widget.onFavoriteChanged != null) {
                            widget.onFavoriteChanged!();
                          }
                        },
                        icon: (doesItemInFavorites)
                            ? Icon(Icons.favorite, color: colors.main)
                            : Icon(Icons.favorite_outline, color: colors.main),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.product.name ?? '',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyles.bold14(),
                ),
                Gaps.vGap5,
                // Text(
                //   widget.product.category?.name ?? '',
                //   style: TextStyles.regular13(color: colors.lightTextColor),
                //   overflow: TextOverflow.ellipsis,
                // ),
                Row(
                  children: [
                    Text(
                      (widget.product.oldPrice != null)
                          ? '${widget.product.finalPrice ?? 0} ${'egp'.tr}'
                          : '${widget.product.finalPrice ?? 0} ${'egp'.tr}',
                      style: TextStyles.bold14(color: colors.main),
                    ),
                    Gaps.hGap4,
                    (widget.product.oldPrice != null)
                        ? Text(
                            '${widget.product.finalPrice ?? 0} ${'egp'.tr}',
                            overflow: TextOverflow.fade,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: colors.lightTextColor,
                              decoration: TextDecoration.lineThrough,
                            ),
                          )
                        : SizedBox(),
                  ],
                ),
                Gaps.vGap4,
                SizedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Row(children: [])),
                      ElasticInDown(
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: (quantity > 0)
                              ? buildIncrementalContainerForCart()
                              : InkWell(
                                  onTap: () async {
                                    // setState(() {
                                    //   ++quantity;
                                    // });
                                    // await DatabaseHelper.instance
                                    //     .insertCartItem(
                                    //       widget.product,
                                    //       quantity: quantity,
                                    //     )
                                    //     .then((value) async {
                                    //       if (mounted) {
                                    //         doesItemExist = true;
                                    //       }
                                    //       await CountCartItemsCubit.get(
                                    //         context,
                                    //       ).loadCartItemsCount();
                                    //     });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10.w,
                                    ),
                                    height: 35.h,
                                    decoration: BoxDecoration(
                                      color: colors.main,
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                    child: Text(
                                      '${'add'.tr} ${widget.product.name ?? 'شرنك'}',
                                      style: TextStyle(
                                        color: colors.whiteColor,
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildIncrementalContainerForCart() {
    return ElasticInUp(
      child: Container(
        height: 35.h,
        decoration: BoxDecoration(
          color: colors.main,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(Icons.add, color: colors.whiteColor),
              onPressed: () async {
                // setState(() {
                //   ++quantity;
                // });
                // DatabaseHelper.instance
                //     .updateCartItemQuantity(widget.product.id ?? -1, quantity)
                //     .then((value) {
                //       if (mounted) {
                //         CountCartItemsCubit.get(context).loadCartItemsCount();
                //       }
                //     });
              },
            ),
            Text(
              '$quantity',
              style: TextStyles.bold14(color: colors.whiteColor),
            ),
            IconButton(
              icon: Icon(Icons.remove, color: colors.whiteColor),
              onPressed: () async {
                // setState(() {
                //   --quantity;
                // });
                // if (quantity == 0) {
                //   DatabaseHelper.instance
                //       .deleteCartItem(widget.product.id ?? -1)
                //       .then((value) {
                //         if (mounted) {
                //           CountCartItemsCubit.get(context).loadCartItemsCount();
                //         }
                //       });
                // } else {
                //   DatabaseHelper.instance
                //       .updateCartItemQuantity(widget.product.id ?? -1, quantity)
                //       .then((value) {
                //         if (mounted) {
                //           CountCartItemsCubit.get(context).loadCartItemsCount();
                //         }
                //       });
                // }
              },
            ),
          ],
        ),
      ),
    );
  }
}
