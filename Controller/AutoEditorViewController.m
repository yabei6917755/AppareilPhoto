#import "AutoEditorViewController.h"
#import "SettingView.h"
#import "HCPhotoEditCustomButton.h"
#import "UnlockViewController.h"
#import "HCPhotoEditViewController.h"
#import "HCPhotoEditCustomSlider.h"
#import "GPUImage.h"
#import "EffectCustomButton.h"
#import <MBProgressHUD+JDragon.h>
#import "PhotoXAcvFilter.h"
#import "PhotoXHaloFilter.h"
#import "FBGlowLabel.h"
#import "SettingModel.h"
#import "Macro.h"
#define Is_iPhoneX ([UIScreen mainScreen].bounds.size.height == 812 || [UIScreen mainScreen].bounds.size.height == 896)
#define IS_PAD (UI_USER_INTERFACE_IDIOM()== UIUserInterfaceIdiomPad)
#define IMAGE_WITHNAME(X)   [HCPhotoEditViewController resourceImageWithName:X]
@interface AutoEditorViewController ()
@end
@implementation AutoEditorViewController{
    UIView *_alphaView;
    UIView *_bottomTabbar;
    NSInteger _selectedBottomIndex;
    NSArray *_bottomTitles;
    NSArray *_titles;
    NSInteger _selectEditIndex;
    NSInteger _selectFilterIndex;
    NSInteger _selectTextureIndex;
    UIScrollView *_editScrollView;
    UIScrollView *_filterScrollView;
    UIScrollView *_textureScrollView;
    GPUImageHighlightShadowFilter *_levelFilter;
    GPUImageSharpenFilter *_sharpenFilter;
    GPUImageWhiteBalanceFilter *_balanceFilter;
    GPUImageExposureFilter *_exposureFilter;
    GPUImageContrastFilter *_contrastFilter;
    GPUImageSaturationFilter *_saturationFilter;
    GPUImageBrightnessFilter *_brightnessFilter;
    GPUImageVignetteFilter *_vignetteFilter;
    GPUImageHighlightShadowFilter *_shadowFilter;
    HCPhotoEditCustomSlider  *_editSlider;
    GPUImagePicture *_picSource;
    CGFloat _lastSliderValue;
    NSMutableDictionary *_sliderContent;
    NSArray *_filterPlistArray;
    NSArray *_texturePlistArray;
    UIView *_unlockBackgroundView;
    NSString *_tempDateString;
    UIImage *_tempImage;
    GPUImageFilter *_classFilter;
    PhotoXAcvFilter *_acvFilter;
    PhotoXHaloFilter *_blendTextureFilter;
    GPUImagePicture *_stillImageSource;
    GPUImagePicture *_overImageSource;
    NSDictionary *_selectedFontProperty;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor blackColor]];
    _sliderContent = [NSMutableDictionary new];
    _bottomTitles = @[NSLocalizedString(@"tabbar1", nil),NSLocalizedString(@"tabbar2", nil),NSLocalizedString(@"tabbar3", nil)];
    _selectedBottomIndex = -1;
    _selectEditIndex = 0;
    _selectFilterIndex = -1;
    _selectTextureIndex = -1;
    [self initParam];
    [self initTopBar];
    [self initBottomBar];
    [self initEditBar];
    [self initSliderBar];
    [self initMainImageView];
    [self selectBottomTabWithIndex:_selectEditIndex];
}
-(void)initParam{
    _tempDateString = @"";
    _titles = @[NSLocalizedString(@"LEVEL", nil),NSLocalizedString(@"SHARPNESS", nil),NSLocalizedString(@"COLOR", nil),NSLocalizedString(@"EXPOSURE", nil),NSLocalizedString(@"CONTRAST", nil),NSLocalizedString(@"SATURATION", nil),NSLocalizedString(@"BRIGHTNESS", nil),NSLocalizedString(@"SHADOW", nil),NSLocalizedString(@"VIGNETTE", nil)];
    [self initEditParams];
    NSString *filterPath = [[NSBundle mainBundle] pathForResource:@"filters" ofType:@"plist"];
    _filterPlistArray = [NSArray arrayWithContentsOfFile:filterPath];
    NSString *texturePath = [[NSBundle mainBundle] pathForResource:@"textures" ofType:@"plist"];
    _texturePlistArray = [NSArray arrayWithContentsOfFile:texturePath];
}
- (void)initEditParams{
    [_sliderContent setValue:@"0" forKey:NSLocalizedString(@"LEVEL",nil)];
    [_sliderContent setValue:@"0" forKey:NSLocalizedString(@"SHARPNESS",nil)];
    [_sliderContent setValue:@"5000" forKey:NSLocalizedString(@"COLOR",nil)];
    [_sliderContent setValue:@"0" forKey:NSLocalizedString(@"EXPOSURE",nil)];
    [_sliderContent setValue:@"1" forKey:NSLocalizedString(@"CONTRAST",nil)];
    [_sliderContent setValue:@"1" forKey:NSLocalizedString(@"SATURATION",nil)];
    [_sliderContent setValue:@"0" forKey:NSLocalizedString(@"BRIGHTNESS",nil)];
    [_sliderContent setValue:@"0" forKey:NSLocalizedString(@"SHADOW",nil)];
    [_sliderContent setValue:@"0.5" forKey:NSLocalizedString(@"VIGNETTE",nil)];
}
- (void)initMainImageView{
    if (IS_PAD) {
        self.mainImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, _navigationBar.bounds.size.height, self.view.bounds.size.width, _editSlider.frame.origin.y - _navigationBar.bounds.size.height)];
    }else{
        self.mainImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, _navigationBar.bounds.size.height +  10, self.view.bounds.size.width - 20, _editSlider.frame.origin.y - _navigationBar.bounds.size.height - 20)];
    }
    [self.mainImageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.mainImageView setImage:self.oriImage];
    [self.view addSubview:self.mainImageView];
}
- (void)initSliderBar{
    if (IS_PAD) {
        _editSlider = [[HCPhotoEditCustomSlider alloc] initWithFrame:CGRectMake(self.view.bounds.size.width * 0.3, _editScrollView.frame.origin.y - 60, self.view.bounds.size.width * 0.4, 35)];
    }else{
        _editSlider = [[HCPhotoEditCustomSlider alloc] initWithFrame:CGRectMake(40, _editScrollView.frame.origin.y - 60, self.view.bounds.size.width - 70, 35)];
    }
    [self.view addSubview:_editSlider];
    [_editSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
}
#pragma 点击底下Tabbar
- (void)selectBottomTabWithIndex:(NSInteger)index{
    if (_selectedBottomIndex == index) {
        return;
    }
    _selectedBottomIndex = index;
    if (_selectedBottomIndex == 0) {
        if (_tempImage) {
            self.oriImage = _tempImage;
        }
        _tempImage = nil;
    }
    _picSource =  [[GPUImagePicture alloc] initWithImage:self.oriImage];
    for (int i = 0; i < [_titles count]; i++) {
        UIButton *button = [_bottomTabbar viewWithTag:i + 1];
        if (i == _selectedBottomIndex) {
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setBackgroundColor:[UIColor colorWithRed:0.118 green:0.118 blue:0.118 alpha:1.000]];
        }else{
            [button setTitleColor:[UIColor colorWithRed:0.341 green:0.341 blue:0.341 alpha:1.000] forState:UIControlStateNormal];
            [button setBackgroundColor:[UIColor blackColor]];
        }
    }
    if (_selectedBottomIndex == 0) {
        _editSlider.hidden = NO;
        _editScrollView.hidden = NO;
        _filterScrollView.hidden = YES;
        _textureScrollView.hidden = YES;
        _selectFilterIndex = -1;
        _selectTextureIndex = -1;
        if (_editScrollView) {
            _selectEditIndex = 0;
            [self initEditParams];
            [_editScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
            [self editBarClick:[_editScrollView viewWithTag:_selectEditIndex+1]];
        }
    }else if(_selectedBottomIndex == 1){
        [self clearEditFilters];
        _editScrollView.hidden = YES;
        _filterScrollView.hidden = NO;
        _textureScrollView.hidden = YES;
        if (_selectFilterIndex != -1) {
            _editSlider.hidden = NO;
        }else{
            _editSlider.hidden = YES;
            [self selectFilterButtonWithIndex:_selectFilterIndex];
            [_filterScrollView setContentOffset:CGPointMake(0, 0)];
        }
    }else{
        [self clearEditFilters];
        _editScrollView.hidden = YES;
        _filterScrollView.hidden = YES;
        _textureScrollView.hidden = NO;
        if (_selectTextureIndex != -1) {
            _editSlider.hidden = NO;
        }else{
            _editSlider.hidden = YES;
            [self selectTextureButtonWithIndex:_selectTextureIndex];
            [_textureScrollView setContentOffset:CGPointMake(0, 0)];
        }
    }
}
-(void)clearEditFilters{
    _levelFilter = nil;
    _saturationFilter = nil;
    _contrastFilter = nil;
    _exposureFilter = nil;
    _brightnessFilter = nil;
    _sharpenFilter = nil;
    _vignetteFilter = nil;
    _balanceFilter = nil;
    _shadowFilter = nil;
}
-(void)sliderValueChanged:(UISlider*)slider
{
    if (_editScrollView.hidden == NO) {
        switch (_selectEditIndex) {
            case 0:
            {
                if (!_levelFilter) {
                    _levelFilter = [[GPUImageHighlightShadowFilter alloc] init];
                    [_picSource addTarget:_levelFilter];
                }
                _levelFilter.shadows += (slider.value - _lastSliderValue);
                _levelFilter.highlights -= (slider.value - _lastSliderValue);
                [self updateImage:_levelFilter];
                _lastSliderValue = slider.value;
                [self updateKey:@"LEVEL" value:slider.value];
            }
                break;
            case 1:
            {
                if (!_sharpenFilter) {
                    _sharpenFilter = [[GPUImageSharpenFilter alloc] init];
                    [_picSource addTarget:_sharpenFilter];
                }
                _sharpenFilter.sharpness = slider.value;
                [self updateImage:_sharpenFilter];
                [self updateKey:@"SHARPNESS" value:slider.value];
            }
                break;
            case 2:
            {
                if (!_balanceFilter) {
                    _balanceFilter = [[GPUImageWhiteBalanceFilter alloc] init];
                    [_picSource addTarget:_balanceFilter];
                }
                _balanceFilter.temperature = slider.value;
                [self updateImage:_balanceFilter];
                [self updateKey:@"COLOR" value:slider.value];
            }
                break;
            case 3:
            {
                if (!_exposureFilter) {
                    _exposureFilter = [[GPUImageExposureFilter alloc] init];
                    [_picSource addTarget:_exposureFilter];
                }
                _exposureFilter.exposure = slider.value;
                [self updateImage:_exposureFilter];
                [self updateKey:@"EXPOSURE" value:slider.value];
            }
                break;
            case 4:
            {
                if (!_contrastFilter) {
                    _contrastFilter = [[GPUImageContrastFilter alloc] init];
                    [_picSource addTarget:_contrastFilter];
                }
                _contrastFilter.contrast = slider.value;
                [self updateImage:_contrastFilter];
                [self updateKey:@"CONTRAST" value:slider.value];
            }
                break;
            case 5:
            {
                if (!_saturationFilter) {
                    _saturationFilter = [[GPUImageSaturationFilter alloc] init];
                    [_picSource addTarget:_saturationFilter];
                }
                _saturationFilter.saturation = slider.value;
                [self updateImage:_saturationFilter];
                [self updateKey:@"SATURATION" value:slider.value];
            }
                break;
            case 6:
            {
                if (!_brightnessFilter) {
                    _brightnessFilter = [[GPUImageBrightnessFilter alloc] init];
                    [_picSource addTarget:_brightnessFilter];
                }
                _brightnessFilter.brightness = slider.value;
                [self updateImage:_brightnessFilter];
                [self updateKey:@"BRIGHTNESS" value:slider.value];
            }
                break;
            case 7:
            {
                if (!_shadowFilter) {
                    _shadowFilter = [[GPUImageHighlightShadowFilter alloc] init];
                    [_picSource addTarget:_shadowFilter];
                }
                _shadowFilter.shadows = slider.value;
                [self updateImage:_shadowFilter];
                [self updateKey:@"SHADOW" value:slider.value];
            }
                break;
            case 8:
            {
                if (!_vignetteFilter) {
                    _vignetteFilter = [[GPUImageVignetteFilter alloc] init];
                    [_picSource addTarget:_vignetteFilter];
                }
                _vignetteFilter.vignetteStart = slider.value;
                _vignetteFilter.vignetteEnd = slider.value + 0.25;
                [self updateImage:_vignetteFilter];
                [self updateKey:@"VIGNETTE" value:slider.value];
            }
                break;
            default:
                break;
        }
    }else if(_filterScrollView.hidden == NO){
        if ([[[_filterPlistArray objectAtIndex:_selectFilterIndex] objectForKey:@"filter"] hasSuffix:@".acv"]) {
            if (_acvFilter) {
                _acvFilter.mix = slider.value;
                [_acvFilter useNextFrameForImageCapture];
                [_picSource processImage];
                UIImage *newImage = [_acvFilter imageFromCurrentFramebufferWithOrientation:self.oriImage.imageOrientation];
                _tempImage = newImage;
                if (newImage) {
                    [self addDateSignWithImage:newImage];
                }
            }
        }
    }else{
        if (_blendTextureFilter) {
            _blendTextureFilter.mix = slider.value;
            [_blendTextureFilter useNextFrameForImageCapture];
            [_stillImageSource processImage];
            [_overImageSource processImage];
            UIImage *newImage = [_blendTextureFilter imageFromCurrentFramebufferWithOrientation:self.oriImage.imageOrientation];
            _tempImage = newImage;
            if (newImage) {
                [self addDateSignWithImage:newImage];
            }
        }
    }
}
- (UIImage *)alphaBlendingFiltering:(UIImage*)srcImage andOverImage:(UIImage *)overImage andFilterMix:(CGFloat)filterMix {
    if (srcImage) {
        _blendTextureFilter = [[PhotoXHaloFilter alloc] init];
        _stillImageSource = [[GPUImagePicture alloc] initWithImage:srcImage];
        [_stillImageSource addTarget:_blendTextureFilter atTextureLocation:0];
        _overImageSource = [[GPUImagePicture alloc] initWithImage:overImage];
        [_overImageSource addTarget:_blendTextureFilter atTextureLocation:1];
        _blendTextureFilter.mix = filterMix;
        [_blendTextureFilter useNextFrameForImageCapture];
        [_stillImageSource processImage];
        [_overImageSource processImage];
        return [_blendTextureFilter imageFromCurrentFramebufferWithOrientation:self.oriImage.imageOrientation];
    }
    else{
        NSLog(@"error in blending: srcImage = nil");
        return overImage;
    }
}
-(void)updateImage:(GPUImageOutput*)filter
{
    [filter useNextFrameForImageCapture];
    [_picSource processImage];
    UIImage *newImage = [filter imageFromCurrentFramebufferWithOrientation:self.oriImage.imageOrientation];
    if (newImage) {
        self.oriImage = newImage;
        [self addDateSignWithImage:self.oriImage];
    }
}
-(void)updateKey:(NSString*)key value:(float)value
{
    [_sliderContent setObject:[NSString stringWithFormat:@"%f",value] forKey:NSLocalizedString(key, nil)];
}
- (void)initEditBar{
    NSArray *images = @[@"TPhotoAdjustCategory_Level",@"TPhotoAdjustCategory_sharpness",@"TPhotoAdjustCategory_Temperature",@"TPhotoAdjustCategory_Exposure",@"TPhotoAdjustCategory_Contrast",@"TPhotoAdjustCategory_Saturation",@"TPhotoAdjustCategory_Highlight",@"TPhotoAdjustCategory_Shadow",@"TPhotoAdjustCategory_vignetteStrong"];
    _editScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _bottomTabbar.frame.origin.y - 61, self.view.frame.size.width, 60)];
    [self.view addSubview:_editScrollView];
    for (int index = 0; index < images.count; index++){
        NSString *name = images[index];
        NSString *name2 = [name stringByAppendingString:@"_h"];
        UIImage *hightImage = IMAGE_WITHNAME(name2);
        if (!hightImage) {
            hightImage = IMAGE_WITHNAME([name stringByAppendingString:@"_Light"]);
        }
        HCPhotoEditCustomButton *btn = [[HCPhotoEditCustomButton alloc] initWithImage:IMAGE_WITHNAME(name) highlightedImage:hightImage title:_titles[index] font:8 imageSize:20];
        btn.tag = index + 1;
        [btn setImage:hightImage forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(editBarClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake(index * 90, 0, 90 - 1, _editScrollView.bounds.size.height);
        [_editScrollView addSubview:btn];
        _editScrollView.contentSize = CGSizeMake(CGRectGetMaxX(btn.frame), 0);
        btn.alpha = 0;
        [UIView animateWithDuration:0.2 delay:0.05*index options:UIViewAnimationOptionCurveEaseOut animations:^{
            btn.alpha = 1;
        } completion:^(BOOL finished) {
        }];
    }
    [self selectEditButtonWithIndex:_selectEditIndex];
    _filterScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _bottomTabbar.frame.origin.y - 86, self.view.frame.size.width, 85)];
    [_filterScrollView setHidden: YES];
    [self.view addSubview:_filterScrollView];
    for (int i=0; i< [_filterPlistArray count]; i++) {
        EffectCustomButton *button = [[EffectCustomButton alloc] initWithFrame:CGRectMake(i * 85, 0, 85, 85)];
        [button setLayoutWithContent:[_filterPlistArray objectAtIndex:i]];
        [_filterScrollView addSubview:button];
        [button setTag:i+1];
        [button addTarget:self action:@selector(onFilter:) forControlEvents:UIControlEventTouchUpInside];
        [_filterScrollView setContentSize:CGSizeMake(button.frame.origin.x + button.frame.size.width, 0)];
    }
    _textureScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _bottomTabbar.frame.origin.y - 86, self.view.frame.size.width, 85)];
    [_textureScrollView setHidden: YES];
    [self.view addSubview:_textureScrollView];
    for (int i=0; i< [_texturePlistArray count]; i++) {
        EffectCustomButton *button = [[EffectCustomButton alloc] initWithFrame:CGRectMake(i * 85, 0, 85, 85)];
        [button setLayoutWithContent:[_texturePlistArray objectAtIndex:i]];
        [_textureScrollView addSubview:button];
        [button setTag:i+1];
        [button addTarget:self action:@selector(onTextures:) forControlEvents:UIControlEventTouchUpInside];
        [_textureScrollView setContentSize:CGSizeMake(button.frame.origin.x + button.frame.size.width, 0)];
    }
}
-(UIButton *)getAddMoreButton{
    UIView *addMoreView = [[[NSBundle mainBundle] loadNibNamed:@"GetMoreButtom" owner:self options:nil] lastObject];
    [addMoreView setUserInteractionEnabled:YES];
    [addMoreView setFrame:CGRectMake(0, 0, 85 - itemBonderWidth * 2, 85 - itemBonderWidth * 2)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onBuy:)];
    [addMoreView addGestureRecognizer:tap];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 85, 85)];
    [button addSubview: addMoreView];
    [button setBackgroundColor:itemBackGroundColor];
    addMoreView.center = button.center;
    return button;
}
-(void)addDateSignWithImage:(UIImage *)image{
    if ([[SettingModel sharedInstance] isStamp] == NO) {
        self.mainImageView.image = image;
        return;
    }
    if (_selectedFontProperty) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        FBGlowLabel *label = [[FBGlowLabel alloc] init];
        CGFloat value = imageView.frame.size.width > imageView.frame.size.height ? imageView.frame.size.width : imageView.frame.size.height;
        CGFloat base = value/1920;
        UIFont *font = [UIFont fontWithName:[_selectedFontProperty objectForKey:@"fontName"] size:[[_selectedFontProperty objectForKey:@"fontSize"] floatValue] * base];
        if (font == nil) {
            NSLog(@"没找到您配置的字体哦！！！");
            font = [UIFont fontWithName:@"DS-Digital" size:[[_selectedFontProperty objectForKey:@"fontSize"] floatValue] * base];
        }
        [label setFont:font];
        NSArray *strokes = [[_selectedFontProperty objectForKey:@"strokeColor"] componentsSeparatedByString:@","];
        if (strokes!=nil && [strokes count] == 4) {
            label.strokeColor = [UIColor colorWithRed:[strokes[0] floatValue]/255 green:[strokes[1] floatValue]/255 blue:[strokes[2] floatValue]/255 alpha:[strokes[3] floatValue]];
        }else{
            label.strokeColor = [UIColor colorWithRed:0.937 green:0.337 blue:0.157 alpha:0.7];
        }
        label.strokeWidth = [[_selectedFontProperty objectForKey:@"strokeWidth"] floatValue];
        label.layer.shadowRadius = [[_selectedFontProperty objectForKey:@"shadowRadius"] floatValue];
        NSArray *shadows = [[_selectedFontProperty objectForKey:@"shadowColor"] componentsSeparatedByString:@","];
        if (shadows!=nil && [shadows count] == 4) {
            label.layer.shadowColor = [UIColor colorWithRed:[shadows[0] floatValue]/255 green:[shadows[1] floatValue]/255 blue:[shadows[2] floatValue]/255 alpha:[shadows[3] floatValue]].CGColor;
        }else{
            label.layer.shadowColor = [UIColor colorWithRed:0.937 green:0.337 blue:0.157 alpha:1].CGColor;
        }
        label.layer.shadowOffset = CGSizeFromString([_selectedFontProperty objectForKey:@"shadowOffset"]);
        label.layer.shadowOpacity = [[_selectedFontProperty objectForKey:@"shadowOpacity"] floatValue];
        NSArray *fontColors = [[_selectedFontProperty objectForKey:@"fontColor"] componentsSeparatedByString:@","];
        if (fontColors!=nil && [fontColors count] == 4) {
            [label setTextColor:[UIColor colorWithRed:[fontColors[0] floatValue]/255 green:[fontColors[1] floatValue]/255 blue:[fontColors[2] floatValue]/255 alpha:[fontColors[3] floatValue]]];
        }else{
            [label setTextColor:[UIColor colorWithRed:0.937 green:0.337 blue:0.157 alpha:0.7]];
        }
        NSMutableString *whiteSpace = [NSMutableString new];
        NSInteger count = [[_selectedFontProperty objectForKey:@"distance"] integerValue];
        for (int i = 0; i < count; i++) {
            [whiteSpace appendString:@" "];
        }
        if ([[SettingModel sharedInstance] isRandom]) {
            if ([@"" isEqualToString:_tempDateString]) {
                NSString *year = [self getRandomNumber:0 to:99];
                NSString *month = [self getRandomNumber:1 to:12];
                NSString *day = [self getRandomNumber:1 to:31];
                NSMutableString * dateString = [[NSMutableString alloc]initWithString:@"'"];
                [dateString appendString:year];
                [dateString appendString:whiteSpace];
                [dateString appendString:month];
                [dateString appendString:whiteSpace];
                [dateString appendString:day];
                [label setText:dateString];
                _tempDateString = dateString;
            }else{
                [label setText:_tempDateString];
            }
        }else{
            NSMutableString * dateString = [[NSMutableString alloc] initWithString:[[SettingModel sharedInstance] customDate]];
            NSString *resultDateString = [dateString stringByReplacingOccurrencesOfString:@" " withString:@""];
            NSArray *array = [resultDateString componentsSeparatedByString:@"/"];
            NSMutableString *result = [[NSMutableString alloc] initWithString:@"'"];
            for (int i = 0; i < [array count]; i++) {
                NSMutableString *string = [array objectAtIndex:i];
                if ([string length] > 2) {
                    string = [string substringFromIndex:string.length - 2];
                }
                [result appendString:string];
                if (i != [array count] - 1) {
                    [result appendString:whiteSpace];
                }
            }
            [label setText:result];
        }
        [imageView addSubview:label];
        CGSize size = [label.text sizeWithAttributes:@{NSFontAttributeName: font}];
        CGSize adaptionSize = CGSizeMake(ceilf(size.width), ceilf(size.height));
        CGSize gap = CGSizeFromString([_selectedFontProperty objectForKey:@"position"]);
        label.frame = CGRectMake(imageView.frame.size.width - adaptionSize.width - gap.width*base, imageView.frame.size.height - gap.height*base, adaptionSize.width, adaptionSize.height);
        UIImage *resultImage = [self convertViewToImage:imageView andScale:self.oriImage.scale];
        self.mainImageView.image = resultImage;
    }else{
        self.mainImageView.image = image;
    }
}
- (UIImage *)convertViewToImage:(UIView*)view andScale:(CGFloat)scale{
    CGSize size = view.bounds.size;
    UIGraphicsBeginImageContextWithOptions(size, NO, scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImage *resultImage = [[UIImage alloc] initWithCGImage:image.CGImage scale:scale orientation:self.oriImage.imageOrientation];
    return resultImage;
}
-(NSString *)getRandomNumber:(int)from to:(int)to
{
    int randomNum = (int)(from + (arc4random() % (to - from + 1)));
    NSLog(@"随机到的数值：%d",randomNum);
    if (randomNum < 10 && randomNum >= 0) {
        return [NSString stringWithFormat:@"0%d",randomNum];
    }
    return [NSString stringWithFormat:@"%d",randomNum];
}
-(UIImage *)addFilterForImage{
    UIImage *image = self.oriImage;
    NSDictionary *dict = [_filterPlistArray objectAtIndex:_selectFilterIndex];
    NSString *filterString = [dict objectForKey:@"filter"];
    if ([@"" isEqualToString:filterString]) {
        return nil;
    }
    NSArray *filters = [filterString componentsSeparatedByString:@","];
    NSInteger num = [[self getRandomNumber:0 to:(int)([filters count] - 1)] integerValue];
    NSString *filterName = [filters objectAtIndex:num];
    if ([filterName hasSuffix:@".acv"]) {
        _editSlider.hidden = NO;
        _editSlider.maximumValue = 1.5;
        _editSlider.minimumValue = 0.5;
        _editSlider.value = 1;
        UIImage *newImage = [self acvForImage:image acvData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:filterName ofType:nil]] mix:1];
        if (newImage) {
            image = newImage;
        }
    }else{
        _editSlider.hidden = YES;
        [_picSource removeAllTargets];
        _classFilter = [[[NSClassFromString(filterName) class] alloc] init];
        [_picSource addTarget:_classFilter];
        [_classFilter useNextFrameForImageCapture];
        [_picSource processImage];
        UIImage *newImage = [_classFilter imageFromCurrentFramebufferWithOrientation:self.oriImage.imageOrientation];
        if (newImage) {
            image = newImage;
        }
    }
    return image;
}
- (void)selectFilterButtonWithIndex:(NSInteger)index{
    for (int i = 0; i < [_filterPlistArray count]; i++) {
        if (i == index) {
            [(UIButton *)[_filterScrollView viewWithTag:i + 1] setBackgroundColor:itemBonderColor];
        }else{
            [(UIButton *)[_filterScrollView viewWithTag:i + 1] setBackgroundColor:itemBackGroundColor];
        }
    }
}
- (void)selectTextureButtonWithIndex:(NSInteger)index{
    for (int i = 0; i < [_texturePlistArray count]; i++) {
        if (i == index) {
            [(UIButton *)[_textureScrollView viewWithTag:i + 1] setBackgroundColor:itemBonderColor];
        }else{
            [(UIButton *)[_textureScrollView viewWithTag:i + 1] setBackgroundColor:itemBackGroundColor];
        }
    }
}
- (UIImage*)acvForImage:(UIImage*)image acvData:(NSData*)acvData mix:(CGFloat)mix
{
    [_picSource removeAllTargets];
    _acvFilter = [[PhotoXAcvFilter alloc]initWithACVData:acvData];
    _acvFilter.mix = mix;
    [_picSource addTarget:_acvFilter];
    [_acvFilter useNextFrameForImageCapture];
    [_picSource processImage];
    return [_acvFilter imageFromCurrentFramebufferWithOrientation:self.oriImage.imageOrientation];
}
-(void)playSound{
    if ([[SettingModel sharedInstance] isSound]) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"sound" ofType:@"wav"];
        NSURL *fileUrl = [NSURL URLWithString:filePath];
        SystemSoundID soundID = 0;
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)(fileUrl), &soundID);
        AudioServicesAddSystemSoundCompletion(soundID,NULL,NULL,soundCompleteCallBack,NULL);
        AudioServicesPlaySystemSound(soundID);
    }
}
void soundCompleteCallBack(SystemSoundID soundID, void *clientData)
{
    NSLog(@"播放完成");
}
-(IBAction)onFilter:(EffectCustomButton *)sender{
    NSDictionary *dict = [_filterPlistArray objectAtIndex:sender.tag - 1];
        _selectTextureIndex = -1;
        _selectFilterIndex = sender.tag - 1;
        [self selectFilterButtonWithIndex:_selectFilterIndex];
        [self playSound];
        UIImage *image = [self addFilterForImage];
        if (image) {
            _tempImage = image;
            _selectedFontProperty = [dict objectForKey:@"FontProperty"];
            _tempDateString = @"";
            [self addDateSignWithImage:image];
        }else{
            _editSlider.hidden = YES;
            self.mainImageView.image = self.resetImage;
            self.oriImage = self.resetImage;
            _selectedFontProperty = nil;
        }
}
-(IBAction)onTextures:(EffectCustomButton *)sender{
    NSDictionary *dict = [_texturePlistArray objectAtIndex:sender.tag - 1];
        _selectFilterIndex = -1;
        _selectTextureIndex = sender.tag - 1;
        [self selectTextureButtonWithIndex:_selectTextureIndex];
        [self playSound];
        NSString *textrueString = [dict objectForKey:@"texture"];
        if ([@"" isEqualToString:textrueString]) {
            _editSlider.hidden = YES;
            self.mainImageView.image = self.resetImage;
            self.oriImage = self.resetImage;
            _selectedFontProperty = nil;
        }else{
            NSArray *textures = [textrueString componentsSeparatedByString:@","];
            NSInteger num = [[self getRandomNumber:0 to:(int)([textures count] - 1)] integerValue];
            NSString *textureName = [textures objectAtIndex:num];
            UIImage *texture = [UIImage imageNamed:textureName];
            _editSlider.hidden = NO;
            _editSlider.maximumValue = 1;
            _editSlider.minimumValue = 0.1;
            _editSlider.value = 1;
            UIImage *newImage = [self alphaBlendingFiltering:self.oriImage andOverImage:texture andFilterMix:1.0];
            _tempImage = newImage;
            if (newImage) {
                _selectedFontProperty = [dict objectForKey:@"FontProperty"];
                _tempDateString = @"";
                [self addDateSignWithImage:newImage];
            }
        }
}
- (void)alertUnlockFilterWithImageName:(NSString *)imageName andIndex:(NSInteger)index{
    [self initUnlockBackground];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    [_unlockBackgroundView addSubview:imageView];
    imageView.tag = index + 1;
    imageView.center = CGPointMake(_unlockBackgroundView.center.x, _unlockBackgroundView.center.y + _unlockBackgroundView.bounds.size.height);
    UITapGestureRecognizer *tapToUnlock = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onUnlockFilter:)];
    [imageView setUserInteractionEnabled:YES];
    [imageView addGestureRecognizer:tapToUnlock];
    [UIView animateWithDuration: 0.5 delay: 0 usingSpringWithDamping: 0.8 initialSpringVelocity: 0 options: UIViewAnimationOptionCurveLinear animations: ^{
        imageView.center = self->_unlockBackgroundView.center;
    } completion: nil];
}
- (void)alertUnlockTextureWithImageName:(NSString *)imageName andIndex:(NSInteger)index{
    [self initUnlockBackground];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    [_unlockBackgroundView addSubview:imageView];
    imageView.tag = index + 1;
    imageView.center = CGPointMake(_unlockBackgroundView.center.x, _unlockBackgroundView.center.y + _unlockBackgroundView.bounds.size.height);
    UITapGestureRecognizer *tapToUnlock = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onUnlockTexture:)];
    [imageView setUserInteractionEnabled:YES];
    [imageView addGestureRecognizer:tapToUnlock];
    [UIView animateWithDuration: 0.5 delay: 0 usingSpringWithDamping: 0.8 initialSpringVelocity: 0 options: UIViewAnimationOptionCurveLinear animations: ^{
        imageView.center = self->_unlockBackgroundView.center;
    } completion: nil];
}
- (void)initUnlockBackground{
    _unlockBackgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
    [_unlockBackgroundView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.7]];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onHideUnlockAlert)];
    [_unlockBackgroundView setUserInteractionEnabled:YES];
    [_unlockBackgroundView addGestureRecognizer:tap];
    [self.view addSubview:_unlockBackgroundView];
}
- (void)onUnlockFilter:(UIGestureRecognizer *)gesture{
    [MBProgressHUD showActivityMessageInView:NSLocalizedString(@"Loading", nil)];
}
- (void)onUnlockTexture:(UIGestureRecognizer *)gesture{
    [MBProgressHUD showActivityMessageInView:NSLocalizedString(@"Loading", nil)];
}
- (void)onHideUnlockAlert{
    [_unlockBackgroundView removeFromSuperview];
    _unlockBackgroundView = nil;
}
- (void)selectEditButtonWithIndex:(NSInteger)index{
    for (int i = 0; i < [_titles count]; i++) {
        if (i == index) {
            [(UIButton *)[_editScrollView viewWithTag:i + 1] setSelected:YES];
        }else{
            [(UIButton *)[_editScrollView viewWithTag:i + 1] setSelected:NO];
        }
    }
}
- (IBAction)editBarClick:(UIButton *)sender{
    [self clearEditFilters];
    _selectEditIndex = sender.tag - 1;
    [self selectEditButtonWithIndex:_selectEditIndex];
    NSString *key = [_titles objectAtIndex:_selectEditIndex];
    switch (_selectEditIndex) {
        case 0:
            _editSlider.maximumValue = 1;
            _editSlider.minimumValue = 0;
            break;
        case 1:
            _editSlider.minimumValue = 0.0;
            _editSlider.maximumValue = 1.5;
            break;
        case 2:
            _editSlider.minimumValue = 0;
            _editSlider.maximumValue = 10000.0;
            break;
        case 3:
            _editSlider.maximumValue = 1;
            _editSlider.minimumValue = -1;
            break;
        case 4:
            _editSlider.maximumValue = 3;
            _editSlider.minimumValue = 0.3;
            break;
        case 5:
            _editSlider.maximumValue = 2;
            _editSlider.minimumValue = 0;
            break;
        case 6:
            _editSlider.maximumValue = 0.8;
            _editSlider.minimumValue = -0.8;
            break;
        case 7:
            _editSlider.maximumValue = 1;
            _editSlider.minimumValue = 0;
            break;
        case 8:
            _editSlider.maximumValue = 0.6;
            _editSlider.minimumValue = 0.4;
            break;
        default:
            break;
    }
    _editSlider.value = [[_sliderContent objectForKey:key] floatValue];
}
- (void)initTopBar{
    _navigationBar = [[[NSBundle mainBundle] loadNibNamed:@"EditNavigationBar" owner:self options:nil] lastObject];
    if (Is_iPhoneX) {
        [_navigationBar setFrame:CGRectMake(0, 0, self.view.frame.size.width,94)];
    }else{
        [_navigationBar setFrame:CGRectMake(0, 0, self.view.frame.size.width,50)];
    }
    [self.view addSubview:_navigationBar];
    [_navigationBar.backBtn addTarget:self action:@selector(onBack:) forControlEvents:UIControlEventTouchUpInside];
    [_navigationBar.settingBtn addTarget:self action:@selector(onSetting:) forControlEvents:UIControlEventTouchUpInside];
    [_navigationBar.buyBtn addTarget:self action:@selector(onBuy:) forControlEvents:UIControlEventTouchUpInside];
    [_navigationBar.nextBtn addTarget:self action:@selector(onFinish:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)initBottomBar{
    int safeBottom = 0;
    if (Is_iPhoneX) {
        safeBottom = 34;
    }
    _bottomTabbar = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 40 - safeBottom, self.view.bounds.size.width, 40)];
    [self.view addSubview:_bottomTabbar];
    for (int i = 0; i < [_bottomTitles count]; i++) {
        UIButton *button = [self getButtonWithTitle:[_bottomTitles objectAtIndex:i] andTag:i+1];
        [_bottomTabbar addSubview:button];
    }
}
- (UIButton *)getButtonWithTitle:(NSString *)title andTag:(int)tag{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((tag - 1 )*self.view.bounds.size.width/3, 0, self.view.bounds.size.width/3, 40)];
    [button setTag:tag];
    UIFont *font = [UIFont systemFontOfSize:10];
    [button.titleLabel setFont:font];
    [button.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:0.341 green:0.341 blue:0.341 alpha:1.000] forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor blackColor]];
    [button addTarget:self action:@selector(onClickBottom:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}
-(IBAction)onClickBottom:(UIButton *)sender{
    [self selectBottomTabWithIndex:sender.tag - 1];
}
-(IBAction)onBuy:(id)sender{
    UnlockViewController *viewController = [[UnlockViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}
-(IBAction)onBack:(id)sender{
    if ([self.delegate respondsToSelector:@selector(didClickCancelButtonWithEditController:)]) {
        [self.delegate didClickCancelButtonWithEditController:self];
    }
}
-(IBAction)onFinish:(id)sender{
    if ([self.delegate respondsToSelector:@selector(didClickFinishButtonWithEditController:newImage:)]) {
        [self.delegate didClickFinishButtonWithEditController:self newImage:self.mainImageView.image];
    }
}
-(IBAction)onSetting:(id)sender{
    _alphaView = [[UIView alloc] initWithFrame:self.view.bounds];
    [_alphaView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_alphaView];
    SettingView *settingView = [[[NSBundle mainBundle] loadNibNamed:@"SettingView" owner:self options:nil] lastObject];
    if (IS_PAD) {
        [settingView setFrame:CGRectMake(- self.view.bounds.size.width * 0.4, 0, self.view.bounds.size.width * 0.4, self.view.bounds.size.height)];
    }else{
        [settingView setFrame:CGRectMake(- self.view.bounds.size.width, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    }
    settingView.tag = 1;
    [_alphaView addSubview:settingView];
    [_alphaView setHidden:NO];
    [UIView animateWithDuration:0.3 animations:^{
        CGRect temp = settingView.frame;
        temp.origin.x = 0;
        settingView.frame = temp;
    } completion:^(BOOL finished) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onCloseSettingView)];
        [self->_alphaView setUserInteractionEnabled:YES];
        [self->_alphaView addGestureRecognizer:tap];
    }];
}
- (void)onCloseSettingView{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect temp = [self->_alphaView viewWithTag:1].frame;
        temp.origin.x = - temp.size.width;
        [self->_alphaView viewWithTag:1].frame = temp;
    } completion:^(BOOL finished) {
        [self->_alphaView removeFromSuperview];
    }];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCloseSettingView) name:HIDE_SETTING_ANIMATION object:nil];
    if (_filterScrollView && _filterPlistArray) {
        for (int i = 0; i< [_filterPlistArray count]; i++) {
            EffectCustomButton *button = [_filterScrollView viewWithTag:i+1];;
            [button setLayoutWithContent:[_filterPlistArray objectAtIndex:i]];
        }
    }
    if (_texturePlistArray &&_textureScrollView ) {
        for (int i = 0; i< [_texturePlistArray count]; i++) {
            EffectCustomButton *button = [_textureScrollView viewWithTag:i+1];;
            [button setLayoutWithContent:[_texturePlistArray objectAtIndex:i]];
        }
    }
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:HIDE_SETTING_ANIMATION object:nil];
}
@end
