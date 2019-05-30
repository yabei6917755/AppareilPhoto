#import <Foundation/Foundation.h>
@interface NSDate (HXExtension)
- (BOOL)isToday;
- (BOOL)isYesterday;
- (BOOL)isThisYear;
- (BOOL)isSameWeek;
- (NSString *)getNowWeekday;
- (NSString *)dateStringWithFormat:(NSString *)format;
@end
