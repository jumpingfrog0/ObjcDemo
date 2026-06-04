//
//  JFUIKitDemoViewController.m
//  ObjcDemo
//
//  Created by huangdonghong on 2026/5/25.
//

#import "JFUIKitDemoViewController.h"
#import <JFUIKit/JFUIKit.h>
#import <Masonry/Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>

#if __has_include(<JFUIKit/UIImageView+JFDownloadCheck.h>)
#import <JFUIKit/UIImageView+JFDownloadCheck.h>
#define JF_IMAGE_VIEW_DOWNLOAD_CHECK_AVAILABLE 1
#else
#define JF_IMAGE_VIEW_DOWNLOAD_CHECK_AVAILABLE 0
#endif

@interface JFUIKitDemoTextFieldProxy : NSObject <UITextFieldDelegate>
@end

@implementation JFUIKitDemoTextFieldProxy

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return [UITextField jf_textField:textField
                               range:range
                              string:string
                           charsType:JFTextFieldCharsTypeNumeral
                           maxLength:11
                     separatorIndexs:@[@3, @8]
                           separator:@" "];
}

@end

@interface JFUIKitDemoViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate>

@property (nonatomic, copy) NSString *demoType;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIStackView *stackView;
@property (nonatomic, strong) JFUIKitDemoTextFieldProxy *textFieldProxy;
@property (nonatomic, strong) UILabel *buttonTapCountLabel;
@property (nonatomic, assign) NSInteger buttonTapCount;
@property (nonatomic, strong) UIButton *strokeAnimationButton;
@property (nonatomic, strong) UIImageView *downloadImageView;
@property (nonatomic, strong) UILabel *downloadLogLabel;
@property (nonatomic, strong) UILabel *textFieldLimitLabel;
@property (nonatomic, strong) UILabel *textViewLimitLabel;
@property (nonatomic, strong) UILabel *bounceStateLabel;
@property (nonatomic, strong) UITableView *cellTableView;
@property (nonatomic, strong) UICollectionView *cellCollectionView;
@property (nonatomic, strong) UIView *floatingAnimationView;

@end

@implementation JFUIKitDemoViewController

- (instancetype)initWithDemoType:(NSString *)demoType title:(NSString *)title
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _demoType = [demoType copy];
        self.title = title;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    [self setupScrollStack];
    [self buildDemo];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];

    if ([self.demoType isEqualToString:@"UIView"]) {
        for (UIView *view in self.stackView.arrangedSubviews) {
            if (view.tag == 5001 && view.layer.sublayers.count == 0) {
                [view jf_setGradientLayer:[UIColor jf_colorFromHex:0x3D5AFE]
                                 endColor:[UIColor jf_colorFromHex:0x00BFA5]
                             isHorizontal:YES];
            }
            if (view.tag == 5002 && view.layer.sublayers.count == 0) {
                [view jf_setHollowWithMaskColor:[[UIColor blackColor] colorWithAlphaComponent:0.62]
                                           rect:CGRectInset(view.bounds, 48, 22)];
            }
            if (view.tag == 5003 && view.layer.sublayers.count == 0) {
                [view jf_addCycleProgress:0.72 color:[UIColor systemOrangeColor] width:8];
            }
            if (view.tag == 5004 && view.layer.mask == nil) {
                [view jf_addRoundCornersWithTopLeading:24 topTrailing:8 bottomLeading:8 bottomTrailing:24];
                [view jf_addBorderOnMaskLayer:[UIColor systemBlueColor] width:2];
            }
            if (view.tag == 5005 && view.layer.sublayers.count == 0) {
                [view jf_addRoundCornersWithTopLeading:10 topTrailing:26 bottomLeading:26 bottomTrailing:10];
                [view jf_addGradientBorderOnMaskLayer:@[(id)[UIColor systemPinkColor].CGColor, (id)[UIColor systemTealColor].CGColor]
                                                width:3
                                         isHorizontal:YES];
            }
        }
    }
}

- (void)setupScrollStack
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    self.scrollView.alwaysBounceVertical = YES;
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.leading.trailing.bottom.equalTo(self.view);
    }];

    self.stackView = [[UIStackView alloc] initWithFrame:CGRectZero];
    self.stackView.axis = UILayoutConstraintAxisVertical;
    self.stackView.spacing = 16;
    self.stackView.layoutMargins = UIEdgeInsetsMake(16, 16, 32, 16);
    self.stackView.layoutMarginsRelativeArrangement = YES;
    [self.scrollView addSubview:self.stackView];
    [self.stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.scrollView);
        make.leading.trailing.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
}

