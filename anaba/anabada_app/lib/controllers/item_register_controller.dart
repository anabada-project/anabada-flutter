import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../models/trade_item.dart';
import '../services/auth_service.dart';
import 'app_controller.dart';

class ItemRegisterController extends ChangeNotifier {
  ItemRegisterController({
    AppController? itemController,
    AuthService? authenticationService,
  }) : _appController = itemController ?? appController,
       _authService = authenticationService ?? authService {
    titleController.addListener(_onInputChanged);
    descriptionController.addListener(_onInputChanged);
    wantedItemController.addListener(_onInputChanged);
  }

  final AppController _appController;
  final AuthService _authService;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController wantedItemController = TextEditingController();

  final ImagePicker _imagePicker = ImagePicker();

  XFile? selectedImage;
  Uint8List? selectedImageBytes;
  ItemCategory? selectedCategory;
  TradeMethod? selectedTradeMethod;

  bool isSubmitted = false;
  bool isLoading = false;
  bool _disposed = false;
  String? createdItemId;

  String? imagePickErrorText;

  bool get hasImage => selectedImage != null && selectedImageBytes != null;

  bool get hasTitle => titleController.text.trim().isNotEmpty;

  bool get hasDescription => descriptionController.text.trim().isNotEmpty;

  bool get hasCategory => selectedCategory != null;

  bool get hasTradeMethod => selectedTradeMethod != null;

  bool get isRegisterButtonActive {
    return hasImage &&
        hasTitle &&
        hasDescription &&
        hasCategory &&
        hasTradeMethod &&
        !isLoading;
  }

  String? get imageErrorText {
    if (imagePickErrorText != null) return imagePickErrorText;
    if (!isSubmitted) return null;
    if (!hasImage) return '사진을 등록해 주세요.';
    return null;
  }

  String? get titleErrorText {
    if (!isSubmitted) return null;
    if (!hasTitle) return '제목을 입력해 주세요.';
    return null;
  }

  String? get descriptionErrorText {
    if (!isSubmitted) return null;
    if (!hasDescription) return '설명을 입력해 주세요.';
    return null;
  }

  String? get categoryErrorText {
    if (!isSubmitted) return null;
    if (!hasCategory) return '카테고리를 선택해 주세요.';
    return null;
  }

  String? get tradeMethodErrorText {
    if (!isSubmitted) return null;
    if (!hasTradeMethod) return '거래 방식을 선택해 주세요.';
    return null;
  }

  Future<void> pickImage() async {
    try {
      imagePickErrorText = null;

      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (_disposed) return;
      if (image == null) return;

      final Uint8List imageBytes = await image.readAsBytes();
      if (_disposed) return;

      selectedImage = image;
      selectedImageBytes = imageBytes;
      imagePickErrorText = null;
      notifyListeners();
    } on PlatformException catch (e) {
      if (_disposed) return;

      imagePickErrorText = '사진을 불러오지 못했습니다.';
      debugPrint('이미지 선택 중 오류 발생: ${e.message}');
      notifyListeners();
    } catch (e) {
      if (_disposed) return;

      imagePickErrorText = '사진을 불러오지 못했습니다.';
      debugPrint('이미지 선택 중 오류 발생: $e');
      notifyListeners();
    }
  }

  void selectCategory(ItemCategory category) {
    selectedCategory = category;
    notifyListeners();
  }

  void selectTradeMethod(TradeMethod tradeMethod) {
    selectedTradeMethod = tradeMethod;
    notifyListeners();
  }

  Future<bool> registerItem() async {
    isSubmitted = true;
    notifyListeners();

    if (!isRegisterButtonActive) {
      return false;
    }

    isLoading = true;
    notifyListeners();

    try {
      final user = _authService.currentUser;
      final imageBytes = selectedImageBytes;
      if (user == null || imageBytes == null) return false;

      final item = await _appController.createItem(
        CreateTradeItemInput(
          title: titleController.text.trim(),
          description: descriptionController.text.trim(),
          wantedItem: wantedItemController.text.trim(),
          category: selectedCategory!,
          tradeMethod: selectedTradeMethod!,
          ownerId: user.id,
          ownerName: user.name,
          ownerGeneration: user.generation,
          imageBytes: imageBytes,
          imagePath: selectedImage?.path,
        ),
      );

      if (_disposed) return false;
      createdItemId = item.id;

      return true;
    } finally {
      if (!_disposed) {
        isLoading = false;
        notifyListeners();
      }
    }
  }

  Map<String, dynamic> toRequestData() {
    return {
      'imagePath': selectedImage?.path,
      'title': titleController.text.trim(),
      'description': descriptionController.text.trim(),
      'wantedItem': wantedItemController.text.trim(),
      'category': selectedCategory?.label,
      'tradeMethod': selectedTradeMethod?.label,
    };
  }

  void _onInputChanged() {
    notifyListeners();
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;

    titleController.removeListener(_onInputChanged);
    descriptionController.removeListener(_onInputChanged);
    wantedItemController.removeListener(_onInputChanged);

    titleController.dispose();
    descriptionController.dispose();
    wantedItemController.dispose();

    super.dispose();
  }
}
