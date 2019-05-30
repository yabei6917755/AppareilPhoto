#import "NSDate+HXExtension.h"
@implementation NSDate (HXExtension)
- (BOOL)isToday {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth |  NSCalendarUnitYear;
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
    return
    (selfCmps.year == nowCmps.year) &&
    (selfCmps.month == nowCmps.month) &&
    (selfCmps.day == nowCmps.day);
}
- (BOOL)isYesterday {
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyyMMdd";
    NSString *selfString = [fmt stringFromDate:self];
    NSString *nowString = [fmt stringFromDate:[NSDate date]];
    NSDate *selfDate = [fmt dateFromString:selfString];
    NSDate *nowDate = [fmt dateFromString:nowString];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *cmps = [calendar components:unit fromDate:selfDate toDate:nowDate options:0];
    return cmps.year == 0
    && cmps.month == 0
    && cmps.day == 1;
}
- (BOOL)isThisYear {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitYear;
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
    return nowCmps.year == selfCmps.year;
}
- (BOOL)isSameWeek {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitWeekday | NSCalendarUnitMonth | NSCalendarUnitYear ;
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
    return (selfCmps.year == nowCmps.year) && (selfCmps.month == nowCmps.month) && (selfCmps.day == nowCmps.day);
}
- (NSString *)getNowWeekday {
    NSDateFormatter *dateday = [[NSDateFormatter alloc] init];
    [dateday setDateFormat:@"MM月dd日"];
    [dateday setDateFormat:@"EEEE"];
    return [dateday stringFromDate:self];
}
- (NSString *)dateStringWithFormat:(NSString *)format {
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    formater.dateFormat = format;
    return[formater stringFromDate:self];
}
@end