- (void)buildDemo
{
    if ([self.demoType isEqualToString:@"UIAlertController"]) {
        [self buildAlertControllerDemo];
    } else if ([self.demoType isEqualToString:@"UIApplication"]) {
        [self buildApplicationDemo];
    } else if ([self.demoType isEqualToString:@"UIButton"]) {
        [self buildButtonDemo];
    } else if ([self.demoType isEqualToString:@"UIColor"]) {
        [self buildColorDemo];
    } else if ([self.demoType isEqualToString:@"UICollectionViewCell"]) {
        [self buildCollectionViewCellDemo];
    } else if ([self.demoType isEqualToString:@"UIDevice"]) {
        [self buildDeviceDemo];
    } else if ([self.demoType isEqualToString:@"UIImage"]) {
        [self buildImageDemo];
    } else if ([self.demoType isEqualToString:@"UIImageView"]) {
        [self buildImageViewDemo];
    } else if ([self.demoType isEqualToString:@"UIView"]) {
        [self buildViewDemo];
    } else if ([self.demoType isEqualToString:@"UILabel"]) {
        [self buildLabelDemo];
    } else if ([self.demoType isEqualToString:@"UITextField"]) {
        [self buildTextFieldDemo];
    } else if ([self.demoType isEqualToString:@"UITextView"]) {
        [self buildTextViewDemo];
    } else if ([self.demoType isEqualToString:@"UIScrollView"]) {
        [self buildScrollViewDemo];
    } else if ([self.demoType isEqualToString:@"UITabBar"]) {
        [self buildTabBarDemo];
    } else if ([self.demoType isEqualToString:@"UITableViewCell"]) {
        [self buildTableViewCellDemo];
    } else if ([self.demoType isEqualToString:@"Navigation"]) {
        [self buildNavigationDemo];
    } else if ([self.demoType isEqualToString:@"AlertToast"]) {
        [self buildAlertToastDemo];
    } else {
        [self buildApplicationDemo];
    }
}

- (UILabel *)titleLabel:(NSString *)text
{
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.font = [UIFont boldSystemFontOfSize:17];
    label.textColor = [UIColor colorWithWhite:0.12 alpha:1.0];
    label.numberOfLines = 0;
    return label;
}

- (UILabel *)bodyLabel:(NSString *)text
{
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor colorWithWhite:0.28 alpha:1.0];
    label.numberOfLines = 0;
    return label;
}

- (UIView *)panel
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1.0];
    view.layer.cornerRadius = 8;
    view.layer.borderColor = [UIColor colorWithWhite:0.88 alpha:1.0].CGColor;
    view.layer.borderWidth = 1.0 / UIScreen.mainScreen.scale;
    return view;
}

- (UIButton *)demoButton:(NSString *)title action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    button.layer.cornerRadius = 8;
    button.layer.borderWidth = 1.0 / UIScreen.mainScreen.scale;
    button.layer.borderColor = [UIColor systemBlueColor].CGColor;
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)addFixedHeight:(UIView *)view height:(CGFloat)height
{
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
    }];
}

- (void)addImage:(UIImage *)image title:(NSString *)title
{
    UIStackView *row = [[UIStackView alloc] init];
    row.axis = UILayoutConstraintAxisHorizontal;
    row.alignment = UIStackViewAlignmentCenter;
    row.spacing = 12;

    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.backgroundColor = [UIColor colorWithWhite:0.94 alpha:1.0];
    imageView.layer.cornerRadius = 8;
    imageView.clipsToBounds = YES;

    [row addArrangedSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(92);
        make.height.mas_equalTo(72);
    }];
    [row addArrangedSubview:[self bodyLabel:title]];
    [self.stackView addArrangedSubview:row];
}

- (void)buildColorDemo
{
    [self.stackView addArrangedSubview:[self bodyLabel:@"展示 UIColor+JFExtension 的 hex 创建、alpha 和颜色反解。"]];

    NSArray<UIColor *> *colors = @[
        [UIColor jf_colorFromHex:0x1E88E5],
        [UIColor jf_colorFromHex:0x43A047 alpha:0.65],
        [UIColor jf_colorWithHex:@"#FF7043"],
        [UIColor jf_colorWithHex:@"0x7E57C2CC"],
        [UIColor jf_randomColor],
    ];

    for (UIColor *color in colors) {
        UIStackView *row = [[UIStackView alloc] init];
        row.axis = UILayoutConstraintAxisHorizontal;
        row.alignment = UIStackViewAlignmentCenter;
        row.spacing = 12;

        UIView *swatch = [[UIView alloc] init];
        swatch.backgroundColor = color;
        swatch.layer.cornerRadius = 8;

        NSString *text = [NSString stringWithFormat:@"hex=%@ rgba=(%.2f, %.2f, %.2f, %.2f)",
                                                    [color jf_hexValueWithAlpha:YES],
                                                    [color jf_red],
                                                    [color jf_green],
                                                    [color jf_blue],
                                                    [color jf_alpha]];
        [row addArrangedSubview:swatch];
        [swatch mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(80);
            make.height.mas_equalTo(44);
        }];
        [row addArrangedSubview:[self bodyLabel:text]];
        [self.stackView addArrangedSubview:row];
    }
}

