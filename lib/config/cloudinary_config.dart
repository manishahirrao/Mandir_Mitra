class CloudinaryConfig {
  // TODO: Replace with your Cloudinary credentials
  static const String cloudName = 'YOUR_CLOUD_NAME';
  static const String uploadPreset = 'mandir_mitra_unsigned';
  static const String apiKey = 'YOUR_API_KEY';
  
  // Folders for different types of uploads
  static const String ritualsFolder = 'mandir-mitra/rituals';
  static const String profilesFolder = 'mandir-mitra/profiles';
  static const String reviewsFolder = 'mandir-mitra/reviews';
  static const String templesFolder = 'mandir-mitra/temples';
  static const String blogsFolder = 'mandir-mitra/blogs';
  static const String videosFolder = 'mandir-mitra/videos';
  
  // Image transformations
  static const String thumbnailTransform = 'w_300,h_300,c_fill,q_auto,f_auto';
  static const String mediumTransform = 'w_800,h_600,c_fill,q_auto,f_auto';
  static const String largeTransform = 'w_1200,h_900,c_fill,q_auto,f_auto';
}
