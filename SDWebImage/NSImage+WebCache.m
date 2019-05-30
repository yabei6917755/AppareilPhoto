#import "NSImage+WebCache.h"
#if SD_MAC
@implementation NSImage (WebCache)
- (CGImageRef)CGImage {
    NSRect imageRect = NSMakeRect(0, 0, self.size.width, self.size.height);
    CGImageRef cgImage = [self CGImageForProposedRect:&imageRect context:NULL hints:nil];
    return cgImage;
}
- (NSArray<NSImage *> *)images {
    return nil;
}
- (BOOL)isGIF {
    return NO;
}
@end
#endif
