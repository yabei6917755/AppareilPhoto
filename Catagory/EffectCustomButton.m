#import "EffectCustomButton.h"
#import "Macro.h"
@implementation EffectCustomButton{
    UIImageView *_customImageView;
}
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:itemBackGroundColor];
        _customImageView = [[UIImageView alloc] initWithFrame:CGRectMake(itemBonderWidth, itemBonderWidth, frame.size.width - itemBonderWidth * 2, frame.size.height - itemBonderWidth * 2)];
        [self addSubview:_customImageView];
    }
    return self;
}
- (void)setLayoutWithContent:(NSDictionary *)content{
    [_customImageView setImage:[UIImage imageNamed:[content objectForKey:@"icon"]]];
}
@end
