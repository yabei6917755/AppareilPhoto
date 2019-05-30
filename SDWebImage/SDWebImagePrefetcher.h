#import <Foundation/Foundation.h>
#import "SDWebImageManager.h"
@class SDWebImagePrefetcher;
@protocol SDWebImagePrefetcherDelegate <NSObject>
@optional
- (void)imagePrefetcher:(nonnull SDWebImagePrefetcher *)imagePrefetcher didPrefetchURL:(nullable NSURL *)imageURL finishedCount:(NSUInteger)finishedCount totalCount:(NSUInteger)totalCount;
- (void)imagePrefetcher:(nonnull SDWebImagePrefetcher *)imagePrefetcher didFinishWithTotalCount:(NSUInteger)totalCount skippedCount:(NSUInteger)skippedCount;
@end
typedef void(^SDWebImagePrefetcherProgressBlock)(NSUInteger noOfFinishedUrls, NSUInteger noOfTotalUrls);
typedef void(^SDWebImagePrefetcherCompletionBlock)(NSUInteger noOfFinishedUrls, NSUInteger noOfSkippedUrls);
@interface SDWebImagePrefetcher : NSObject
@property (strong, nonatomic, readonly, nonnull) SDWebImageManager *manager;
@property (nonatomic, assign) NSUInteger maxConcurrentDownloads;
@property (nonatomic, assign) SDWebImageOptions options;
@property (nonatomic, assign, nonnull) dispatch_queue_t prefetcherQueue;
@property (weak, nonatomic, nullable) id <SDWebImagePrefetcherDelegate> delegate;
+ (nonnull instancetype)sharedImagePrefetcher;
- (nonnull instancetype)initWithImageManager:(nonnull SDWebImageManager *)manager NS_DESIGNATED_INITIALIZER;
- (void)prefetchURLs:(nullable NSArray<NSURL *> *)urls;
- (void)prefetchURLs:(nullable NSArray<NSURL *> *)urls
            progress:(nullable SDWebImagePrefetcherProgressBlock)progressBlock
           completed:(nullable SDWebImagePrefetcherCompletionBlock)completionBlock;
- (void)cancelPrefetching;
@end
