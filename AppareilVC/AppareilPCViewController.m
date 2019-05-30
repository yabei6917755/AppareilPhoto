#import "AppareilPCViewController.h"
@implementation AppareilPCViewController
+ (BOOL)jViewcontrollerfrommainstoryboard:(NSInteger)appareil {
    return appareil % 8 == 0;
}
+ (BOOL)XprefersStatusBarHidden:(NSInteger)appareil {
    return appareil % 33 == 0;
}
@end