- (void)buildImageDemo
{
    UIImage *base = [UIImage jf_gradientImageWithColors:@[[UIColor systemBlueColor], [UIColor systemTealColor]]
                                                   size:CGSizeMake(180, 120)
                                              locations:@[@0, @1]
                                             startPoint:CGPointMake(0, 0)
                                               endPoint:CGPointMake(1, 1)
                                           cornerRadius:18];
    UIImage *solid = [UIImage jf_imageWithColor:[UIColor systemPinkColor] size:CGSizeMake(90, 90)];
    UIImage *rounded = [UIImage jf_imageWithSize:CGSizeMake(160, 90) color:[UIColor systemOrangeColor] cornerRadius:18];
    UIImage *resized = [base jf_resizedImage:CGSizeMake(90, 60) interpolationQuality:kCGInterpolationHigh];
    UIImage *circle = [base jf_centeredCircleImageWithSize:CGSizeMake(90, 90) radius:45];
    UIImage *gray = [base jf_grayScaleImage];
    UIImage *tinted = [base jf_tintedImageWithColor:[[UIColor systemPurpleColor] colorWithAlphaComponent:0.45]];
    UIImage *blur = [base jf_gaussianBlurWithRadius:8];
    NSString *base64 = [solid jf_base64DataString];
    UIImage *fromBase64 = [UIImage jf_imageFromBase64EncodedString:base64];

    [self addImage:base title:@"jf_gradientImageWithColors"];
    [self addImage:solid title:@"jf_imageWithColor:size"];
    [self addImage:rounded title:@"jf_imageWithSize:color:cornerRadius"];
    [self addImage:resized title:@"jf_resizedImage"];
    [self addImage:circle title:@"jf_centeredCircleImageWithSize"];
    [self addImage:gray title:@"jf_grayScaleImage"];
    [self addImage:tinted title:@"jf_tintedImageWithColor"];
    [self addImage:blur title:@"jf_gaussianBlurWithRadius"];
    [self addImage:fromBase64 title:[NSString stringWithFormat:@"base64 round trip length=%lu", (unsigned long)base64.length]];

    [self.stackView addArrangedSubview:[self titleLabel:@"UIImage+JFCheckName"]];
    [self.stackView addArrangedSubview:[self demoButton:@"启用 imageNamed 缺图检查" action:@selector(enableImageNamedCheck)]];
    [self.stackView addArrangedSubview:[self demoButton:@"确认后触发缺图断言" action:@selector(confirmTriggerMissingImageCheck)]];
}

- (void)buildViewDemo
{
    [self.stackView addArrangedSubview:[self bodyLabel:@"展示 UIView 的 frame 快捷属性、渐变、镂空、进度环、blur 和截图。"]];

    UIView *rectPanel = [self panel];
    [self addFixedHeight:rectPanel height:110];
    UIView *moving = [[UIView alloc] initWithFrame:CGRectMake(18, 22, 72, 44)];
    moving.backgroundColor = [UIColor systemBlueColor];
    moving.jf_left = 28;
    moving.jf_top = 32;
    moving.jf_width = 120;
    moving.jf_height = 48;
    [moving jf_addRoundedCorners:UIRectCornerTopLeft | UIRectCornerBottomRight withRadius:16];
    [rectPanel addSubview:moving];
    [self.stackView addArrangedSubview:[self titleLabel:@"UIView+JFRect / rounded corners"]];
    [self.stackView addArrangedSubview:rectPanel];

    UIView *gradient = [self panel];
    gradient.tag = 5001;
    [self addFixedHeight:gradient height:88];
    [self.stackView addArrangedSubview:[self titleLabel:@"jf_setGradientLayer"]];
    [self.stackView addArrangedSubview:gradient];

    UIView *hollow = [[UIView alloc] init];
    hollow.backgroundColor = [UIColor clearColor];
    hollow.tag = 5002;
    [self addFixedHeight:hollow height:118];
    [self.stackView addArrangedSubview:[self titleLabel:@"jf_setHollowWithMaskColor"]];
    [self.stackView addArrangedSubview:hollow];

    UIView *progress = [self panel];
    progress.tag = 5003;
    [self addFixedHeight:progress height:120];
    [self.stackView addArrangedSubview:[self titleLabel:@"jf_addCycleProgress"]];
    [self.stackView addArrangedSubview:progress];

    UIView *maskBorder = [self panel];
    maskBorder.tag = 5004;
    maskBorder.backgroundColor = [UIColor colorWithWhite:0.97 alpha:1.0];
    [self addFixedHeight:maskBorder height:88];
    [self.stackView addArrangedSubview:[self titleLabel:@"自定义圆角 + mask border"]];
    [self.stackView addArrangedSubview:maskBorder];

    UIView *gradientBorder = [self panel];
    gradientBorder.tag = 5005;
    gradientBorder.backgroundColor = [UIColor whiteColor];
    [self addFixedHeight:gradientBorder height:88];
    [self.stackView addArrangedSubview:[self titleLabel:@"自定义圆角 + gradient border"]];
    [self.stackView addArrangedSubview:gradientBorder];

    UIView *animationPanel = [self panel];
    [self addFixedHeight:animationPanel height:120];
    self.floatingAnimationView = [[UIView alloc] init];
    self.floatingAnimationView.backgroundColor = [UIColor systemPinkColor];
    self.floatingAnimationView.layer.cornerRadius = 16;
    [animationPanel addSubview:self.floatingAnimationView];
    [self.floatingAnimationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(animationPanel);
        make.width.height.mas_equalTo(32);
    }];
    [self.stackView addArrangedSubview:[self titleLabel:@"pause / resume / floating animation"]];
    [self.stackView addArrangedSubview:animationPanel];
    [self.stackView addArrangedSubview:[self demoButton:@"开始漂浮动画" action:@selector(startFloatingAnimation)]];
    [self.stackView addArrangedSubview:[self demoButton:@"暂停动画" action:@selector(pauseFloatingAnimation)]];
    [self.stackView addArrangedSubview:[self demoButton:@"恢复动画" action:@selector(resumeFloatingAnimation)]];

    UIView *dragPanel = [self panel];
    [self addFixedHeight:dragPanel height:160];
    UIView *dragView = [[UIView alloc] init];
    dragView.backgroundColor = [UIColor systemTealColor];
    dragView.layer.cornerRadius = 24;
    [dragView jf_addScreenMoveGestureWithLeadingMargin:16 topMargin:100];
    [dragPanel addSubview:dragView];
    [dragView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(dragPanel).offset(18);
        make.centerY.equalTo(dragPanel);
        make.width.height.mas_equalTo(48);
    }];
    [self.stackView addArrangedSubview:[self titleLabel:@"拖拽后贴边手势"]];
    [self.stackView addArrangedSubview:dragPanel];

    UIView *blur = [self panel];
    blur.backgroundColor = [UIColor jf_colorFromHex:0x1E88E5];
    blur.jf_blurTintColor = [UIColor blackColor];
    blur.jf_blurIntensity = 0.25;
    blur.jf_blurStyle = JFBlurEffectStyleLight;
    [blur jf_enableBlur:YES];
    [self addFixedHeight:blur height:88];
    [self.stackView addArrangedSubview:[self titleLabel:@"jf_enableBlur"]];
    [self.stackView addArrangedSubview:blur];

    UIButton *shotButton = [self demoButton:@"生成当前页面截图" action:@selector(showScreenshotPreview)];
    [self.stackView addArrangedSubview:shotButton];
}

