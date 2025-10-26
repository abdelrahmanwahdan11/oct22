import '../models/store_product.dart';

class StoreRepository {
  StoreRepository() {
    _seed();
  }

  final List<StoreProduct> _items = [];

  void _seed() {
    _items.addAll([
      StoreProduct(
        id: 'prod_protein',
        name: 'Plant Power Protein',
        description: 'بروتين نباتي معزز بالبريبايوتيك لدعم التعافي والهضم الصحي.',
        category: 'المكملات',
        price: 179,
        image: 'https://images.unsplash.com/photo-1599458252575-60045943cb8b',
        tags: const ['نباتي', 'تعافي', 'فانيلا'],
        rating: 4.8,
        reviewsCount: 321,
        isBestSeller: true,
      ),
      StoreProduct(
        id: 'prod_bcaas',
        name: 'Citrus BCAA Splash',
        description: 'أحماض أمينية متفرعة بسعرات منخفضة مع إلكتروليتات.',
        category: 'المكملات',
        price: 129,
        image: 'https://images.unsplash.com/photo-1615485290382-425c2d9823b1',
        tags: const ['طاقة', 'رياضي', 'إلكتروليت'],
        rating: 4.6,
        reviewsCount: 201,
        isBestSeller: false,
      ),
      StoreProduct(
        id: 'prod_dumbbells',
        name: 'NeoGrip Dumbbells Set',
        description: 'مجموعة دمبلز قابلة للتعديل بقبضة مريحة وتغطية ناعمة.',
        category: 'معدات التدريب',
        price: 549,
        image: 'https://images.unsplash.com/photo-1579758682665-53fe8a38092f',
        tags: const ['قوة', 'منزل', 'HIIT'],
        rating: 4.9,
        reviewsCount: 119,
        isBestSeller: true,
      ),
      StoreProduct(
        id: 'prod_matyoga',
        name: 'CloudFlow Yoga Mat',
        description: 'سجادة يوغا مبطنة مضادة للانزلاق مع خطوط محاذاة.',
        category: 'معدات التدريب',
        price: 249,
        image: 'https://images.unsplash.com/photo-1593810450967-f9c42742e326',
        tags: const ['يوغا', 'تأمل', 'مساج'],
        rating: 4.7,
        reviewsCount: 264,
        isBestSeller: false,
      ),
      StoreProduct(
        id: 'prod_deodorant',
        name: 'Active Breeze Deodorant',
        description: 'مزيل عرق طبيعي يدوم 48 ساعة مع تركيبة مرطبة.',
        category: 'العناية الشخصية',
        price: 69,
        image: 'https://images.unsplash.com/photo-1506126613408-eca07ce68773',
        tags: const ['طبيعي', 'بدون ألومنيوم'],
        rating: 4.4,
        reviewsCount: 98,
        isBestSeller: false,
      ),
      StoreProduct(
        id: 'prod_shampoo',
        name: 'Revive Post-Workout Shampoo',
        description: 'شامبو منعش بزيوت النعناع واللافندر لإزالة العرق والملوثات.',
        category: 'العناية الشخصية',
        price: 82,
        image: 'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b',
        tags: const ['انتعاش', 'مناسب للتمارين'],
        rating: 4.5,
        reviewsCount: 164,
        isBestSeller: false,
      ),
    ]);
  }

  Future<List<StoreProduct>> fetchProducts() async {
    await Future.delayed(const Duration(milliseconds: 280));
    return List.unmodifiable(_items);
  }
}
