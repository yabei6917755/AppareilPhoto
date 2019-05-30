#import <UIKit/UIKit.h>
#import "HXAlbumModel.h"
#import "HXPhotoManager.h"
@interface HXAlbumListViewController : UIViewController
@property (strong, nonatomic) HXPhotoManager *manager;
@end
@interface HXAlbumListQuadrateViewCell : UICollectionViewCell
@property (strong, nonatomic) HXAlbumModel *model;
@end