- (void)buildLabelDemo
{
    UILabel *range = [self bodyLabel:@"UILabel 局部文字颜色：红色文字在这里"];
    [range jf_setTextColor:[UIColor systemRedColor] range:NSMakeRange(13, 4)];
    [self.stackView addArrangedSubview:range];

    UILabel *keyword = [self bodyLabel:@"关键词高亮：JFUIKit 可以快速查看效果"];
    [keyword jf_setKeywordColor:[UIColor systemBlueColor] keyword:@"JFUIKit"];
    [self.stackView addArrangedSubview:keyword];

    UILabel *lineSpacing = [self bodyLabel:@"第一行：行距效果\n第二行：更易观察\n第三行：使用 jf_setLineSpacing"];
    [lineSpacing jf_setLineSpacing:10];
    [self.stackView addArrangedSubview:lineSpacing];

    UILabel *lineHeight = [self bodyLabel:@"lineHeightMultiple = 1.6\n文本块用于查看多行排版变化。"];
    [lineHeight jf_setLineHeightMultiple:1.6];
    [self.stackView addArrangedSubview:lineHeight];

    UILabel *strike = [self bodyLabel:@"这是一段删除线文本"];
    [strike jf_strikethrough];
    [self.stackView addArrangedSubview:strike];

    UILabel *factory = [UILabel jf_labelWithTextColor:[UIColor systemPurpleColor]
                                        textAlignment:NSTextAlignmentCenter
                                                 font:[UIFont boldSystemFontOfSize:16]];
    factory.text = @"通过 factory 创建的 UILabel";
    factory.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    [self addFixedHeight:factory height:44];
    [self.stackView addArrangedSubview:factory];

    UILabel *fit = [self bodyLabel:@"jf_fittedSize 会根据文本内容返回适配尺寸"];
    CGSize size = [fit jf_fittedSize];
    [self.stackView addArrangedSubview:[self bodyLabel:[NSString stringWithFormat:@"fittedSize = %.1f x %.1f", size.width, size.height]]];

    UILabel *clip = [self bodyLabel:@"裁剪到文字边界"];
    clip.backgroundColor = [[UIColor systemYellowColor] colorWithAlphaComponent:0.35];
    [clip jf_clipToTextBounds];
    [self.stackView addArrangedSubview:clip];
}

- (void)buildButtonDemo
{
    UIImage *icon = [UIImage jf_imageWithSize:CGSizeMake(28, 28) color:[UIColor systemBlueColor] cornerRadius:14];

    UIButton *vertical = [UIButton buttonWithType:UIButtonTypeCustom];
    [vertical setTitle:@"上下布局" forState:UIControlStateNormal];
    [vertical setTitleColor:[UIColor colorWithWhite:0.18 alpha:1.0] forState:UIControlStateNormal];
    [vertical setImage:icon forState:UIControlStateNormal];
    vertical.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    [vertical jf_alignVerticalWithSpacing:8];
    [self addFixedHeight:vertical height:88];
    [self.stackView addArrangedSubview:vertical];

    UIButton *horizontal = [UIButton buttonWithType:UIButtonTypeCustom];
    [horizontal setTitle:@"水平布局按钮" forState:UIControlStateNormal];
    [horizontal setTitleColor:[UIColor colorWithWhite:0.18 alpha:1.0] forState:UIControlStateNormal];
    [horizontal setImage:icon forState:UIControlStateNormal];
    horizontal.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    [horizontal jf_alignHorizontalWithSpacing:12];
    [horizontal jf_setTitleColor:[UIColor systemRedColor] range:NSMakeRange(0, 2)];
    [self addFixedHeight:horizontal height:56];
    [self.stackView addArrangedSubview:horizontal];

    UIView *hitPanel = [self panel];
    [self addFixedHeight:hitPanel height:120];
    UIButton *small = [UIButton buttonWithType:UIButtonTypeSystem];
    [small setTitle:@"小按钮" forState:UIControlStateNormal];
    small.backgroundColor = [UIColor systemYellowColor];
    small.layer.cornerRadius = 18;
    [small jf_setEnlargeEdgeWithTop:24 trailing:80 bottom:24 leading:80];
    [small addTarget:self action:@selector(countEnlargedButtonTap) forControlEvents:UIControlEventTouchUpInside];
    [hitPanel addSubview:small];
    [small mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(hitPanel);
        make.width.mas_equalTo(72);
        make.height.mas_equalTo(36);
    }];
    self.buttonTapCountLabel = [self bodyLabel:@"点击黄色按钮周围空白区域，命中次数：0"];
    [self.stackView addArrangedSubview:[self titleLabel:@"扩大点击区域"]];
    [self.stackView addArrangedSubview:hitPanel];
    [self.stackView addArrangedSubview:self.buttonTapCountLabel];

    self.strokeAnimationButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.strokeAnimationButton setTitle:@"描边动画按钮" forState:UIControlStateNormal];
    self.strokeAnimationButton.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    self.strokeAnimationButton.layer.cornerRadius = 36;
    [self addFixedHeight:self.strokeAnimationButton height:72];
    [self.stackView addArrangedSubview:self.strokeAnimationButton];
    [self.stackView addArrangedSubview:[self demoButton:@"添加圆形描边动画" action:@selector(runButtonStrokeAnimation)]];
    [self.stackView addArrangedSubview:[self demoButton:@"移除按钮动画" action:@selector(removeButtonStrokeAnimation)]];
}

