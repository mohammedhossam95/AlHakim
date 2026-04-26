// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:alhakim/config/locale/app_localizations.dart';
// import 'package:alhakim/core/services/local_database/favorite_database_helper.dart';
// import 'package:alhakim/core/utils/values/text_styles.dart';
// import 'package:alhakim/core/widgets/back_button.dart';
// import 'package:alhakim/core/widgets/gaps.dart';
// import 'package:alhakim/core/widgets/no_data_found.dart';
// import 'package:alhakim/features/settings/presentaion/widgets/favorite_grid_item.dart';

// class FavoritesScreen extends StatefulWidget {
//   const FavoritesScreen({super.key});

//   @override
//   State<FavoritesScreen> createState() => _FavoritesScreenState();
// }

// class _FavoritesScreenState extends State<FavoritesScreen> {
//   final FavoriteDatabaseHelper favoriteDatabaseHelper =
//       FavoriteDatabaseHelper.instance;

//   List<dynamic> favoriteList = [];
//   bool isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     loadFavorites();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       //appBar: AppBar(title: Text('favorites'.tr,style: TextStyles.bold16())),
//       body: RefreshIndicator(
//         onRefresh: loadFavorites,
//         child: SafeArea(
//           child: Column(
//             children: [
//               Padding(
//                 padding: EdgeInsets.all(10.0.r),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     CustomBackButton(),
//                     Gaps.hGap10,
//                     Text('favorites'.tr, style: TextStyles.bold20()),
//                   ],
//                 ),
//               ),
//               Gaps.vGap12,
//               isLoading
//                   ? const Center(child: CircularProgressIndicator())
//                   : favoriteList.isNotEmpty
//                   ? Padding(
//                       padding: EdgeInsets.all(8.0.r),
//                       child: GridView.builder(
//                         shrinkWrap: true,
//                         itemCount: favoriteList.length,
//                         gridDelegate:
//                             const SliverGridDelegateWithFixedCrossAxisCount(
//                               crossAxisCount: 2,
//                               crossAxisSpacing: 10,
//                               mainAxisSpacing: 12,
//                               childAspectRatio: 0.70,
//                             ),
//                         itemBuilder: (context, index) {
//                           final product = favoriteList[index];
//                           return FavoriteGridItem(
//                             product,
//                             onFavoriteChanged: () {
//                               loadFavorites();
//                             },
//                           );
//                         },
//                       ),
//                     )
//                   : Center(child: NoDataFound(text: 'no_favorites'.tr)),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> loadFavorites() async {
//     setState(() => isLoading = true);

//     final dbFavoritesItems = await favoriteDatabaseHelper.getAllFavoriteItems();

//     setState(() {
//       log('inside set state: $dbFavoritesItems');

//       // favoriteList = dbFavoritesItems.map((item) {
//       //   return ProductModel(
//       //     id: item["product_id"] ?? 0,
//       //     name: item["name"]?.toString() ?? '',
//       //     image: item["image"]?.toString() ?? '',
//       //     finalPrice: item["final_price"]?.toDouble() ?? 0.0,
//       //     oldPrice: item["old_price"]?.toDouble() ?? 0.0,
//       //     weight: item["weight"]?.toInt() ?? 0,
//       //     quantity: item["quantity"]?.toInt() ?? 0,
//       //     description: item["description"]?.toString() ?? '',
//       //   );
//       // }).toList();

//       log('favoriteList: $favoriteList');
//       isLoading = false;
//     });

//     log('out of setState');
//   }
// }
