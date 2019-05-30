#import <Foundation/Foundation.h>
@interface SettingModel : NSObject
+ (id)sharedInstance;
@property (nonatomic,assign) BOOL isStamp;
@property (nonatomic,assign) BOOL isRandom;
@property (nonatomic,assign) BOOL isSound;
@property (nonatomic,strong) NSString *customDate;
@end
