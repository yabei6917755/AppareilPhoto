#import <Foundation/Foundation.h>
#import "SDWebImageCompat.h"
#import "SDImageCacheConfig.h"
typedef NS_ENUM(NSInteger, SDImageCacheType) {
    SDImageCacheTypeNone,
    SDImageCacheTypeDisk,
    SDImageCacheTypeMemory
};
typedef void(^SDCacheQueryCompletedBlock)(UIImage * _Nullable image, NSData * _Nullable data, SDImageCacheType cacheType);
typedef void(^SDWebImageCheckCacheCompletionBlock)(BOOL isInCache);
typedef void(^SDWebImageCalculateSizeBlock)(NSUInteger fileCount, NSUInteger totalSize);
@interface SDImageCache : NSObject
#pragma mark - Properties
@property (nonatomic, nonnull, readonly) SDImageCacheConfig *config;
@property (assign, nonatomic) NSUInteger maxMemoryCost;
@property (assign, nonatomic) NSUInteger maxMemoryCountLimit;
#pragma mark - Singleton and initialization
+ (nonnull instancetype)sharedImageCache;
- (nonnull instancetype)initWithNamespace:(nonnull NSString *)ns;
- (nonnull instancetype)initWithNamespace:(nonnull NSString *)ns
                       diskCacheDirectory:(nonnull NSString *)directory NS_DESIGNATED_INITIALIZER;
#pragma mark - Cache paths
- (nullable NSString *)makeDiskCachePath:(nonnull NSString*)fullNamespace;
- (void)addReadOnlyCachePath:(nonnull NSString *)path;
#pragma mark - Store Ops
- (void)storeImage:(nullable UIImage *)image
            forKey:(nullable NSString *)key
        completion:(nullable SDWebImageNoParamsBlock)completionBlock;
- (void)storeImage:(nullable UIImage *)image
            forKey:(nullable NSString *)key
            toDisk:(BOOL)toDisk
        completion:(nullable SDWebImageNoParamsBlock)completionBlock;
- (void)storeImage:(nullable UIImage *)image
         imageData:(nullable NSData *)imageData
            forKey:(nullable NSString *)key
            toDisk:(BOOL)toDisk
        completion:(nullable SDWebImageNoParamsBlock)completionBlock;
- (void)storeImageDataToDisk:(nullable NSData *)imageData forKey:(nullable NSString *)key;
#pragma mark - Query and Retrieve Ops
- (void)diskImageExistsWithKey:(nullable NSString *)key completion:(nullable SDWebImageCheckCacheCompletionBlock)completionBlock;
- (nullable NSOperation *)queryCacheOperationForKey:(nullable NSString *)key done:(nullable SDCacheQueryCompletedBlock)doneBlock;
- (nullable UIImage *)imageFromMemoryCacheForKey:(nullable NSString *)key;
- (nullable UIImage *)imageFromDiskCacheForKey:(nullable NSString *)key;
- (nullable UIImage *)imageFromCacheForKey:(nullable NSString *)key;
#pragma mark - Remove Ops
- (void)removeImageForKey:(nullable NSString *)key withCompletion:(nullable SDWebImageNoParamsBlock)completion;
- (void)removeImageForKey:(nullable NSString *)key fromDisk:(BOOL)fromDisk withCompletion:(nullable SDWebImageNoParamsBlock)completion;
#pragma mark - Cache clean Ops
- (void)clearMemory;
- (void)clearDiskOnCompletion:(nullable SDWebImageNoParamsBlock)completion;
- (void)deleteOldFilesWithCompletionBlock:(nullable SDWebImageNoParamsBlock)completionBlock;
#pragma mark - Cache Info
- (NSUInteger)getSize;
- (NSUInteger)getDiskCount;
- (void)calculateSizeWithCompletionBlock:(nullable SDWebImageCalculateSizeBlock)completionBlock;
#pragma mark - Cache Paths
- (nullable NSString *)cachePathForKey:(nullable NSString *)key inPath:(nonnull NSString *)path;
- (nullable NSString *)defaultCachePathForKey:(nullable NSString *)key;
@end
