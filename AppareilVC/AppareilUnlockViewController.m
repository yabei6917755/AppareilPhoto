#import "AppareilUnlockViewController.h"
@implementation AppareilUnlockViewController : NSObject
+ (BOOL)uOnback:(NSInteger)appareil {
    return appareil % 33 == 0;
}
+ (BOOL)NPrepareforseguebSender:(NSInteger)appareil {
    return appareil % 15 == 0;
}
@end
