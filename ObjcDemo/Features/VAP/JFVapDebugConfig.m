//
//  JFVapDebugConfig.m
//  ObjcDemo
//
//  Created by huangdonghong on 2026/5/18.
//

#import "JFVapDebugConfig.h"
#import <Masonry/Masonry.h>

@interface JFVapDebugConfigTableViewCell ()

@property (nonatomic, strong) JFVapDebugConfigModel *model;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UISwitch *switchView;
@property (nonatomic, strong) UITextField *textfield;

@end

@implementation JFVapDebugConfigModel

@end

@implementation JFVapDebugConfigTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
        _titleLabel.textColor = [UIColor colorWithWhite:0.12 alpha:1.0];
        _titleLabel.numberOfLines = 0;

        _descLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _descLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
        _descLabel.textColor = [UIColor colorWithWhite:0.45 alpha:1.0];
        _descLabel.numberOfLines = 0;
        _descLabel.hidden = YES;

        _switchView = [[UISwitch alloc] initWithFrame:CGRectZero];
        [_switchView addTarget:self action:@selector(onSwitchChanged:) forControlEvents:UIControlEventValueChanged];

        _textfield = [[UITextField alloc] initWithFrame:CGRectZero];
        _textfield.borderStyle = UITextBorderStyleRoundedRect;
        _textfield.font = [UIFont systemFontOfSize:14];
        [_textfield addTarget:self action:@selector(onTextFieldChanged:) forControlEvents:UIControlEventEditingChanged];

        [self.contentView addSubview:_titleLabel];
        [self.contentView addSubview:_descLabel];
        [self.contentView addSubview:_switchView];
        [self.contentView addSubview:_textfield];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self.contentView.mas_leading).offset(20.0);
            make.trailing.lessThanOrEqualTo(self.contentView.mas_trailing).offset(-20.0);
            make.trailing.lessThanOrEqualTo(_switchView.mas_leading).offset(-12.0);
            make.trailing.lessThanOrEqualTo(_textfield.mas_leading).offset(-12.0);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.top.greaterThanOrEqualTo(self.contentView.mas_top).offset(8.0);
            make.bottom.lessThanOrEqualTo(self.contentView.mas_bottom).offset(-8.0);
        }];
        [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(_titleLabel);
            make.top.equalTo(_titleLabel.mas_bottom).offset(2.0);
        }];
        [_switchView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self.contentView.mas_trailing).offset(-20.0);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
        [_textfield mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self.contentView.mas_trailing).offset(-20.0);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.width.mas_equalTo(96.0);
            make.height.mas_equalTo(30.0);
        }];
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}

- (void)setContent:(JFVapDebugConfigModel *)model
{
    self.model = model;
    self.titleLabel.text = model.title;
    self.descLabel.text = model.desc;

    self.textfield.text = model.defaultVal;
    self.textfield.hidden = !model.needTextfield;
    self.switchView.hidden = model.type != JFVapDebugConfigCellTypeSwitch;
    self.accessoryType = model.type == JFVapDebugConfigCellTypeNone ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;

    if (model.type == JFVapDebugConfigCellTypeSwitch) {
        [self.switchView setOn:model.isOn animated:NO];
    }
}

- (void)onSwitchChanged:(UISwitch *)switchView
{
    if (self.model.switchChangedCallback) {
        self.model.switchChangedCallback(switchView.isOn);
    }
}

- (void)onTextFieldChanged:(UITextField *)textField
{
    if (self.model.applyValCallback) {
        self.model.applyValCallback(textField.text ?: @"");
    }
}

@end
