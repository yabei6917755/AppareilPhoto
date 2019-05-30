#import <UIKit/UIKit.h>
#import "HXPhotoManager.h"
@interface HXDatePhotoViewController : UIViewController
@property (strong, nonatomic) HXPhotoManager *manager;
@property (strong, nonatomic) HXAlbumModel *albumModel;
@end
@interface HXDatePhotoViewCell : UICollectionViewCell
@property (strong, nonatomic, readonly) UIImageView *imageView;
@property (strong, nonatomic) HXPhotoModel *model;
@end
@interface HXDatePhotoViewSectionHeaderView : UICollectionReusableView
@property (strong, nonatomic) HXPhotoDateModel *model;
@end
