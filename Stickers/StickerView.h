#import <UIKit/UIKit.h>
#import "UIView+Frame.h"
#import "UIImage+Utility.h"
#import "CircleView.h"
@class StickerView;
@protocol StickerViewDelegate <NSObject>
-(void)willDeleteStickerView:(StickerView*)sv;
@end
@interface StickerView : UIView
@property (nonatomic, assign) id<StickerViewDelegate> delegate;
+ (void)setActiveStickerView:(StickerView*)view;
- (UIImageView*)imageView;
- (id)initWithImage:(UIImage *)image;
- (void)setScale:(CGFloat)scale;
- (void)setScale:(CGFloat)scaleX andScaleY:(CGFloat)scaleY;
@end
