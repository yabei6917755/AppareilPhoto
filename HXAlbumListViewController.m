#import "HXAlbumListViewController.h" 
#import "HXDatePhotoViewController.h"
@interface HXAlbumListViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIViewControllerPreviewingDelegate>
@property (strong, nonatomic) UICollectionViewFlowLayout *flowLayout;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *albumModelArray;
@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) UILabel *authorizationLb;
@property (weak, nonatomic) id<UIViewControllerPreviewing> previewingContext;
@end
@implementation HXAlbumListViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.popoverPresentationController.delegate = (id)self;
    [self setupUI];
    [self getAlbumModelList];
    if ([PHPhotoLibrary authorizationStatus] != PHAuthorizationStatusAuthorized) {
        [self.view addSubview:self.authorizationLb];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(observeAuthrizationStatusChange:) userInfo:nil repeats:YES];
    }
}
- (void)observeAuthrizationStatusChange:(NSTimer *)timer {
    if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized) {
        [timer invalidate];
        [self.timer invalidate];
        self.timer = nil;
        [self.authorizationLb removeFromSuperview];
            [self getAlbumModelList];
    }
}
- (void)setupUI {
    self.title = @"相册";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelClick)];
    [self.view addSubview:self.collectionView];
}
- (void)cancelClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)getAlbumModelList {
    [self.view showLoadingHUDText:[NSBundle hx_localizedStringForKey:@"加载中"]];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        __weak typeof(self) weakSelf = self;
        [self.manager FetchAllAlbum:^(NSArray *albums) {
            weakSelf.albumModelArray = [NSMutableArray arrayWithArray:albums];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.collectionView reloadData];
                [weakSelf.view handleLoading];
            });
        } IsShowSelectTag:NO];
    });
}
#pragma mark - < UICollectionViewDataSource >
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.albumModelArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HXAlbumListQuadrateViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    cell.model = self.albumModelArray[indexPath.item];
    return cell;
}
#pragma mark - < UICollectionViewDelegate >
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.navigationController.topViewController != self) {
        return;
    }
    HXAlbumModel *model = self.albumModelArray[indexPath.item];
    HXDatePhotoViewController *vc = [[HXDatePhotoViewController alloc] init];
    vc.manager = self.manager;
    vc.title = model.albumName;
    vc.albumModel = model;
    [self.navigationController pushViewController:vc animated:YES];
}
- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:location];
    if (!indexPath) {
        return nil;
    }
    HXAlbumListQuadrateViewCell *cell = (HXAlbumListQuadrateViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    CGRect frame = [self.collectionView cellForItemAtIndexPath:indexPath].frame;
    previewingContext.sourceRect = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.width);
    HXDatePhotoViewController *vc = [[HXDatePhotoViewController alloc] init];
    vc.manager = self.manager;
    vc.title = cell.model.albumName;
    vc.albumModel = cell.model;
    return vc;
}
- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    [self.navigationController pushViewController:viewControllerToCommit animated:YES];
}
#pragma mark - < 懒加载 >
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.hx_w, self.view.hx_h) collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _collectionView.alwaysBounceVertical = YES;
        [_collectionView registerClass:[HXAlbumListQuadrateViewCell class] forCellWithReuseIdentifier:@"cellId"];
        _collectionView.contentInset = UIEdgeInsetsMake(kNavigationBarHeight, 0, 0, 0);
        _collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(kNavigationBarHeight, 0, 0, 0);
