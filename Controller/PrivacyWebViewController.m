#import "PrivacyWebViewController.h"
#define kUIScreenWMagin      5*kWidthRate
#define kUIScreenHMagin      10*kWidthRate
#define kUIFont18          [UIFont systemFontOfSize:18*kWidthRate]   
#define kUIFont16          [UIFont systemFontOfSize:16*kWidthRate]   
#define kUIFont14          [UIFont systemFontOfSize:14*kWidthRate]   
#define kUIFont12          [UIFont systemFontOfSize:12*kWidthRate]   
#define iOS7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)
#define KWS(weakSelf) __weak typeof (&*self) weakSelf=self;
#define KUIScreenWidth [UIScreen mainScreen].bounds.size.width
#define KUIScreenHeight [UIScreen mainScreen].bounds.size.height
#define kWidthRate  (MAX(KUIScreenWidth, KUIScreenHeight)  == 812 ? 1:KUIScreenWidth/375  )
#define kHeightRate (MAX(KUIScreenWidth, KUIScreenHeight)  == 812 ? 1:KUIScreenHeight/667 )
#define LoginStyle [[NSUserDefaults standardUserDefaults] objectForKey:@"loginKey"]
#define kUIKWINDOW [UIApplication sharedApplication].keyWindow
#define BAKit_ShowAlertWithMsg(msg) UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:msg preferredStyle:UIAlertControllerStyleAlert];\
UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确 定" style:UIAlertActionStyleDefault handler:nil];\
[alert addAction:sureAction];\
[self presentViewController:alert animated:YES completion:nil];
#define UI_IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define UI_IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define UI_IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)
#define SCREENSIZE_IS_35  (UI_IS_IPHONE && [[UIScreen mainScreen] bounds].size.height < 568.0)
#define SCREENSIZE_IS_40  (UI_IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 568.0)
#define SCREENSIZE_IS_47  (UI_IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 667.0)
#define SCREENSIZE_IS_55  (UI_IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 736.0 || [[UIScreen mainScreen] bounds].size.width == 736.0)
#define SCREENSIZE_IS_XR ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) && !UI_IS_IPAD : NO)
#define SCREENSIZE_IS_X ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !UI_IS_IPAD : NO)
#define SCREENSIZE_IS_XS ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !UI_IS_IPAD : NO)
#define SCREENSIZE_IS_XS_MAX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) && !UI_IS_IPAD : NO)
#define IS_IPhoneX_All ([UIScreen mainScreen].bounds.size.height == 812 || [UIScreen mainScreen].bounds.size.height == 896)
#define KWS(weakSelf) __weak typeof (&*self) weakSelf=self;
#define NAVHTOP [[UIApplication sharedApplication] statusBarFrame].size.height
#define Height_NavBar 44.0f
#define NAVH (NAVHTOP + Height_NavBar)
#define TABBARH (IS_IPhoneX_All ? 83.0f:49.0f)
#define TABBARDIBU (IS_IPhoneX_All? 34.0f:0.0f)
#define PPPStringIsEmpty(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES : NO )
#define PPPArrayIsEmpty(array) ((array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0) ? YES : NO)
#define PPPDictIsEmpty(dic) ((dic == nil || [dic isKindOfClass:[NSNull class]] || dic.allKeys == 0) ? YES : NO)
#define KUIObjectIsEmpty(_object) ((_object == nil \
|| [_object isKindOfClass:[NSNull class]] \
|| ([_object respondsToSelector:@selector(length)] && [(NSData *)_object length] == 0) \
|| ([_object respondsToSelector:@selector(count)] && [(NSArray *)_object count] == 0)) ? YES : NO)
@interface PrivacyWebViewController ()
@end
@implementation PrivacyWebViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavUI];
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0,44 + NAVHTOP, self.view.frame.size.width, self.view.frame.size.height - 44 - NAVHTOP)];
    [self.view addSubview:webView];
    NSURL *url =  [[NSBundle mainBundle] URLForResource:@"pro.html" withExtension:nil];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
}
- (void) setNavUI {
    UIView *  topView = [[UIView alloc]initWithFrame:CGRectMake(0, NAVHTOP,KUIScreenWidth, 44)];
    topView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:topView];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, KUIScreenWidth, 44)];
    titleLabel.text = NSLocalizedString(@"Privacy", nil);
    titleLabel.font = [UIFont fontWithName:@"Noteworthy" size:23];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [topView addSubview:titleLabel];
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 0, 44, 44)];
    [backBtn setImage:[UIImage imageNamed:@"FT_Back"] forState:(UIControlStateNormal)];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    [topView addSubview:backBtn];
}
- (void) backBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
