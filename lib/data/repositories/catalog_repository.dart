import '../../core/network/api_client.dart';
import '../../core/network/result.dart';
import '../models/capsule_collection.dart';
import '../models/json_utils.dart';
import '../models/lookbook_story.dart';
import '../models/product_model.dart';
import 'repository_guard.dart';

/// Read access to the shop catalogue and home-screen content.
///
/// The single source of truth for products: controllers load through it and
/// never touch the [ApiClient] or raw JSON directly. Every method returns a
/// [Result] instead of throwing.
class CatalogRepository {
  const CatalogRepository(this._api);

  final ApiClient _api;

  /// All products (`GET /products`).
  Future<Result<List<Product>>> fetchProducts() => guardRequest(
        'the catalogue',
        () async => asJsonList(await _api.get('/products'), '/products').map(Product.fromJson).toList(),
      );

  /// A single product by [id] (`GET /products/{id}`).
  Future<Result<Product>> fetchProduct(String id) => guardRequest(
        'product $id',
        () async => Product.fromJson(asJsonMap(await _api.get('/products/${Uri.encodeComponent(id)}'), '/products/$id')),
      );

  /// Story bubbles for the home screen (`GET /home/stories`).
  Future<Result<List<LookbookStory>>> fetchStories() => guardRequest(
        'stories',
        () async => asJsonList(await _api.get('/home/stories'), '/home/stories').map(LookbookStory.fromJson).toList(),
      );

  /// Hero campaign banners for the home screen (`GET /home/campaigns`).
  Future<Result<List<CapsuleCollection>>> fetchCampaigns() => guardRequest(
        'campaigns',
        () async =>
            asJsonList(await _api.get('/home/campaigns'), '/home/campaigns').map(CapsuleCollection.fromJson).toList(),
      );
}
