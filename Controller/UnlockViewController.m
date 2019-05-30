#import "UnlockViewController.h"
#import "Macro.h"
#import <MBProgressHUD+JDragon.h>
@interface UnlockViewController ()
@end
#define IS_PAD (UI_USER_INTERFACE_IDIOM()== UIUserInterfaceIdiomPad)
@implementation UnlockViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor blackColor]];
    UIImageView *imageView;
    if (IS_PAD) {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.height * 0.8/1136*640, self.view.bounds.size.height * 0.8)];
    }else{
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width * 0.8, self.view.bounds.size.width * 0.8/640 *1136)];
    }
    imageView.center = CGPointMake(self.view.center.x, self.view.center.y - 40);
    [imageView.layer setCornerRadius:15];
    [imageView.layer setMasksToBounds:YES];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    [imageView setImage:[UIImage imageNamed:@"FT_Unlock"]];
    [imageView setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onBuyAllProduct:)];
    [imageView addGestureRecognizer:tap];
    [self.view addSubview:imageView];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 40)/2, imageView.frame.origin.y + imageView.frame.size.height + 15, 40, 40)];
    [button.layer setMasksToBounds:YES];
    [button.layer setCornerRadius:20];
    [button.layer setBorderWidth:1];
    [button.layer setBorderColor:[UIColor whiteColor].CGColor];
    [button setImage:[UIImage imageNamed:@"FT_Close"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}
-(IBAction)onBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [appareilAutoEditorViewControllert BInitbottombarappareil:12];
}
@end
