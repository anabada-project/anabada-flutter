import 'package:flutter/material.dart';

import '../controllers/app_controller.dart';
import '../models/trade_item.dart';
import '../utils/time_formatter.dart';
import '../widgets/common/custom_bottom_navigation_bar.dart';
import '../widgets/item_empty_state.dart';
import '../widgets/item_filter_bar.dart';
import '../widgets/item_filter_dropdown.dart';
import '../widgets/item_list_card.dart';
import '../widgets/item_list_count_header.dart';
import '../widgets/item_list_header.dart';
import '../widgets/item_search_field.dart';
import 'item_detail_page.dart';

enum ItemFilterDropdownType { none, sort, category }

class ItemListPage extends StatefulWidget {
  const ItemListPage({super.key});

  @override
  State<ItemListPage> createState() => _ItemListPageState();
}

class _ItemListPageState extends State<ItemListPage> {
  String selectedSort = '최신순';
  String selectedCategory = '전체';
  String searchQuery = '';
  ItemFilterDropdownType openedDropdown = ItemFilterDropdownType.none;

  void _toggleSortDropdown() {
    setState(() {
      openedDropdown = openedDropdown == ItemFilterDropdownType.sort
          ? ItemFilterDropdownType.none
          : ItemFilterDropdownType.sort;
    });
  }

  void _toggleCategoryDropdown() {
    setState(() {
      openedDropdown = openedDropdown == ItemFilterDropdownType.category
          ? ItemFilterDropdownType.none
          : ItemFilterDropdownType.category;
    });
  }

  void _closeDropdown() {
    setState(() {
      openedDropdown = ItemFilterDropdownType.none;
    });
  }

  void _selectSort(String value) {
    setState(() {
      selectedSort = value;
      openedDropdown = ItemFilterDropdownType.none;
    });
  }

  void _selectCategory(String value) {
    setState(() {
      selectedCategory = value;
      openedDropdown = ItemFilterDropdownType.none;
    });
  }

  void _handleSearchChanged(String value) {
    setState(() {
      searchQuery = value.trim().toLowerCase();
    });
  }

  void _handleSearchSubmitted(String value) {
    _handleSearchChanged(value);
  }

  List<TradeItem> _filteredItems() {
    final List<TradeItem> items = appController.items.where((item) {
      final bool matchesCategory =
          selectedCategory == '전체' ||
          item.category.label == selectedCategory;
      final bool matchesSearch =
          searchQuery.isEmpty ||
          item.title.toLowerCase().contains(searchQuery) ||
          item.description.toLowerCase().contains(searchQuery) ||
          item.ownerName.toLowerCase().contains(searchQuery);

      return matchesCategory && matchesSearch;
    }).toList();

    if (selectedSort == '인기순') {
      items.sort((a, b) {
        final int likeComparison = b.likeCount.compareTo(a.likeCount);
        return likeComparison != 0
            ? likeComparison
            : b.createdAt.compareTo(a.createdAt);
      });
    } else {
      items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: const CustomBottomNavigationBar(currentIndex: 1),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              const ItemListHeader(),
              const SizedBox(height: 12),
              ItemSearchField(
                onChanged: _handleSearchChanged,
                onSubmitted: _handleSearchSubmitted,
              ),
              const SizedBox(height: 18),
              Expanded(
                child: AnimatedBuilder(
                  animation: appController,
                  builder: (context, child) {
                    final List<TradeItem> items = _filteredItems();

                    return Stack(
                      children: [
                        Column(
                          children: [
                        ItemFilterBar(
                          selectedSort: selectedSort,
                          selectedCategory: selectedCategory,
                          onSortTap: _toggleSortDropdown,
                          onCategoryTap: _toggleCategoryDropdown,
                        ),
                        const SizedBox(height: 24),
                        ItemListCountHeader(totalCount: items.length),
                        const SizedBox(height: 18),
                        Expanded(
                          child: items.isEmpty
                              ? const ItemEmptyState()
                              : ListView.builder(
                                  padding: EdgeInsets.zero,
                                  itemCount: items.length,
                                  itemBuilder: (context, index) {
                                    final TradeItem item = items[index];

                                    return Padding(
                                      padding: EdgeInsets.only(
                                        bottom: index == items.length - 1
                                            ? 24
                                            : 20,
                                      ),
                                      child: ItemListCard(
                                        item: item,
                                        time: formatRelativeTime(item.createdAt),
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  ItemDetailPage(itemId: item.id),
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                ),
                        ),
                          ],
                        ),
                        if (openedDropdown != ItemFilterDropdownType.none)
                          Positioned.fill(
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: _closeDropdown,
                              child: const SizedBox.expand(),
                            ),
                          ),
                        if (openedDropdown == ItemFilterDropdownType.sort)
                          Positioned(
                            top: 28,
                            left: 0,
                            child: ItemFilterDropdown(
                              width: 160,
                              items: const ['최신순', '인기순'],
                              selectedItem: selectedSort,
                              onSelected: _selectSort,
                            ),
                          ),
                        if (openedDropdown == ItemFilterDropdownType.category)
                          Positioned(
                            top: 28,
                            right: 0,
                            child: ItemFilterDropdown(
                              width: 160,
                              items: const ['전체', '식품', '의류', '도서', '기타'],
                              selectedItem: selectedCategory,
                              onSelected: _selectCategory,
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
