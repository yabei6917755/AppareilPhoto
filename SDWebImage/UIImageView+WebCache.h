#import "SDWebImageCompat.h"
#if SD_UIKIT || SD_MAC
#import "SDWebImageManager.h"
@interface UIImageView (WebCache)
- (void)sd_setImageWithURL:(nullable NSURL *)url NS_REFINED_FOR_SWIFT;
- (void)sd_setImageWithURL:(nullable NSURL *)url
          placeholderImage:(nullable UIImage *)placeholder NS_REFINED_FOR_SWIFT;
- (void)sd_setImageWithURL:(nullable NSURL *)url
          placeholderImage:(nullable UIImage *)placeholder
                   options:(SDWebImageOptions)options NS_REFINED_FOR_SWIFT;
- (void)sd_setImageWithURL:(nullable NSURL *)url
                 completed:(nullable SDExternalCompletionBlock)completedBlock;
- (void)sd_setImageWithURL:(nullable NSURL *)url
          placeholderImage:(nullable UIImage *)placeholder
                 completed:(nullable SDExternalCompletionBlock)completedBlock NS_REFINED_FOR_SWIFT;
- (void)sd_setImageWithURL:(nullable NSURL *)url
          placeholderImage:(nullable UIImage *)placeholder
                   options:(SDWebImageOptions)options
                 completed:(nullable SDExternalCompletionBlock)completedBlock;
- (void)sd_setImageWithURL:(nullable NSURL *)url
          placeholderImage:(nullable UIImage *)placeholder
                   options:(SDWebImageOptions)options
                  progress:(nullable SDWebImageDownloaderProgressBlock)progressBlock
                 completed:(nullable SDExternalCompletionBlock)completedBlock;
- (void)sd_setImageWithPreviousCachedImageWithURL:(nullable NSURL *)url
                                 placeholderImage:(nullable UIImage *)placeholder
                                          options:(SDWebImageOptions)options
                                         progress:(nullable SDWebImageDownloaderProgressBlock)progressBlock
                                        completed:(nullable SDExternalCompletionBlock)completedBlock;
#if SD_UIKIT
#pragma mark - Animation of multiple images
- (void)sd_setAnimationImagesWithURLs:(nonnull NSArray<NSURL *> *)arrayOfURLs;
- (void)sd_cancelCurrentAnimationImagesLoad;
#endif
@end
#endif
