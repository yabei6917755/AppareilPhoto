#import <UIKit/UIKit.h>
@interface UIView (HXExtension)
@property (assign, nonatomic) CGFloat hx_x;
@property (assign, nonatomic) CGFloat hx_y;
@property (assign, nonatomic) CGFloat hx_w;
@property (assign, nonatomic) CGFloat hx_h;
@property (assign, nonatomic) CGSize hx_size;
@property (assign, nonatomic) CGPoint hx_origin;
- (UIViewController*)viewController;
- (void)showImageHUDText:(NSString *)text;
- (void)showLoadingHUDText:(NSString *)text;
- (void)handleLoading;
@end
@interface HXHUD : UIView
- (instancetype)initWithFrame:(CGRect)frame imageName:(NSString *)imageName text:(NSString *)text;
- (void)showloading;
@end
