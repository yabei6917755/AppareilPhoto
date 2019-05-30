#import <Foundation/Foundation.h>
#import "SDWebImageDownloader.h"
#import "SDWebImageOperation.h"
extern NSString * _Nonnull const SDWebImageDownloadStartNotification;
extern NSString * _Nonnull const SDWebImageDownloadReceiveResponseNotification;
extern NSString * _Nonnull const SDWebImageDownloadStopNotification;
extern NSString * _Nonnull const SDWebImageDownloadFinishNotification;
@protocol SDWebImageDownloaderOperationInterface<NSObject>
- (nonnull instancetype)initWithRequest:(nullable NSURLRequest *)request
                              inSession:(nullable NSURLSession *)session
                                options:(SDWebImageDownloaderOptions)options;
- (nullable id)addHandlersForProgress:(nullable SDWebImageDownloaderProgressBlock)progressBlock
                            completed:(nullable SDWebImageDownloaderCompletedBlock)completedBlock;
- (BOOL)shouldDecompressImages;
- (void)setShouldDecompressImages:(BOOL)value;
- (nullable NSURLCredential *)credential;
- (void)setCredential:(nullable NSURLCredential *)value;
@end
@interface SDWebImageDownloaderOperation : NSOperation <SDWebImageDownloaderOperationInterface, SDWebImageOperation, NSURLSessionTaskDelegate, NSURLSessionDataDelegate>
@property (strong, nonatomic, readonly, nullable) NSURLRequest *request;
@property (strong, nonatomic, readonly, nullable) NSURLSessionTask *dataTask;
@property (assign, nonatomic) BOOL shouldDecompressImages;
@property (nonatomic, assign) BOOL shouldUseCredentialStorage __deprecated_msg("Property deprecated. Does nothing. Kept only for backwards compatibility");
@property (nonatomic, strong, nullable) NSURLCredential *credential;
@property (assign, nonatomic, readonly) SDWebImageDownloaderOptions options;
@property (assign, nonatomic) NSInteger expectedSize;
@property (strong, nonatomic, nullable) NSURLResponse *response;
- (nonnull instancetype)initWithRequest:(nullable NSURLRequest *)request
                              inSession:(nullable NSURLSession *)session
                                options:(SDWebImageDownloaderOptions)options NS_DESIGNATED_INITIALIZER;
- (nullable id)addHandlersForProgress:(nullable SDWebImageDownloaderProgressBlock)progressBlock
                            completed:(nullable SDWebImageDownloaderCompletedBlock)completedBlock;
- (BOOL)cancel:(nullable id)token;
@end
