#import <UIKit/UIKit.h>
@interface UIImage (HXExtension)
+ (UIImage *)animatedGIFWithData:(NSData *)data;
- (UIImage *)animatedImageByScalingAndCroppingToSize:(CGSize)size;
- (UIImage *)normalizedImage;
- (UIImage *)clipImage:(CGFloat)scale;
- (UIImage *)scaleImagetoScale:(float)scaleSize;
- (UIImage *)clipNormalizedImage:(CGFloat)scale;
- (UIImage *)fullNormalizedImage;
- (UIImage *)clipLeftOrRightImage:(CGFloat)scale;
@end
