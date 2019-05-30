#import <Foundation/Foundation.h>
#import "SDWebImageCompat.h"
@interface UIImage (ForceDecode)
+ (nullable UIImage *)decodedImageWithImage:(nullable UIImage *)image;
+ (nullable UIImage *)decodedAndScaledDownImageWithImage:(nullable UIImage *)image;
@end
