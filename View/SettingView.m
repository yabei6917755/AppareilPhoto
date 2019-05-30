#import "SettingView.h"
#import "SettingModel.h"
#import "Macro.h"
#import <CGXPickerView.h>
#import <MessageUI/MessageUI.h>
#import <MBProgressHUD+JDragon.h>
#import "BasicViewController.h"
#import "Macro.h"
#import <MBProgressHUD+JDragon.h>
#import "PrivacyWebViewController.h"
@implementation SettingView
-(void)layoutSubviews{
    [self.btn1 setOn:[[SettingModel sharedInstance] isStamp]];
    [self.btn2 setOn:[[SettingModel sharedInstance] isRandom]];
    [self.btn3 setTitle:[[SettingModel sharedInstance] customDate] forState:UIControlStateNormal];
    [self.btn8 setOn:[[SettingModel sharedInstance] isSound]];
    UIScrollView *scrollView = [self.subviews firstObject];
    if(scrollView){
        [scrollView setContentSize:CGSizeMake(0, 565)];
    }
}
- (IBAction)onClose:(id)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:HIDE_SETTING_ANIMATION object:nil];
}
- (IBAction)onAddStamp:(id)sender{
    [self.btn1 setOn:!self.btn1.isOn];
    [[SettingModel sharedInstance] setIsStamp:self.btn1.isOn];
}
- (IBAction)onRadom:(id)sender{
    [self.btn2 setOn:!self.btn2.isOn];
    [[SettingModel sharedInstance] setIsRandom:self.btn2.isOn];
}
- (IBAction)onSound:(id)sender{
    [self.btn8 setOn:!self.btn8.isOn];
    [[SettingModel sharedInstance] setIsSound:self.btn8.isOn];
}
- (IBAction)onCustomDate:(id)sender{
    CGXPickerViewManager *manager = [[CGXPickerViewManager alloc] init];
    [manager setLeftBtnBGColor:[UIColor whiteColor]];
    [manager setLeftBtnTitleColor:[UIColor blackColor]];
    [manager setLeftBtnBorderWidth:0];
    [manager setLeftBtnTitle:NSLocalizedString(@"Cancel", nil)];
    [manager setRightBtnTitle:NSLocalizedString(@"OK", nil)];
    [manager setRightBtnBGColor:[UIColor whiteColor]];
    [manager setRightBtnTitleColor:[UIColor blackColor]];
    [manager setRightBtnBorderWidth:0];
    [CGXPickerView showDatePickerWithTitle:@"" DateType:UIDatePickerModeDate DefaultSelValue:[[SettingModel sharedInstance] customDate] MinDateStr:nil MaxDateStr:nil IsAutoSelect:YES Manager:manager ResultBlock:^(NSString *selectValue) {
        NSLog(@"%@",selectValue);
        [[SettingModel sharedInstance] setCustomDate:selectValue];
        [self.btn3 setTitle:[[SettingModel sharedInstance] customDate] forState:UIControlStateNormal];
    }];
}
- (IBAction)onRate:(id)sender{
    [self layoutRateAlert];
}
- (void)layoutRateAlert{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Tip", nil) message:NSLocalizedString(@"Evaluate", nil) preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0) {
            [self goToAppStore];
        }else{
            NSString *urlStr = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@&pageNumber=0&sortOrdering=2&mt=8", APP_ID];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
        }
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    UIViewController *viewController = [self viewControllerSupportView:self];
    [viewController presentViewController:alertController animated:YES completion:nil];
}
-(void)goToAppStore{
    NSString *itunesurl = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/cn/app/id%@?mt=8&action=write-review",APP_ID];;
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:itunesurl]];
}
- (IBAction)onFeedback:(id)sender{
    UIViewController *viewController = [self viewControllerSupportView:self];
    if (viewController) {
        if ([viewController respondsToSelector:@selector(onFeedback)]) {
            [(BasicViewController *)viewController onFeedback];
        }else{
            [MBProgressHUD showErrorMessage:NSLocalizedString(@"FeedbackError", nil)];
        }
    }else{
        [MBProgressHUD showErrorMessage:NSLocalizedString(@"FeedbackError", nil)];
    }
}
- (UIViewController *)viewControllerSupportView:(UIView *)view {
    for (UIView* next = [view superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}
@end
