#import "CircleView.h"
@implementation CircleView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.color = [UIColor blackColor];
        self.radius = 1;
        self.borderColor = [UIColor clearColor];
        self.borderWidth = 0;
        UIImageView *imgview = [[UIImageView alloc] initWithFrame:self.bounds];
        imgview.image = [UIImage imageNamed:@"sticker_rotate.png"];
        [self addSubview:imgview];
    }
    return self;
}
- (void)setColor:(UIColor *)color
{
    if(color != _color)
    {
        _color = color;
        [self setNeedsDisplay];
    }
}
- (void)setBorderColor:(UIColor *)borderColor
{
    if(borderColor != _borderColor)
    {
        _borderColor = borderColor;
        [self setNeedsDisplay];
    }
}
- (void)setBorderWidth:(CGFloat)borderWidth
{
    if(borderWidth != _borderWidth)
    {
        _borderWidth = borderWidth;
        [self setNeedsDisplay];
    }
}
@end
