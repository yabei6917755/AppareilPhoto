#import "SDWebImageCompat.h"
#import "NSData+ImageContentType.h"
@interface UIImage (MultiFormat)
+ (nullable UIImage *)sd_imageWithData:(nullable NSData *)data;
- (nullable NSData *)sd_imageData;
- (nullable NSData *)sd_imageDataAsFormat:(SDImageFormat)imageFormat;
@end
