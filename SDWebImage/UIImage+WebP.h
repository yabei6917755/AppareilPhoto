#ifdef SD_WEBP
#import "SDWebImageCompat.h"
@interface UIImage (WebP)
+ (nullable UIImage *)sd_imageWithWebPData:(nullable NSData *)data;
@end
#endif
