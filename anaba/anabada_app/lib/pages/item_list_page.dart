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

  // 빈 상태 화면 확인: true
  // 기본 목록 화면 확인: false
  static const bool _showEmptyStatePreview = false;

  static const List<_ItemListData> _dummyItems = [
    _ItemListData(
      title: '제목',
      writer: '작성자',
      category: '카테고리',
      status: '교환 가능',
      time: '3분 전',
      isActive: true,
    ),
    _ItemListData(
      title: '제목',
      writer: '작성자',
      category: '카테고리',
      status: '교환 완료',
      time: '3분 전',
      isActive: false,
    ),
    _ItemListData(
      title: '제목',
      writer: '작성자',
      category: '카테고리',
      status: '나눔 완료',
      time: '3분 전',
      isActive: false,
    ),
    _ItemListData(
      title: '제목',
      writer: '작성자',
      category: '카테고리',
      status: '나눔 가능',
      time: '3분 전',
      isActive: true,
    ),
    _ItemListData(
      title: '제목',
      writer: '작성자',
      category: '카테고리',
      status: '교환 가능',
      time: '3분 전',
      isActive: true,
    ),
  ];

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
    // 검색 기능은 추후 API/기능 연결 단계에서 구현
  }

  void _handleSearchSubmitted(String value) {
    // 검색 기능은 추후 API/기능 연결 단계에서 구현
  }

  @override
  Widget build(BuildContext context) {
    final List<_ItemListData> items = _showEmptyStatePreview
        ? const []
        : _dummyItems;

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
                initialText: _showEmptyStatePreview ? '아나바다' : null,
                onChanged: _handleSearchChanged,
                onSubmitted: _handleSearchSubmitted,
              ),
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
                        ItemListCountHeader(totalCount: items.length),
                        const SizedBox(height: 18),
                        Expanded(
                          child: items.isEmpty
                              ? const ItemEmptyState()
                              : ListView.builder(
                                  padding: EdgeInsets.zero,
                                  itemCount: items.length,
                                  itemBuilder: (context, index) {
                                    final item = items[index];

                                    return Padding(
                                      padding: EdgeInsets.only(
                                        bottom: index == items.length - 1
                                            ? 24
                                            : 20,
                                      ),
                                      child: ItemListCard(
                                        title: item.title,
                                        writer: item.writer,
                                        category: item.category,
                                        status: item.status,
                                        time: item.time,
                                        isActive: item.isActive,
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ItemListData {
  final String title;
  final String writer;
  final String category;
  final String status;
  final String time;
  final bool isActive;

  const _ItemListData({
    required this.title,
    required this.writer,
    required this.category,
    required this.status,
    required this.time,
    required this.isActive,
  });
}
