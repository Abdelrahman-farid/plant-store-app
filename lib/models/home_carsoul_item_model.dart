class HomeCarouselItemModel {
  final String id;
  final String imgUrl;

  HomeCarouselItemModel({
    required this.id,
    required this.imgUrl,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'id': id});
    result.addAll({'imgUrl': imgUrl});
  
    return result;
  }

  factory HomeCarouselItemModel.fromMap(Map<String, dynamic> map) {
    return HomeCarouselItemModel(
      id: map['id'] ?? '',
      imgUrl: map['imgUrl'] ?? '',
    );
  }
}

List<HomeCarouselItemModel> dummyHomeCarouselItems = [
  HomeCarouselItemModel(
    id: 'jf385EsSP2RzdIKucgW7',
    imgUrl: 'https://placehold.co/1200x400/png?text=Promo+1',
  ),
  HomeCarouselItemModel(
    id: 'btgMW23JED1zRsxqdKms',
    imgUrl: 'https://placehold.co/1200x400/png?text=Promo+2',
  ),
  HomeCarouselItemModel(
    id: 'XjZBor795dLTO2ErQGi3',
    imgUrl: 'https://placehold.co/1200x400/png?text=Promo+3',
  ),
  HomeCarouselItemModel(
    id: '8u3jP9mBZYVSGq7JGoc6',
    imgUrl: 'https://placehold.co/1200x400/png?text=Promo+4',
  ),
];