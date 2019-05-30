#import "SDWebImageCompat.h"
#if SD_UIKIT || SD_MAC
#import "SDWebImageManager.h"
@interface UIView (WebCacheOperation)
- (void)sd_setImageLoadOperation:(nullable id)operation forKey:(nullable NSString *)key;
- (void)sd_cancelImageLoadOperationWithKey:(nullable NSString *)key;
- (void)sd_removeImageLoadOperationWithKey:(nullable NSString *)key;
@end
#endif
