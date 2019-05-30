#import "HXAlbumModel.h"
#import "HXPhotoTools.h"
@implementation HXAlbumModel
- (CGFloat)albumNameWidth {
    if (_albumNameWidth == 0) {
        _albumNameWidth = [HXPhotoTools getTextWidth:self.albumName height:18 fontSize:17];
    }
    return _albumNameWidth;
}
@end
