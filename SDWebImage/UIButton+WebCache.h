#import "SDWebImageCompat.h"
#if SD_UIKIT
#import "SDWebImageManager.h"
@interface UIButton (WebCache)
- (nullable NSURL *)sd_currentImageURL;
#pragma mark - Image
- (nullable NSURL *)sd_imageURLForState:(UIControlState)state;
- (void)sd_setImageWithURL:(nullable NSURL *)url
                  forState:(UIControlState)state NS_REFINED_FOR_SWIFT;
- (void)sd_setImageWithURL:(nullable NSURL *)url
                  forState:(UIControlState)state
          placeholderImage:(nullable UIImage *)placeholder NS_REFINED_FOR_SWIFT;
- (void)sd_setImageWithURL:(nullable NSURL *)url
                  forState:(UIControlState)state
          placeholderImage:(nullable UIImage *)placeholder
                   options:(SDWebImageOptions)options NS_REFINED_FOR_SWIFT;
- (void)sd_setImageWithURL:(nullable NSURL *)url
                  forState:(UIControlState)state
                 completed:(nullable SDExternalCompletionBlock)completedBlock;
- (void)sd_setImageWithURL:(nullable NSURL *)url
                  forState:(UIControlState)state
          placeholderImage:(nullable UIImage *)placeholder
                 completed:(nullable SDExternalCompletionBlock)completedBlock NS_REFINED_FOR_SWIFT;
- (void)sd_setImageWithURL:(nullable NSURL *)url
                  forState:(UIControlState)state
          placeholderImage:(nullable UIImage *)placeholder
                   options:(SDWebImageOptions)options
                 completed:(nullable SDExternalCompletionBlock)completedBlock;
#pragma mark - Background image
- (void)sd_setBackgroundImageWithURL:(nullable NSURL *)url
                            forState:(UIControlState)state NS_REFINED_FOR_SWIFT;
- (void)sd_setBackgroundImageWithURL:(nullable NSURL *)url
                            forState:(UIControlState)state
                    placeholderImage:(nullable UIImage *)placeholder NS_REFINED_FOR_SWIFT;
- (void)sd_setBackgroundImageWithURL:(nullable NSURL *)url
                            forState:(UIControlState)state
                    placeholderImage:(nullable UIImage *)placeholder
                             options:(SDWebImageOptions)options NS_REFINED_FOR_SWIFT;
- (void)sd_setBackgroundImageWithURL:(nullable NSURL *)url
                            forState:(UIControlState)state
                           completed:(nullable SDExternalCompletionBlock)completedBlock;
- (void)sd_setBackgroundImageWithURL:(nullable NSURL *)url
                            forState:(UIControlState)state
                    placeholderImage:(nullable UIImage *)placeholder
                           completed:(nullable SDExternalCompletionBlock)completedBlock NS_REFINED_FOR_SWIFT;
- (void)sd_setBackgroundImageWithURL:(nullable NSURL *)url
                            forState:(UIControlState)state
                    placeholderImage:(nullable UIImage *)placeholder
                             options:(SDWebImageOptions)options
                           completed:(nullable SDExternalCompletionBlock)completedBlock;
#pragma mark - Cancel
- (void)sd_cancelImageLoadForState:(UIControlState)state;
- (void)sd_cancelBackgroundImageLoadForState:(UIControlState)state;
@end
#endif
