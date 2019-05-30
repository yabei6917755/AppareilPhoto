#import "SDWebImageCompat.h"
#if SD_UIKIT || SD_MAC
#import "SDWebImageManager.h"
typedef void(^SDSetImageBlock)(UIImage * _Nullable image, NSData * _Nullable imageData);
@interface UIView (WebCache)
- (nullable NSURL *)sd_imageURL;
- (void)sd_internalSetImageWithURL:(nullable NSURL *)url
                  placeholderImage:(nullable UIImage *)placeholder
                           options:(SDWebImageOptions)options
                      operationKey:(nullable NSString *)operationKey
                     setImageBlock:(nullable SDSetImageBlock)setImageBlock
                          progress:(nullable SDWebImageDownloaderProgressBlock)progressBlock
                         completed:(nullable SDExternalCompletionBlock)completedBlock;
- (void)sd_cancelCurrentImageLoad;
#if SD_UIKIT
#pragma mark - Activity indicator
- (void)sd_setShowActivityIndicatorView:(BOOL)show;
- (void)sd_setIndicatorStyle:(UIActivityIndicatorViewStyle)style;
- (BOOL)sd_showActivityIndicatorView;
- (void)sd_addActivityIndicator;
- (void)sd_removeActivityIndicator;
#endif
@end
#endif