- (void)buildTextFieldDemo
{
    [self.stackView addArrangedSubview:[self bodyLabel:@"输入框只允许数字，最多 11 位，并按 3-4-4 自动插入空格。"]];

    UITextField *field = [[UITextField alloc] init];
    field.borderStyle = UITextBorderStyleRoundedRect;
    field.keyboardType = UIKeyboardTypeNumberPad;
    [field jf_setPlaceholder:@"请输入手机号" color:[UIColor systemOrangeColor]];
    self.textFieldProxy = [JFUIKitDemoTextFieldProxy new];
    field.delegate = self.textFieldProxy;
    [self addFixedHeight:field height:46];
    [self.stackView addArrangedSubview:field];

    NSString *formatted = [UITextField jf_parseString:@"13800138000" separatorIndexs:@[@3, @8] separator:@" "];
    [self.stackView addArrangedSubview:[self bodyLabel:[NSString stringWithFormat:@"jf_parseString: %@", formatted]]];

    UITextField *limitField = [[UITextField alloc] init];
    limitField.borderStyle = UITextBorderStyleRoundedRect;
    limitField.placeholder = @"最多输入 6 个字符";
    [limitField addTarget:self action:@selector(textFieldLimitChanged:) forControlEvents:UIControlEventEditingChanged];
    [self addFixedHeight:limitField height:46];
    self.textFieldLimitLabel = [self bodyLabel:@"长度限制回调：未触发"];
    [self.stackView addArrangedSubview:[self titleLabel:@"UITextField 长度限制"]];
    [self.stackView addArrangedSubview:limitField];
    [self.stackView addArrangedSubview:self.textFieldLimitLabel];
}

- (void)buildScrollViewDemo
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"顶部"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(scrollCurrentPageToTop)];

    [self.stackView addArrangedSubview:[self bodyLabel:@"先向下滚动，再点击导航栏右侧“顶部”按钮调用 UIScrollView+JFScroll。"]];

    for (NSInteger i = 1; i <= 24; i++) {
        UILabel *label = [self bodyLabel:[NSString stringWithFormat:@"滚动内容行 %ld", (long)i]];
        label.backgroundColor = i % 2 == 0 ? [UIColor colorWithWhite:0.96 alpha:1.0] : [UIColor whiteColor];
        [self addFixedHeight:label height:38];
        [self.stackView addArrangedSubview:label];
    }

    self.bounceStateLabel = [self bodyLabel:[self scrollBounceStateText]];
    [self.stackView addArrangedSubview:self.bounceStateLabel];
    [self.stackView addArrangedSubview:[self demoButton:@"刷新 bounce 状态" action:@selector(refreshBounceState)]];
}

- (void)buildAlertControllerDemo
{
    [self.stackView addArrangedSubview:[self bodyLabel:@"message 对齐配置会直接作用在 UIAlertController 的 message 文本上。"]];
    [self.stackView addArrangedSubview:[self demoButton:@"显示居左 Alert" action:@selector(showAlignedAlert)]];
    [self.stackView addArrangedSubview:[self demoButton:@"显示 Action Sheet" action:@selector(showActionSheet)]];
}

- (void)buildApplicationDemo
{
    UIApplication *application = UIApplication.sharedApplication;
    NSArray<NSString *> *lines = @[
        [NSString stringWithFormat:@"Documents: %@", [UIApplication jf_documentsDirectoryPath]],
        [NSString stringWithFormat:@"Caches: %@", [UIApplication jf_cachesDirectoryPath]],
        [NSString stringWithFormat:@"Library: %@", [UIApplication jf_libraryDirectoryPath]],
        [NSString stringWithFormat:@"Visible key window: %@", [application jf_visibleKeyWindow] ?: @"nil"],
        [NSString stringWithFormat:@"Most top VC: %@", NSStringFromClass([[application jf_mostTopViewController] class])],
        [NSString stringWithFormat:@"Top bar height: %.1f", [UIApplication jf_topBarHeight]],
        [NSString stringWithFormat:@"Pirated: %@", [application jf_isPirated] ? @"YES" : @"NO"],
    ];

    for (NSString *line in lines) {
        [self.stackView addArrangedSubview:[self bodyLabel:line]];
    }
}

