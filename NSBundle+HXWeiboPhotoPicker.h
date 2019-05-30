#import <Foundation/Foundation.h>
@interface NSBundle (HXWeiboPhotoPicker)
+ (instancetype)hx_photoPickerBundle;
+ (NSString *)hx_localizedStringForKey:(NSString *)key value:(NSString *)value;
+ (NSString *)hx_localizedStringForKey:(NSString *)key;
@end
