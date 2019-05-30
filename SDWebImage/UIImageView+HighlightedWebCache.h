#import "SDWebImageCompat.h"
#if SD_UIKIT
#import "SDWebImageManager.h"
@interface UIImageView (HighlightedWebCache)
- (void)sd_setHighlightedImageWithURL:(nullable NSURL *)url NS_REFINED_FOR_SWIFT;
- (void)sd_setHighlightedImageWithURL:(nullable NSURL *)url
                              options:(SDWebImageOptions)options NS_REFINED_FOR_SWIFT;
- (void)sd_setHighlightedImageWithURL:(nullable NSURL *)url
                            completed:(nullable SDExternalCompletionBlock)completedBlock NS_REFINED_FOR_SWIFT;
- (void)sd_setHighlightedImageWithURL:(nullable NSURL *)url
                              options:(SDWebImageOptions)options
                            completed:(nullable SDExternalCompletionBlock)completedBlock;
- (void)sd_setHighlightedImageWithURL:(nullable NSURL *)url
                              options:(SDWebImageOptions)options
                             progress:(nullable SDWebImageDownloaderProgressBlock)progressBlock
                            completed:(nullable SDExternalCompletionBlock)completedBlock;
@end
#endif
