#import "SDWebImageCompat.h"
@interface UIImage (GIF)
+ (UIImage *)sd_animatedGIFWithData:(NSData *)data;
- (BOOL)isGIF;
@end
