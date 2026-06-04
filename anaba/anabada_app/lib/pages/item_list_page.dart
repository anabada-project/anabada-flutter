import 'package:flutter/material.dart';

import '../widgets/common/custom_bottom_navigation_bar.dart';
import '../widgets/item_empty_state.dart';
import '../widgets/item_filter_bar.dart';
import '../widgets/item_filter_dropdown.dart';
import '../widgets/item_list_card.dart';
import '../widgets/item_list_count_header.dart';
import '../widgets/item_list_header.dart';
import '../widgets/item_search_field.dart';

enum ItemFilterDropdownType { none, sort, category }

class ItemListPage extends StatefulWidget {
  const ItemListPage({super.key});

  @override
  State<ItemListPage> createState() => _ItemListPageState();
}

class _ItemListPageState extends State<ItemListPage> {
  String selectedSort = '최신순';
  String selectedCategory = '전체';
  ItemFilterDropdownType openedDropdown = ItemFilterDropdownType.none;

  // 빈 상태 화면 확인하려면 true로 바꾸면 됨
  final bool isEmptyState = false;

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
              ItemSearchField(initialText: isEmptyState ? '아나바다' : null),
              const SizedBox(height: 18),
              Expanded(
                child: Stack(
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
                        ItemListCountHeader(totalCount: isEmptyState ? 0 : 123),
                        const SizedBox(height: 18),
                        Expanded(
                          child: isEmptyState
                              ? const ItemEmptyState()
                              : ListView(
                                  padding: EdgeInsets.zero,
                                  children: const [
                                    ItemListCard(
                                      title: '제목',
                                      writer: '작성자',
                                      category: '카테고리',
                                      status: '교환 가능',
                                      time: '3분 전',
                                      isActive: true,
                                    ),
                                    SizedBox(height: 20),
                                    ItemListCard(
                                      title: '제목',
                                      writer: '작성자',
                                      category: '카테고리',
                                      status: '교환 완료',
                                      time: '3분 전',
                                      isActive: false,
                                    ),
                                    SizedBox(height: 20),
                                    ItemListCard(
                                      title: '제목',
                                      writer: '작성자',
                                      category: '카테고리',
                                      status: '나눔 완료',
                                      time: '3분 전',
                                      isActive: false,
                                    ),
                                    SizedBox(height: 20),
                                    ItemListCard(
                                      title: '제목',
                                      writer: '작성자',
                                      category: '카테고리',
                                      status: '나눔 가능',
                                      time: '3분 전',
                                      isActive: true,
                                    ),
                                    SizedBox(height: 20),
                                    ItemListCard(
                                      title: '제목',
                                      writer: '작성자',
                                      category: '카테고리',
                                      status: '교환 가능',
                                      time: '3분 전',
                                      isActive: true,
                                    ),
                                    SizedBox(height: 24),
                                  ],
                                ),
                        ),
                      ],
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
