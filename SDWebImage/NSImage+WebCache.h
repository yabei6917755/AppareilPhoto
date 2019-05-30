#import "SDWebImageCompat.h"
#if SD_MAC
#import <Cocoa/Cocoa.h>
@interface NSImage (WebCache)
- (CGImageRef)CGImage;
- (NSArray<NSImage *> *)images;
- (BOOL)isGIF;
@end
#endif
