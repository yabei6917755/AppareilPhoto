#import "SDWebImageCompat.h"
#import "SDWebImageOperation.h"
#import "SDWebImageDownloader.h"
#import "SDImageCache.h"
typedef NS_OPTIONS(NSUInteger, SDWebImageOptions) {
    SDWebImageRetryFailed = 1 << 0,
    SDWebImageLowPriority = 1 << 1,
    SDWebImageCacheMemoryOnly = 1 << 2,
    SDWebImageProgressiveDownload = 1 << 3,
    SDWebImageRefreshCached = 1 << 4,
    SDWebImageContinueInBackground = 1 << 5,
    SDWebImageHandleCookies = 1 << 6,
    SDWebImageAllowInvalidSSLCertificates = 1 << 7,
    SDWebImageHighPriority = 1 << 8,
    SDWebImageDelayPlaceholder = 1 << 9,
    SDWebImageTransformAnimatedImage = 1 << 10,
    SDWebImageAvoidAutoSetImage = 1 << 11,
    SDWebImageScaleDownLargeImages = 1 << 12
};
typedef void(^SDExternalCompletionBlock)(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL);
typedef void(^SDInternalCompletionBlock)(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL);
typedef NSString * _Nullable (^SDWebImageCacheKeyFilterBlock)(NSURL * _Nullable url);
@class SDWebImageManager;
@protocol SDWebImageManagerDelegate <NSObject>
@optional
- (BOOL)imageManager:(nonnull SDWebImageManager *)imageManager shouldDownloadImageForURL:(nullable NSURL *)imageURL;
- (nullable UIImage *)imageManager:(nonnull SDWebImageManager *)imageManager transformDownloadedImage:(nullable UIImage *)image withURL:(nullable NSURL *)imageURL;
@end
@interface SDWebImageManager : NSObject
@property (weak, nonatomic, nullable) id <SDWebImageManagerDelegate> delegate;
@property (strong, nonatomic, readonly, nullable) SDImageCache *imageCache;
@property (strong, nonatomic, readonly, nullable) SDWebImageDownloader *imageDownloader;
@property (nonatomic, copy, nullable) SDWebImageCacheKeyFilterBlock cacheKeyFilter;
+ (nonnull instancetype)sharedManager;
- (nonnull instancetype)initWithCache:(nonnull SDImageCache *)cache downloader:(nonnull SDWebImageDownloader *)downloader NS_DESIGNATED_INITIALIZER;
- (nullable id <SDWebImageOperation>)loadImageWithURL:(nullable NSURL *)url
                                              options:(SDWebImageOptions)options
                                             progress:(nullable SDWebImageDownloaderProgressBlock)progressBlock
                                            completed:(nullable SDInternalCompletionBlock)completedBlock;
- (void)saveImageToCache:(nullable UIImage *)image forURL:(nullable NSURL *)url;
- (void)cancelAll;
- (BOOL)isRunning;
- (void)cachedImageExistsForURL:(nullable NSURL *)url
                     completion:(nullable SDWebImageCheckCacheCompletionBlock)completionBlock;
- (void)diskImageExistsForURL:(nullable NSURL *)url
                   completion:(nullable SDWebImageCheckCacheCompletionBlock)completionBlock;
- (nullable NSString *)cacheKeyForURL:(nullable NSURL *)url;
@end
