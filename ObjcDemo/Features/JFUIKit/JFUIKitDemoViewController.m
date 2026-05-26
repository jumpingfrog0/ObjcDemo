//
//  JFUIKitDemoViewController.m
//  ObjcDemo
//
//  Created by Codex on 2026/5/25.
//

#import "JFUIKitDemoViewController.h"
#import <JFUIKit/JFUIKit.h>

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

@interface JFUIKitDemoViewController ()

@property (nonatomic, copy) NSString *demoType;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIStackView *stackView;
@property (nonatomic, strong) JFUIKitDemoTextFieldProxy *textFieldProxy;

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
        }
    }
}

- (void)setupScrollStack
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    self.scrollView.alwaysBounceVertical = YES;
    [self.view addSubview:self.scrollView];
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;

    self.stackView = [[UIStackView alloc] initWithFrame:CGRectZero];
    self.stackView.axis = UILayoutConstraintAxisVertical;
    self.stackView.spacing = 16;
    self.stackView.layoutMargins = UIEdgeInsetsMake(16, 16, 32, 16);
    self.stackView.layoutMarginsRelativeArrangement = YES;
    [self.scrollView addSubview:self.stackView];
    self.stackView.translatesAutoresizingMaskIntoConstraints = NO;

    [NSLayoutConstraint activateConstraints:@[
        [self.scrollView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [self.scrollView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.scrollView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.scrollView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
        [self.stackView.topAnchor constraintEqualToAnchor:self.scrollView.contentLayoutGuide.topAnchor],
        [self.stackView.leadingAnchor constraintEqualToAnchor:self.scrollView.contentLayoutGuide.leadingAnchor],
        [self.stackView.trailingAnchor constraintEqualToAnchor:self.scrollView.contentLayoutGuide.trailingAnchor],
        [self.stackView.bottomAnchor constraintEqualToAnchor:self.scrollView.contentLayoutGuide.bottomAnchor],
        [self.stackView.widthAnchor constraintEqualToAnchor:self.scrollView.frameLayoutGuide.widthAnchor],
    ]];
}

- (void)buildDemo
{
    if ([self.demoType isEqualToString:@"UIColor"]) {
        [self buildColorDemo];
    } else if ([self.demoType isEqualToString:@"UIImage"]) {
        [self buildImageDemo];
    } else if ([self.demoType isEqualToString:@"UIView"]) {
        [self buildViewDemo];
    } else if ([self.demoType isEqualToString:@"UILabel"]) {
        [self buildLabelDemo];
    } else if ([self.demoType isEqualToString:@"UIButton"]) {
        [self buildButtonDemo];
    } else if ([self.demoType isEqualToString:@"UITextField"]) {
        [self buildTextFieldDemo];
    } else if ([self.demoType isEqualToString:@"UIScrollView"]) {
        [self buildScrollViewDemo];
    } else if ([self.demoType isEqualToString:@"Navigation"]) {
        [self buildNavigationDemo];
    } else if ([self.demoType isEqualToString:@"AlertToast"]) {
        [self buildAlertToastDemo];
    } else {
        [self buildAppDeviceDemo];
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
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [view.heightAnchor constraintEqualToConstant:height],
    ]];
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
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [imageView.widthAnchor constraintEqualToConstant:92],
        [imageView.heightAnchor constraintEqualToConstant:72],
    ]];

    [row addArrangedSubview:imageView];
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
        swatch.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:@[
            [swatch.widthAnchor constraintEqualToConstant:80],
            [swatch.heightAnchor constraintEqualToConstant:44],
        ]];

        NSString *text = [NSString stringWithFormat:@"hex=%@ rgba=(%.2f, %.2f, %.2f, %.2f)",
                                                    [color jf_hexValueWithAlpha:YES],
                                                    [color jf_red],
                                                    [color jf_green],
                                                    [color jf_blue],
                                                    [color jf_alpha]];
        [row addArrangedSubview:swatch];
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
}

- (void)buildButtonDemo
{
    UIImage *icon = [UIImage jf_imageWithSize:CGSizeMake(28, 28) color:[UIColor systemBlueColor] cornerRadius:14];

    UIButton *vertical = [UIButton buttonWithType:UIButtonTypeCustom];
    [vertical setTitle:@"上下布局" forState:UIControlStateNormal];
    [vertical setTitleColor:[UIColor colorWithWhite:0.18 alpha:1.0] forState:UIControlStateNormal];
    [vertical setImage:icon forState:UIControlStateNormal];
    vertical.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    vertical.frame = CGRectMake(0, 0, 180, 88);
    [vertical jf_alignVerticalWithSpacing:8];
    [self addFixedHeight:vertical height:88];
    [self.stackView addArrangedSubview:vertical];

    UIButton *horizontal = [UIButton buttonWithType:UIButtonTypeCustom];
    [horizontal setTitle:@"水平布局按钮" forState:UIControlStateNormal];
    [horizontal setTitleColor:[UIColor colorWithWhite:0.18 alpha:1.0] forState:UIControlStateNormal];
    [horizontal setImage:icon forState:UIControlStateNormal];
    horizontal.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    horizontal.frame = CGRectMake(0, 0, 220, 56);
    [horizontal jf_alignHorizontalWithSpacing:12];
    [horizontal jf_setTitleColor:[UIColor systemRedColor] range:NSMakeRange(0, 2)];
    [self addFixedHeight:horizontal height:56];
    [self.stackView addArrangedSubview:horizontal];
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
    imageView.frame = preview.view.bounds;
    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [preview.view addSubview:imageView];
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

@end
