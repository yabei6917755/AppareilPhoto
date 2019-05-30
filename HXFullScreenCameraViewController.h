#import <UIKit/UIKit.h>
#import "HXCameraViewController.h"
@class HXFullScreenCameraViewController;
@protocol HXFullScreenCameraViewControllerDelegate <NSObject>
@optional
- (void)fullScreenCameraDidNextClick:(HXPhotoModel *)model;
- (void)fullScreenCameraViewController:(HXFullScreenCameraViewController *)fullScreenCameraViewController didNext:(HXPhotoModel *)model;
- (void)fullScreenCameraViewControllerDidCancel:(HXFullScreenCameraViewController *)fullScreenCameraViewController;
@end
@interface HXFullScreenCameraViewController : UIViewController
@property (weak, nonatomic) id<HXFullScreenCameraViewControllerDelegate> delegate;
@property (assign, nonatomic) BOOL isVideo;
@property (assign, nonatomic) HXCameraType type;
@property (strong, nonatomic) HXPhotoManager *photoManager;
@end
