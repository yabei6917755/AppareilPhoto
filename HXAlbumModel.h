#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
@interface HXAlbumModel : NSObject
@property (copy, nonatomic) NSString *albumName;
@property (assign, nonatomic) NSInteger count;
@property (strong, nonatomic) PHAsset *asset;
@property (strong, nonatomic) UIImage *albumImage;
@property (strong, nonatomic) PHFetchResult *result;
@property (assign, nonatomic) NSInteger index;
@property (assign, nonatomic) NSInteger selectedCount;
@property (assign, nonatomic) CGFloat albumNameWidth;
@end
