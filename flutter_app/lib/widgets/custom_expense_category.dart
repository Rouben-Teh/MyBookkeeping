import 'package:flutter/material.dart';

class CategoryPage extends StatelessWidget {
  final Function(String) onKeyTap;

  CategoryPage({
    Key? key,
    required this.onKeyTap,
  }) : super(key: key);

  // final List<Map<String, dynamic>> categories = List.generate(36, (index) {
  //   return {
  //     "name": "类别${index + 1}",
  //     "icon": Icons.category,
  //   };
  // });

  final categories = [
    {"name": "餐饮", "icon": Icons.restaurant},
    {"name": "交通", "icon": Icons.directions_car},
    {"name": "购物", "icon": Icons.shopping_bag},
    {"name": "蔬菜", "icon": Icons.local_grocery_store},
    {"name": "娱乐", "icon": Icons.movie},
    {"name": "日常", "icon": Icons.home},
    {"name": "运动", "icon": Icons.fitness_center},
    {"name": "医疗", "icon": Icons.local_hospital},
    {"name": "教育", "icon": Icons.school},
    {"name": "旅行", "icon": Icons.airplanemode_active},
    {"name": "通讯", "icon": Icons.phone},
    {"name": "服饰", "icon": Icons.checkroom},
    {"name": "数码", "icon": Icons.devices},
    {"name": "宠物", "icon": Icons.pets},
    {"name": "礼物", "icon": Icons.card_giftcard},
    {"name": "其他", "icon": Icons.category},
    {"name": "水电", "icon": Icons.flash_on},
    {"name": "房租", "icon": Icons.apartment},
    {"name": "工资", "icon": Icons.attach_money},
    {"name": "投资", "icon": Icons.trending_up},
    {"name": "红包", "icon": Icons.money_off},
    {"name": "彩票", "icon": Icons.confirmation_number},
    {"name": "维修", "icon": Icons.build},
    {"name": "学费", "icon": Icons.school},
    {"name": "保险", "icon": Icons.security},
    {"name": "税务", "icon": Icons.account_balance},
    {"name": "捐赠", "icon": Icons.volunteer_activism},
    {"name": "还款", "icon": Icons.payments},
    {"name": "奖金", "icon": Icons.card_membership},
    {"name": "补贴", "icon": Icons.support},
    {"name": "罚款", "icon": Icons.warning},
    {"name": "红包", "icon": Icons.money_off},
    {"name": "彩票", "icon": Icons.confirmation_number},
    {"name": "维修", "icon": Icons.build},
    {"name": "学费", "icon": Icons.school},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      child: GridView.builder(
        itemCount: categories.length,
        shrinkWrap:
            true, // 👈 allow the grid to size itself inside another scrollable
        // physics:
        //     NeverScrollableScrollPhysics(), // 👈 prevent nested scrolling conflicts
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4, // 一行4个
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.9, // 控制高宽比例
        ),
        itemBuilder: (context, index) {
          final item = categories[index];

          return GestureDetector(
            onTap: () {
              // 👈 return selected category name to parent
              onKeyTap(item["name"] as String);
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 103, 103),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    item["icon"] as IconData,
                    color: const Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  item["name"] as String,
                  style: TextStyle(fontSize: 13),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