- (void)buildDeviceDemo
{
    NSArray<NSString *> *lines = @[
        [NSString stringWithFormat:@"AppVersion: %@", [UIDevice jf_appVersion]],
        [NSString stringWithFormat:@"Model: %@", [UIDevice jf_model]],
        [NSString stringWithFormat:@"ModelName: %@", [UIDevice jf_modelName]],
        [NSString stringWithFormat:@"IDFV: %@", [UIDevice jf_idfv]],
        [NSString stringWithFormat:@"iPhoneX family: %@", [UIDevice jf_isiPhoneX] ? @"YES" : @"NO"],
        [NSString stringWithFormat:@"Notch screen: %@", [UIDevice jf_isNotchScreen] ? @"YES" : @"NO"],
        [NSString stringWithFormat:@"Plus: %@", [UIDevice jf_isPlus] ? @"YES" : @"NO"],
        [NSString stringWithFormat:@"StatusBar height: %.1f", [UIDevice jf_statusBarHeight]],
        [NSString stringWithFormat:@"NavigationBar height: %.1f", [UIDevice jf_navigationBarHeight]],
        [NSString stringWithFormat:@"TabBar height: %.1f", [UIDevice jf_tabBarHeight]],
    ];

    for (NSString *line in lines) {
        [self.stackView addArrangedSubview:[self bodyLabel:line]];
    }
}

- (void)buildImageViewDemo
{
    [self.stackView addArrangedSubview:[self bodyLabel:@"DownloadCheck 是 Hook 子模块，只在本页显式启用后记录 SDWebImage 下载失败。"]];

    UIImageView *imageView = [[UIImageView alloc] init];
    self.downloadImageView = imageView;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.backgroundColor = [UIColor colorWithWhite:0.94 alpha:1.0];
    imageView.layer.cornerRadius = 8;
    imageView.clipsToBounds = YES;
    [self addFixedHeight:imageView height:140];
    [self.stackView addArrangedSubview:imageView];

    self.downloadLogLabel = [self bodyLabel:@"日志：未启用"];
    [self.stackView addArrangedSubview:self.downloadLogLabel];
    [self.stackView addArrangedSubview:[self demoButton:@"启用 Hook 并请求失败图片" action:@selector(enableDownloadCheckAndLoadFailedImage)]];
}

- (void)buildCollectionViewCellDemo
{
    [self.stackView addArrangedSubview:[self bodyLabel:[NSString stringWithFormat:@"UICollectionViewCell reuseIdentifier = %@", [UICollectionViewCell jf_reuseIdentifier]]]];

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 12;
    layout.minimumInteritemSpacing = 12;
    layout.sectionInset = UIEdgeInsetsMake(12, 12, 12, 12);

    self.cellCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.cellCollectionView.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1.0];
    self.cellCollectionView.dataSource = self;
    self.cellCollectionView.delegate = self;
    [self.cellCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:[UICollectionViewCell jf_reuseIdentifier]];
    [self addFixedHeight:self.cellCollectionView height:220];
    [self.stackView addArrangedSubview:self.cellCollectionView];
}

- (void)buildTableViewCellDemo
{
    [self.stackView addArrangedSubview:[self bodyLabel:[NSString stringWithFormat:@"UITableViewCell reuseIdentifier = %@", [UITableViewCell jf_reuseIdentifier]]]];

    self.cellTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.cellTableView.dataSource = self;
    self.cellTableView.delegate = self;
    self.cellTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.cellTableView.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1.0];
    [self.cellTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:[UITableViewCell jf_reuseIdentifier]];
    [self addFixedHeight:self.cellTableView height:260];
    [self.stackView addArrangedSubview:self.cellTableView];
}

- (void)buildTextViewDemo
{
    [self.stackView addArrangedSubview:[self bodyLabel:@"UITextView 最多保留 12 个字符，输入超长时会回调并截断；拼音高亮阶段不会截断。"]];

    UITextView *textView = [[UITextView alloc] init];
    textView.font = [UIFont systemFontOfSize:16];
    textView.layer.borderColor = [UIColor colorWithWhite:0.82 alpha:1.0].CGColor;
    textView.layer.borderWidth = 1.0 / UIScreen.mainScreen.scale;
    textView.layer.cornerRadius = 8;
    textView.text = @"试着输入超过十二个字";
    textView.delegate = self;
    [self addFixedHeight:textView height:140];
    self.textViewLimitLabel = [self bodyLabel:@"长度限制回调：未触发"];
    [self.stackView addArrangedSubview:textView];
    [self.stackView addArrangedSubview:self.textViewLimitLabel];
}

- (void)buildTabBarDemo
{
    [self.stackView addArrangedSubview:[self bodyLabel:@"中心按钮超出 UITabBar bounds，上方凸出区域仍应能响应点击。"]];

    UIView *container = [self panel];
    container.clipsToBounds = NO;
    [self addFixedHeight:container height:180];

    UITabBar *tabBar = [[UITabBar alloc] init];
    tabBar.clipsToBounds = NO;
    UITabBarItem *home = [[UITabBarItem alloc] initWithTitle:@"首页" image:nil tag:0];
    UITabBarItem *mine = [[UITabBarItem alloc] initWithTitle:@"我的" image:nil tag:1];
    tabBar.items = @[home, mine];
    [container addSubview:tabBar];
    [tabBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(container);
        make.height.mas_equalTo(72);
    }];

    UIButton *center = [UIButton buttonWithType:UIButtonTypeCustom];
    [center setTitle:@"发布" forState:UIControlStateNormal];
    [center setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    center.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    center.backgroundColor = [UIColor systemBlueColor];
    center.layer.cornerRadius = 32;
    [center addTarget:self action:@selector(showTabBarCenterHitResult) forControlEvents:UIControlEventTouchUpInside];
    [tabBar addSubview:center];
    [center mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(tabBar);
        make.centerY.equalTo(tabBar.mas_top).offset(4);
        make.width.height.mas_equalTo(64);
    }];

    [self.stackView addArrangedSubview:container];
}

