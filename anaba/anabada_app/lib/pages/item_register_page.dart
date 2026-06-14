import 'package:flutter/material.dart';

import '../controllers/item_register_controller.dart';
import '../widgets/item_register_widgets.dart';

class ItemRegisterPage extends StatefulWidget {
  const ItemRegisterPage({super.key, this.onBack});

  final VoidCallback? onBack;

  @override
  State<ItemRegisterPage> createState() => _ItemRegisterPageState();
}

class _ItemRegisterPageState extends State<ItemRegisterPage> {
  late final ItemRegisterController controller;

  @override
  void initState() {
    super.initState();

    controller = ItemRegisterController();
    controller.addListener(_updateState);
  }

  void _updateState() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    controller.removeListener(_updateState);
    controller.dispose();
    super.dispose();
  }

  void _handleBack() {
    if (widget.onBack != null) {
      widget.onBack!();
      return;
    }

    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  Future<void> _handleRegister() async {
    final bool success = await controller.registerItem();

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('물건이 등록되었습니다.')));
    }
  }

  void _handleBottomNavigationTap(int index) {
    // TODO: 나중에 라우팅 연결
    // 0: 메인페이지
    // 1: 물건 조회
    // 2: 물건 등록
    // 3: 찜
    // 4: 마이페이지
  }

  Widget _buildCategoryButtons() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ItemRegisterSelectButton(
                text: ItemCategory.food.label,
                isSelected: controller.selectedCategory == ItemCategory.food,
                onTap: () {
                  controller.selectCategory(ItemCategory.food);
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ItemRegisterSelectButton(
                text: ItemCategory.clothes.label,
                isSelected: controller.selectedCategory == ItemCategory.clothes,
                onTap: () {
                  controller.selectCategory(ItemCategory.clothes);
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: ItemRegisterSelectButton(
                text: ItemCategory.book.label,
                isSelected: controller.selectedCategory == ItemCategory.book,
                onTap: () {
                  controller.selectCategory(ItemCategory.book);
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ItemRegisterSelectButton(
                text: ItemCategory.etc.label,
                isSelected: controller.selectedCategory == ItemCategory.etc,
                onTap: () {
                  controller.selectCategory(ItemCategory.etc);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTradeMethodButtons() {
    return Row(
      children: [
        Expanded(
          child: ItemRegisterSelectButton(
            text: TradeMethod.exchange.label,
            isSelected: controller.selectedTradeMethod == TradeMethod.exchange,
            onTap: () {
              controller.selectTradeMethod(TradeMethod.exchange);
            },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ItemRegisterSelectButton(
            text: TradeMethod.share.label,
            isSelected: controller.selectedTradeMethod == TradeMethod.share,
            onTap: () {
              controller.selectTradeMethod(TradeMethod.share);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildInputSection({
    required String label,
    required TextEditingController textController,
    required String hintText,
    String? errorText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ItemRegisterLabel(text: label),
        const SizedBox(height: 8),
        ItemRegisterTextField(controller: textController, hintText: hintText),
        ItemRegisterErrorText(text: errorText),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: ItemRegisterAppBar(onBack: _handleBack),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(32, 24, 32, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ItemImagePickerBox(
                image: controller.selectedImage,
                errorText: controller.imageErrorText,
                onTap: controller.pickImage,
              ),
              const SizedBox(height: 36),

              _buildInputSection(
                label: '물건 제목',
                textController: controller.titleController,
                hintText: '물건 제목을 입력해 주세요.',
                errorText: controller.titleErrorText,
              ),
              const SizedBox(height: 28),

              _buildInputSection(
                label: '물건 설명',
                textController: controller.descriptionController,
                hintText: '물건 설명을 입력해 주세요.',
                errorText: controller.descriptionErrorText,
              ),
              const SizedBox(height: 28),

              _buildInputSection(
                label: '희망 교환 물건',
                textController: controller.wantedItemController,
                hintText: '희망 교환 물건을 입력해 주세요.',
              ),
              const SizedBox(height: 32),

              const ItemRegisterLabel(text: '카테고리'),
              const SizedBox(height: 10),
              _buildCategoryButtons(),
              ItemRegisterErrorText(text: controller.categoryErrorText),
              const SizedBox(height: 32),

              const ItemRegisterLabel(text: '거래 방식'),
              const SizedBox(height: 10),
              _buildTradeMethodButtons(),
              ItemRegisterErrorText(text: controller.tradeMethodErrorText),
            ],
          ),
        ),
      ),
      bottomNavigationBar: ItemRegisterBottomArea(
        isRegisterButtonActive: controller.isRegisterButtonActive,
        isLoading: controller.isLoading,
        currentIndex: 2,
        onRegisterTap: _handleRegister,
        onNavigationTap: _handleBottomNavigationTap,
      ),
    );
  }
}
