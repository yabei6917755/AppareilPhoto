#import "BasicViewController.h"
#import <MessageUI/MessageUI.h>
#import <MBProgressHUD+JDragon.h>
@interface BasicViewController () <MFMailComposeViewControllerDelegate>
@end
@implementation BasicViewController
- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)onFeedback{
    if ([MFMailComposeViewController canSendMail]) { 
    }else{
        [MBProgressHUD showErrorMessage:NSLocalizedString(@"NoMailAccount", nil)];
        return;
    }
    if ([MFMessageComposeViewController canSendText] == YES) {
        MFMailComposeViewController *mailCompose = [[MFMailComposeViewController alloc]init];
        mailCompose.mailComposeDelegate = self;
        [mailCompose setSubject:@""];
        NSArray *arr = @[@"samline228@yahoo.com"];
        [mailCompose setToRecipients:arr];
        [self presentViewController:mailCompose animated:YES completion:nil];
    }else{
        [MBProgressHUD showErrorMessage:NSLocalizedString(@"NoSupportMail", nil)];
    }
}
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(nullable NSError *)error{
    if (result) {
        NSLog(@"Result : %ld",(long)result);
    }
    if (error) {
        NSLog(@"Error : %@",error);
    }
    switch (result)
    {
        case MFMailComposeResultCancelled: 
            NSLog(@"Mail send canceled...");
            break;
        case MFMailComposeResultSaved: 
            NSLog(@"Mail saved...");
            break;
        case MFMailComposeResultSent: 
            NSLog(@"Mail sent...");
            break;
        case MFMailComposeResultFailed: 
            NSLog(@"Mail send errored: %@...", [error localizedDescription]);
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
@end
