class HomeNews {
  final String id;
  final String catId;
  final String newsType;
  final String newsTitle;
  final String videoUrl;
  final String videoId;
  final String newsImageB;
  final String newsImageS;
  final String newsDescription;
  final String newsDate;
  final String newsViews;
  final String cid;
  final String categoryName;
  final String categoryImage;
  final String categoryImageThumb;

  HomeNews({
    this.id,
    this.catId,
    this.newsType,
    this.newsTitle,
    this.videoUrl,
    this.videoId,
    this.newsImageB,
    this.newsImageS,
    this.newsDescription,
    this.newsDate,
    this.newsViews,
    this.cid,
    this.categoryName,
    this.categoryImage,
    this.categoryImageThumb,
  });

  factory HomeNews.fromJson(Map<String, dynamic> json) {
    return HomeNews(
      id: json['id'] as String,
      catId: json['cat_id'] as String,
      newsType: json['news_type'] as String,
      newsTitle: json['news_title'] as String,
      videoUrl: json['video_url'] as String,
      videoId: json['video_id'] as String,
      newsImageB: json['news_image_b'] as String,
      newsImageS: json['news_image_s'] as String,
      newsDescription: json['news_description'] as String,
      newsDate: json['news_date'] as String,
      newsViews: json['news_views'] as String,
      cid: json['cid'] as String,
      categoryName: json['category_name'] as String,
      categoryImage: json['category_image'] as String,
      categoryImageThumb: json['category_image_thumb'] as String,
    );
  }
}