#ifdef __IPHONE_11_0
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
#else
            if ((NO)) {
#endif
            } else {
                self.automaticallyAdjustsScrollViewInsets = NO;
            }
            if (self.manager.open3DTouchPreview) {
                if ([self respondsToSelector:@selector(traitCollection)]) {
                    if ([self.traitCollection respondsToSelector:@selector(forceTouchCapability)]) {
                        if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
                            self.previewingContext = [self registerForPreviewingWithDelegate:self sourceView:_collectionView];
                        }
                    }
                }
            }
    }
    return _collectionView;
}
- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat itemWidth = (self.view.hx_w - 45) / 2;
        CGFloat itemHeight = itemWidth + 6 + 14 + 4 + 14;
        _flowLayout.itemSize = CGSizeMake(itemWidth, itemHeight);
        _flowLayout.minimumLineSpacing = 15;
        _flowLayout.minimumInteritemSpacing = 15;
        _flowLayout.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
    }
    return _flowLayout;
}
- (UILabel *)authorizationLb {
    if (!_authorizationLb) {
        _authorizationLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, 100)];
        _authorizationLb.text = [NSBundle hx_localizedStringForKey:@"无法访问照片\n请点击这里前往设置中允许访问照片"];
        _authorizationLb.textAlignment = NSTextAlignmentCenter;
        _authorizationLb.numberOfLines = 0;
        _authorizationLb.textColor = [UIColor blackColor];
        _authorizationLb.font = [UIFont systemFontOfSize:15];
        _authorizationLb.userInteractionEnabled = YES;
        [_authorizationLb addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goSetup)]];
    }
    return _authorizationLb;
}
- (void)dealloc {
    [self unregisterForPreviewingWithContext:self.previewingContext];
}
- (void)goSetup {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}
@end
@interface HXAlbumListQuadrateViewCell ()
@property (strong, nonatomic) UIImageView *coverView;
@property (strong, nonatomic) UILabel *albumNameLb;
@property (strong, nonatomic) UILabel *photoNumberLb;
@property (copy, nonatomic) NSString *localIdentifier;
@property (assign, nonatomic) int32_t requestID;
@end
@implementation HXAlbumListQuadrateViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}
- (void)setupUI {
    [self.contentView addSubview:self.coverView];
    [self.contentView addSubview:self.albumNameLb];
    [self.contentView addSubview:self.photoNumberLb];
}
- (void)setModel:(HXAlbumModel *)model {
    _model = model;
    if (!model.asset) {
        model.asset = model.result.lastObject;
        model.albumImage = nil;
    }
    self.localIdentifier = model.asset.localIdentifier;
    __weak typeof(self) weakSelf = self;
    int32_t requestID = [HXPhotoTools fetchPhotoWithAsset:model.asset photoSize:CGSizeMake(self.hx_w * 1.5, self.hx_w * 1.5) completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.coverView.image = photo;
    }];
    if (requestID && self.requestID && requestID != self.requestID) {
        [[PHImageManager defaultManager] cancelImageRequest:self.requestID];
    }
    self.requestID = requestID;
    self.albumNameLb.text = model.albumName;
    self.photoNumberLb.text = @(model.result.count).stringValue;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.coverView.frame = CGRectMake(0, 0, self.hx_w, self.hx_w);
    self.albumNameLb.frame = CGRectMake(0, self.hx_w + 6, self.hx_w, 14);
    self.photoNumberLb.frame = CGRectMake(0, CGRectGetMaxY(self.albumNameLb.frame) + 4, self.hx_w, 14);
}
#pragma mark - < cell懒加载 >
- (UIImageView *)coverView {
    if (!_coverView) {
        _coverView = [[UIImageView alloc] init];
        _coverView.layer.masksToBounds = YES;
        _coverView.layer.cornerRadius = 4;
        _coverView.contentMode = UIViewContentModeScaleAspectFill;
        _coverView.clipsToBounds = YES;
    }
    return _coverView;
}
- (UILabel *)albumNameLb {
    if (!_albumNameLb) {
        _albumNameLb = [[UILabel alloc] init];
        _albumNameLb.textColor = [UIColor blackColor];
        _albumNameLb.font = [UIFont systemFontOfSize:13];
    }
    return _albumNameLb;
}
- (UILabel *)photoNumberLb {
    if (!_photoNumberLb) {
        _photoNumberLb = [[UILabel alloc] init];
        _photoNumberLb.textColor = [UIColor lightGrayColor];
        _photoNumberLb.font = [UIFont systemFontOfSize:13];
    }
    return _photoNumberLb;
}
@end
