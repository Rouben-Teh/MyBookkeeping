import 'package:flutter/material.dart';
import 'package:my_bookkeeping/enum/enum.dart';

class CategoryPage extends StatefulWidget {
  final ScrollController scrollController;
  final String selectedCategory;
  final Function(String) onKeyTap;
  final int? jumpItemIndex;

  CategoryPage({
    Key? key,
    required this.scrollController,
    required this.selectedCategory,
    required this.onKeyTap,
    this.jumpItemIndex,
  }) : super(key: key);

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  // final List<Map<String, dynamic>> categories = List.generate(36, (index) {
  //   return {
  //     "name": "类别${index + 1}",
  //     "icon": Icons.category,
  //   };
  // });

  final double itemHeight = 95;

  void jumpItem(int index) {
    int row = index ~/ 4;

    widget.scrollController.jumpTo(
      row * itemHeight,
    );
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.jumpItemIndex != null) {
        jumpItem(widget.jumpItemIndex!);
      }
    });
  }

  void _scrollToItem(int index) {
    int row = index ~/ 4;

    widget.scrollController.animateTo(
      row * itemHeight,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<GlobalKey> itemKeys =
        List.generate(categories.length, (_) => GlobalKey());

    // void _scrollToItem(int index) {
    //   final context = itemKeys[index].currentContext;
    //   if (context != null) {
    //     print(
    //         "Scrolling to item: ${categories[index]['name']} at index $index");

    //     Scrollable.ensureVisible(
    //       context,
    //       duration: Duration(milliseconds: 1000),
    //       alignment: 0.95,
    //     );
    //   }
    // }

    return Container(
      padding: EdgeInsets.all(12),
      child: GridView.builder(
        controller: widget.scrollController,
        itemCount: categories.length,
        // shrinkWrap:
        //     true, // 👈 allow the grid to size itself inside another scrollable
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
            key: itemKeys[index],
            onTap: () {
              // 👈 return selected category name to parent
              widget.onKeyTap(item['name'] as String);

              _scrollToItem(index);
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: widget.selectedCategory == item['name']
                        ? const Color.fromARGB(255, 255, 103, 103)
                        : const Color.fromARGB(255, 255, 195, 195),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    item['icon'] as IconData,
                    color: const Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  item['name'] as String,
                  style: TextStyle(fontSize: 10),
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
