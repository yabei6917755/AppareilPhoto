#import "SDWebImageDecoder.h"
@implementation UIImage (ForceDecode)
#if SD_UIKIT || SD_WATCH
static const size_t kBytesPerPixel = 4;
static const size_t kBitsPerComponent = 8;
+ (nullable UIImage *)decodedImageWithImage:(nullable UIImage *)image {
    if (![UIImage shouldDecodeImage:image]) {
        return image;
    }
    @autoreleasepool{
        CGImageRef imageRef = image.CGImage;
        CGColorSpaceRef colorspaceRef = [UIImage colorSpaceForImageRef:imageRef];
        size_t width = CGImageGetWidth(imageRef);
        size_t height = CGImageGetHeight(imageRef);
        size_t bytesPerRow = kBytesPerPixel * width;
        CGContextRef context = CGBitmapContextCreate(NULL,
                                                     width,
                                                     height,
                                                     kBitsPerComponent,
                                                     bytesPerRow,
                                                     colorspaceRef,
                                                     kCGBitmapByteOrderDefault|kCGImageAlphaNoneSkipLast);
        if (context == NULL) {
            return image;
        }
        CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
        CGImageRef imageRefWithoutAlpha = CGBitmapContextCreateImage(context);
        UIImage *imageWithoutAlpha = [UIImage imageWithCGImage:imageRefWithoutAlpha
                                                         scale:image.scale
                                                   orientation:image.imageOrientation];
        CGContextRelease(context);
        CGImageRelease(imageRefWithoutAlpha);
        return imageWithoutAlpha;
    }
}
static const CGFloat kDestImageSizeMB = 60.0f;
static const CGFloat kSourceImageTileSizeMB = 20.0f;
static const CGFloat kBytesPerMB = 1024.0f * 1024.0f;
static const CGFloat kPixelsPerMB = kBytesPerMB / kBytesPerPixel;
static const CGFloat kDestTotalPixels = kDestImageSizeMB * kPixelsPerMB;
static const CGFloat kTileTotalPixels = kSourceImageTileSizeMB * kPixelsPerMB;
static const CGFloat kDestSeemOverlap = 2.0f;   
+ (nullable UIImage *)decodedAndScaledDownImageWithImage:(nullable UIImage *)image {
    if (![UIImage shouldDecodeImage:image]) {
        return image;
    }
    if (![UIImage shouldScaleDownImage:image]) {
        return [UIImage decodedImageWithImage:image];
    }
    CGContextRef destContext;
    @autoreleasepool {
        CGImageRef sourceImageRef = image.CGImage;
        CGSize sourceResolution = CGSizeZero;
        sourceResolution.width = CGImageGetWidth(sourceImageRef);
        sourceResolution.height = CGImageGetHeight(sourceImageRef);
        float sourceTotalPixels = sourceResolution.width * sourceResolution.height;
        float imageScale = kDestTotalPixels / sourceTotalPixels;
        CGSize destResolution = CGSizeZero;
        destResolution.width = (int)(sourceResolution.width*imageScale);
        destResolution.height = (int)(sourceResolution.height*imageScale);
        CGColorSpaceRef colorspaceRef = [UIImage colorSpaceForImageRef:sourceImageRef];
        size_t bytesPerRow = kBytesPerPixel * destResolution.width;
        void* destBitmapData = malloc( bytesPerRow * destResolution.height );
        if (destBitmapData == NULL) {
            return image;
        }
        destContext = CGBitmapContextCreate(destBitmapData,
                                            destResolution.width,
                                            destResolution.height,
                                            kBitsPerComponent,
                                            bytesPerRow,
                                            colorspaceRef,
                                            kCGBitmapByteOrderDefault|kCGImageAlphaNoneSkipLast);
        if (destContext == NULL) {
            free(destBitmapData);
            return image;
        }
        CGContextSetInterpolationQuality(destContext, kCGInterpolationHigh);
        CGRect sourceTile = CGRectZero;
        sourceTile.size.width = sourceResolution.width;
        sourceTile.size.height = (int)(kTileTotalPixels / sourceTile.size.width );
        sourceTile.origin.x = 0.0f;
        CGRect destTile;
        destTile.size.width = destResolution.width;
        destTile.size.height = sourceTile.size.height * imageScale;
        destTile.origin.x = 0.0f;
        float sourceSeemOverlap = (int)((kDestSeemOverlap/destResolution.height)*sourceResolution.height);
        CGImageRef sourceTileImageRef;
        int iterations = (int)( sourceResolution.height / sourceTile.size.height );
        int remainder = (int)sourceResolution.height % (int)sourceTile.size.height;
        if(remainder) {
            iterations++;
        }
        float sourceTileHeightMinusOverlap = sourceTile.size.height;
        sourceTile.size.height += sourceSeemOverlap;
        destTile.size.height += kDestSeemOverlap;
        for( int y = 0; y < iterations; ++y ) {
            @autoreleasepool {
                sourceTile.origin.y = y * sourceTileHeightMinusOverlap + sourceSeemOverlap;
                destTile.origin.y = destResolution.height - (( y + 1 ) * sourceTileHeightMinusOverlap * imageScale + kDestSeemOverlap);
                sourceTileImageRef = CGImageCreateWithImageInRect( sourceImageRef, sourceTile );
                if( y == iterations - 1 && remainder ) {
                    float dify = destTile.size.height;
                    destTile.size.height = CGImageGetHeight( sourceTileImageRef ) * imageScale;
                    dify -= destTile.size.height;
                    destTile.origin.y += dify;
                }
                CGContextDrawImage( destContext, destTile, sourceTileImageRef );
                CGImageRelease( sourceTileImageRef );
            }
        }
        CGImageRef destImageRef = CGBitmapContextCreateImage(destContext);
        CGContextRelease(destContext);
        if (destImageRef == NULL) {
            return image;
        }
        UIImage *destImage = [UIImage imageWithCGImage:destImageRef scale:image.scale orientation:image.imageOrientation];
        CGImageRelease(destImageRef);
        if (destImage == nil) {
            return image;
        }
        return destImage;
    }
}
+ (BOOL)shouldDecodeImage:(nullable UIImage *)image {
    if (image == nil) {
        return NO;
    }
    if (image.images != nil) {
        return NO;
    }
    CGImageRef imageRef = image.CGImage;
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(imageRef);
    BOOL anyAlpha = (alpha == kCGImageAlphaFirst ||
                     alpha == kCGImageAlphaLast ||
                     alpha == kCGImageAlphaPremultipliedFirst ||
                     alpha == kCGImageAlphaPremultipliedLast);
    if (anyAlpha) {
        return NO;
    }
    return YES;
}
+ (BOOL)shouldScaleDownImage:(nonnull UIImage *)image {
    BOOL shouldScaleDown = YES;
    CGImageRef sourceImageRef = image.CGImage;
    CGSize sourceResolution = CGSizeZero;
    sourceResolution.width = CGImageGetWidth(sourceImageRef);
    sourceResolution.height = CGImageGetHeight(sourceImageRef);
    float sourceTotalPixels = sourceResolution.width * sourceResolution.height;
    float imageScale = kDestTotalPixels / sourceTotalPixels;
    if (imageScale < 1) {
        shouldScaleDown = YES;
    } else {
        shouldScaleDown = NO;
    }
    return shouldScaleDown;
}
+ (CGColorSpaceRef)colorSpaceForImageRef:(CGImageRef)imageRef {
    CGColorSpaceModel imageColorSpaceModel = CGColorSpaceGetModel(CGImageGetColorSpace(imageRef));
    CGColorSpaceRef colorspaceRef = CGImageGetColorSpace(imageRef);
    BOOL unsupportedColorSpace = (imageColorSpaceModel == kCGColorSpaceModelUnknown ||
                                  imageColorSpaceModel == kCGColorSpaceModelMonochrome ||
                                  imageColorSpaceModel == kCGColorSpaceModelCMYK ||
                                  imageColorSpaceModel == kCGColorSpaceModelIndexed);
    if (unsupportedColorSpace) {
        colorspaceRef = CGColorSpaceCreateDeviceRGB();
        CFAutorelease(colorspaceRef);
    }
    return colorspaceRef;
}
#elif SD_MAC
+ (nullable UIImage *)decodedImageWithImage:(nullable UIImage *)image {
    return image;
}
+ (nullable UIImage *)decodedAndScaledDownImageWithImage:(nullable UIImage *)image {
    return image;
}
#endif
@end
