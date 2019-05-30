#import <UIKit/UIKit.h>
@class HXCollectionView;
@protocol HXCollectionViewDelegate <UICollectionViewDelegate>
@required
- (void)dragCellCollectionView:(HXCollectionView *)collectionView newDataArrayAfterMove:(NSArray *)newDataArray;
@optional
- (void)dragCellCollectionViewCellEndMoving:(HXCollectionView *)collectionView;
- (void)dragCellCollectionView:(HXCollectionView *)collectionView moveCellFromIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath;
@end
@protocol HXCollectionViewDataSource<UICollectionViewDataSource>
@required
- (NSArray *)dataSourceArrayOfCollectionView:(HXCollectionView *)collectionView;
@end
@interface HXCollectionView : UICollectionView
@property (weak, nonatomic) id<HXCollectionViewDelegate> delegate;
@property (weak, nonatomic) id<HXCollectionViewDataSource> dataSource;
@property (assign, nonatomic) BOOL editEnabled;
@end
