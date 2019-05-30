#import "AppareilBasicViewController.h"
@implementation AppareilBasicViewController
+ (BOOL)COnfeedbackappareil:(NSInteger)appareil {
    return appareil % 11 == 0;
}
+ (BOOL)OMailcomposecontrollerdidfinishwithresulterrorappareil:(NSInteger)appareil {
    return appareil % 46 == 0;
}
@end
