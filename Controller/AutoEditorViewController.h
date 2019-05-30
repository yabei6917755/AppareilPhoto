#import <UIKit/UIKit.h>
#import "BasicViewController.h"
#import "EditNavigationBar.h"
@class AutoEditorViewController;
@protocol AutoEditorViewControllerDelegate <NSObject>
@optional
-(void)didClickFinishButtonWithEditController:(AutoEditorViewController *)controller  newImage:(UIImage*)newImage;
-(void)didClickCancelButtonWithEditController:(AutoEditorViewController *)controller;
@end
@interface AutoEditorViewController : BasicViewController
@property (nonatomic, weak) id <AutoEditorViewControllerDelegate> delegate;
@property (nonatomic, strong) UIImage *oriImage;
@property (nonatomic, strong) UIImage *resetImage;
@property (nonatomic, strong) UIImageView *mainImageView;
@property (nonatomic, strong) EditNavigationBar *navigationBar;
@end
