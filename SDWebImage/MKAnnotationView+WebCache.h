#import "SDWebImageCompat.h"
#if SD_UIKIT || SD_MAC
#import <MapKit/MapKit.h>
#import "SDWebImageManager.h"
@interface MKAnnotationView (WebCache)
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
@end
#endif
