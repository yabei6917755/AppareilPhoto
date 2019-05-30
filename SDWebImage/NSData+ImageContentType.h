#import <Foundation/Foundation.h>
#import "SDWebImageCompat.h"
typedef NS_ENUM(NSInteger, SDImageFormat) {
    SDImageFormatUndefined = -1,
    SDImageFormatJPEG = 0,
    SDImageFormatPNG,
    SDImageFormatGIF,
    SDImageFormatTIFF,
    SDImageFormatWebP
};
@interface NSData (ImageContentType)
+ (SDImageFormat)sd_imageFormatForImageData:(nullable NSData *)data;
@end