- (void)buildNavigationDemo
{
    [self.navigationItem jf_setTitleViewWithText:@"JF 导航标题"];
    UIImage *dot = [UIImage jf_imageWithSize:CGSizeMake(24, 24) color:[UIColor systemRedColor] cornerRadius:12];
    UIBarButtonItem *badge = [UIBarButtonItem jf_badgeBarButtonItemWithImage:dot handler:^(__unused id sender) {
        NSLog(@"badge tapped");
    }];
    [badge jf_setBadge:8];
    self.navigationItem.rightBarButtonItem = badge;

    __weak typeof(self) weakSelf = self;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem jf_plainBarButtonItemWithTitle:@"关闭"
                                                                                  tintColor:[UIColor systemBlueColor]
                                                                                    handler:^(__unused id sender) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];

    [self.navigationController.navigationBar jf_setCustomBackgroundColor:[UIColor jf_colorFromHex:0xF5F8FF]];
    [self.stackView addArrangedSubview:[self bodyLabel:@"本页面进入后会设置 titleView、左侧文字按钮、右侧 badge 按钮和导航栏背景色。返回上一页时系统会恢复导航栈默认样式。"]];
    [self.stackView addArrangedSubview:[self demoButton:@"再 push 一个导航页面" action:@selector(pushNavigationSample)]];
}

- (void)buildAlertToastDemo
{
    [self.stackView addArrangedSubview:[self demoButton:@"显示 UIAlertController+JF show" action:@selector(showJFAlert)]];
    [self.stackView addArrangedSubview:[self demoButton:@"显示 UIView+JFTopToast" action:@selector(showJFToast)]];
}

- (void)buildAppDeviceDemo
{
    NSArray<NSString *> *lines = @[
        [NSString stringWithFormat:@"Documents: %@", [UIApplication jf_documentsDirectoryPath]],
        [NSString stringWithFormat:@"Caches: %@", [UIApplication jf_cachesDirectoryPath]],
        [NSString stringWithFormat:@"Library: %@", [UIApplication jf_libraryDirectoryPath]],
        [NSString stringWithFormat:@"AppVersion: %@", [UIDevice jf_appVersion]],
        [NSString stringWithFormat:@"Model: %@", [UIDevice jf_model]],
        [NSString stringWithFormat:@"IDFV: %@", [UIDevice jf_idfv]],
        [NSString stringWithFormat:@"iPhoneX family: %@", [UIDevice jf_isiPhoneX] ? @"YES" : @"NO"],
        [NSString stringWithFormat:@"Plus: %@", [UIDevice jf_isPlus] ? @"YES" : @"NO"],
        [NSString stringWithFormat:@"Top bar height: %.1f", [UIApplication jf_topBarHeight]],
    ];

    for (NSString *line in lines) {
        [self.stackView addArrangedSubview:[self bodyLabel:line]];
    }
}

- (void)showScreenshotPreview
{
    UIImage *image = [self.view jf_screenShot];
    UIViewController *preview = [[UIViewController alloc] init];
    preview.title = @"截图预览";
    preview.view.backgroundColor = [UIColor whiteColor];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [preview.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(preview.view);
        make.leading.trailing.equalTo(preview.view);
    }];
    [self.navigationController pushViewController:preview animated:YES];
}

- (void)scrollCurrentPageToTop
{
    [self.scrollView jf_scrollToTopAnimated:YES];
}

