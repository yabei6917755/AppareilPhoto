#import <UIKit/UIKit.h>
@interface UIImage (Rotate)
- (UIImage *)fixOrientation;
- (UIImage*)rotate:(UIImageOrientation)orient;
- (UIImage *)flipVertical;
- (UIImage *)flipHorizontal;
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;
- (UIImage *)imageRotatedByRadians:(CGFloat)radians;
@end
