part of 'api.dart';

class _MenuItemManagement {
  Future<MenuItemListPage> getMenuItemListPage({
    required int page,
    MenuItemCategory? category,
    required String searchTerm,
  }) async {
    try {
      final response = await _dio.get(
        '/api/menu-items',
        queryParameters: {
          if (searchTerm.isNotEmpty) 'search': searchTerm,
          if (category != null) 'category': category.name,
        },
      );
      var data = response.data as List;
      return (data.isEmpty)
          ? const MenuItemListPage(isLastPage: true, productList: [])
          : MenuItemListPage(
              isLastPage: true,
              productList: data.map((e) => MenuItem.fromJson(e)).toList(),
            );
    } on DioException catch (e) {
      throw _handleExecptionsForGetMethod(e);
    }
  }

  Future<MenuItem> getMenuItemDetails(int id) async {
    try {
      final response = await _dio.get('/api/menu-items/$id');
      return MenuItem.fromJson(response.data);
    } on DioException catch (_) {
      rethrow;
    }
  }
}