- (void)pushNavigationSample
{
    JFUIKitDemoViewController *vc = [[JFUIKitDemoViewController alloc] initWithDemoType:@"AlertToast" title:@"导航 Push 示例"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showJFAlert
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"JF Alert"
                                                                   message:@"UIAlertController 分类未暴露到当前 Pod public headers，这里用系统 present 展示弹窗效果。"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showJFToast
{
    [self.view jf_toastInfoWithMessage:@"这是一条 JFTopToast" onTop:YES];
}

#pragma mark - Demo Actions

- (void)enableImageNamedCheck
{
    [UIImage jf_enableImageNamedCheck];
    [self.view jf_toastInfoWithMessage:@"已启用 imageNamed 缺图检查" onTop:YES];
}

- (void)confirmTriggerMissingImageCheck
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"触发缺图检查"
                                                                   message:@"Debug 下会触发 NSAssert，用于验证缺图检查是否生效。"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"触发" style:UIAlertActionStyleDestructive handler:^(__unused UIAlertAction *action) {
        [UIImage jf_enableImageNamedCheck];
        [UIImage imageNamed:@"jf_missing_image_demo_name"];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)countEnlargedButtonTap
{
    self.buttonTapCount += 1;
    self.buttonTapCountLabel.text = [NSString stringWithFormat:@"点击黄色按钮周围空白区域，命中次数：%ld", (long)self.buttonTapCount];
}

- (void)runButtonStrokeAnimation
{
    [self.strokeAnimationButton jf_animationStrokeRoundLineFromAngle:-M_PI_2
                                                           lineWidth:3
                                                   animationDuration:1.4];
}

- (void)removeButtonStrokeAnimation
{
    [self.strokeAnimationButton jf_removeLayerAnimations];
}

- (void)textFieldLimitChanged:(UITextField *)textField
{
    __weak typeof(self) weakSelf = self;
    [textField jf_limitTextLengthTo:6 limitDo:^{
        weakSelf.textFieldLimitLabel.text = @"长度限制回调：已截断到 6 个字符";
    }];
}

- (void)startFloatingAnimation
{
    CAKeyframeAnimation *animation = [UIView jf_createFloatingAnimationInFrame:CGRectMake(0, 0, 220, 100)];
    animation.repeatCount = HUGE_VALF;
    animation.duration = 2.2;
    [self.floatingAnimationView.layer addAnimation:animation forKey:@"JFUIKitDemoFloating"];
}

- (void)pauseFloatingAnimation
{
    [self.floatingAnimationView jf_pauseLayer];
}

- (void)resumeFloatingAnimation
{
    [self.floatingAnimationView jf_resumeLayer];
}

- (NSString *)scrollBounceStateText
{
    return [NSString stringWithFormat:@"bouncing=%@ top=%@ leading=%@ bottom=%@ trailing=%@",
                                      self.scrollView.jf_isBouncing ? @"YES" : @"NO",
                                      self.scrollView.jf_isBouncingTop ? @"YES" : @"NO",
                                      self.scrollView.jf_isBouncingLeading ? @"YES" : @"NO",
                                      self.scrollView.jf_isBouncingBottom ? @"YES" : @"NO",
                                      self.scrollView.jf_isBouncingTrailing ? @"YES" : @"NO"];
}

- (void)refreshBounceState
{
    self.bounceStateLabel.text = [self scrollBounceStateText];
}

- (void)showAlignedAlert
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"居左 Message"
                                                                   message:@"第一行 message\n第二行 message\n用于验证 jf_configMessageAlignment:"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert jf_configMessageAlignment:NSTextAlignmentLeft];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showActionSheet
{
    UIAlertController *sheet = [UIAlertController alertControllerWithTitle:@"Action Sheet"
                                                                   message:@"UIAlertController 基础展示"
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    [sheet addAction:[UIAlertAction actionWithTitle:@"默认操作" style:UIAlertActionStyleDefault handler:nil]];
    [sheet addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    sheet.popoverPresentationController.sourceView = self.view;
    sheet.popoverPresentationController.sourceRect = CGRectMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds), 1, 1);
    [self presentViewController:sheet animated:YES completion:nil];
}

- (void)enableDownloadCheckAndLoadFailedImage
{
#if JF_IMAGE_VIEW_DOWNLOAD_CHECK_AVAILABLE
    __weak typeof(self) weakSelf = self;
    [UIImageView jf_enableDownloadCheckWithLogger:^(NSURL *url, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.downloadLogLabel.text = [NSString stringWithFormat:@"失败 URL: %@\nerror: %@", url.absoluteString, error.localizedDescription];
        });
    }];
    self.downloadLogLabel.text = @"日志：已启用，正在请求失败图片...";
    NSURL *url = [NSURL URLWithString:@"https://example.invalid/jf-uikit-download-check-demo.png"];
    [self.downloadImageView sd_setImageWithURL:url placeholderImage:nil];
#else
    self.downloadLogLabel.text = @"日志：当前 target 未引入 JFUIKit/Hook/UIImageViewDownloadCheck";
#endif
}

- (void)showTabBarCenterHitResult
{
    [self.view jf_toastInfoWithMessage:@"凸出中心按钮点击成功" onTop:YES];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView
{
    __weak typeof(self) weakSelf = self;
    [textView jf_limitTextLengthTo:12 limitDo:^{
        weakSelf.textViewLimitLabel.text = @"长度限制回调：已截断到 12 个字符";
    }];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return collectionView == self.cellCollectionView ? 8 : 0;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[UICollectionViewCell jf_reuseIdentifier]
                                                                           forIndexPath:indexPath];
    cell.backgroundColor = indexPath.item % 2 == 0 ? [UIColor systemBlueColor] : [UIColor systemTealColor];
    cell.layer.cornerRadius = 8;

    UILabel *label = [cell.contentView viewWithTag:7001];
    if (!label) {
        label = [[UILabel alloc] init];
        label.tag = 7001;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont boldSystemFontOfSize:14];
        label.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(cell.contentView);
        }];
    }
    label.text = [NSString stringWithFormat:@"Item %ld", (long)indexPath.item];
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = floor((collectionView.bounds.size.width - 48) / 3.0);
    return CGSizeMake(width, 54);
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return tableView == self.cellTableView ? 5 : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[UITableViewCell jf_reuseIdentifier] forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"圆角 Cell %ld", (long)indexPath.row + 1];
    cell.textLabel.textColor = [UIColor colorWithWhite:0.18 alpha:1.0];
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    [cell jf_setCornerRadius:12 tableView:tableView indexPath:indexPath];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return tableView == self.cellTableView ? 48 : 44;
}

@end
