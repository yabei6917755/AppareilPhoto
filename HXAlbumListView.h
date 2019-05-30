#import <UIKit/UIKit.h>
#import "HXAlbumModel.h"
@protocol HXAlbumListViewDelegate <NSObject>
- (void)didTableViewCellClick:(HXAlbumModel *)model animate:(BOOL)anim;
@end
@class HXPhotoManager;
@interface HXAlbumListView : UIView
@property (weak, nonatomic) UITableView *tableView;
@property (weak, nonatomic) id<HXAlbumListViewDelegate> delegate;
@property (copy, nonatomic) NSArray *list;
@property (assign, nonatomic) NSInteger currentIndex;
- (instancetype)initWithFrame:(CGRect)frame manager:(HXPhotoManager *)manager;
@end
@interface HXAlbumListViewCell : UITableViewCell
@property (strong, nonatomic) HXAlbumModel *model;
@property (weak, nonatomic) HXPhotoManager *manager;
@end
