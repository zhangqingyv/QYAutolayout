//
//  ViewController.m
//  QYAutolayout Example
//
//  Created by Terry Zhang on 15/11/22.
//  Copyright © 2015年 Terry Zhang. All rights reserved.
//

#import "ViewController.h"
#import "UIView+QYAutoLayout.h"

@interface ViewController ()

@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) UILabel *blueLabel;
@property (nonatomic, strong) UILabel *yellowLabel;
@property (nonatomic, strong) UILabel *redLabel;
@property (nonatomic, strong) UILabel *greenLabel;


@property (nonatomic, assign) NSUInteger tapClickCount;


@end

@implementation ViewController

#pragma mark - View Controller Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addTapGestureRecognizer];
    
    [self setupUI];
}

- (void)updateViewConstraints
{
    if (self.tapClickCount % 2 == 1) {
        [self setLayout1];
    } else {
        [self setLayout2];
    }
    
    [super updateViewConstraints];
}

#pragma mark - Set up UI

- (void)setupUI
{
    
    [self.view addSubview:self.containerView];
    self.containerView.backgroundColor = [UIColor grayColor];
    
    [self.containerView addSubview:self.blueLabel];
    [self.containerView addSubview:self.yellowLabel];
    [self.containerView addSubview:self.redLabel];
    [self.containerView addSubview:self.greenLabel];
    
    [self.containerView setNeedsUpdateConstraints];
    [self.containerView updateConstraintsIfNeeded];
}

- (void)setLayout1
{
    [self.containerView autoPinEdgesToSuperview];
    
    // View Dictionary
    NSDictionary *views = NSDictionaryOfVariableBindings(_blueLabel, _yellowLabel, _redLabel, _greenLabel);
    // Metrics Dictionary
    NSDictionary *metrics = @{@"hPadding":@10
                              , @"vPadding":@10
                              , @"blueLabelHeight":@20
                              };
    
    // Horizontal VFL Strings
    NSString *H01 = @"H:|-(hPadding)-[_blueLabel]-(hPadding)-|";
    NSString *H02 = @"H:[_yellowLabel(_blueLabel,_redLabel,_greenLabel)]";
    
    // Vertical VFL Strings
    NSString *V01 = @"V:|-(70)-[_blueLabel]-(vPadding)-[_yellowLabel]-(>=0)-[_redLabel]-(vPadding)-[_greenLabel]";
    NSString *V02 = @"V:[_blueLabel(blueLabelHeight,_yellowLabel,_redLabel,_greenLabel)]";
    
    [self.containerView autoAddConstraintsWithVisualFormatArray:@[H01, H02, V02] options:0 metrics:metrics views:views];
    [self.containerView autoAddConstraintsWithVisualFormatArray:@[V01] options:NSLayoutFormatAlignAllLeft metrics:metrics views:views];
    
    [self.redLabel autoAlignInSuperview:QYAutoLayoutAlignCenterY];
    
}

- (void)setLayout2
{
    [self.containerView autoPinEdgesToSuperview];

    // View Dictionary
    NSDictionary *views = NSDictionaryOfVariableBindings(_blueLabel, _yellowLabel, _redLabel, _greenLabel);
    // Metrics Dictionary
    NSDictionary *metrics = @{@"hPadding":@10
                              , @"vPadding":@10
                              , @"blueLabelHeight":@20
                              };
    
    // Horizontal VFL Strings
    NSString *H01 = @"H:|-(hPadding)-[_blueLabel][_yellowLabel][_redLabel][_greenLabel]-(hPadding)-|";
    NSString *H02 = @"H:[_yellowLabel(_blueLabel,_redLabel,_greenLabel)]";
    
    // Vertical VFL Strings
    NSString *V01 = @"V:|-(70)-[_blueLabel]-(vPadding)-[_yellowLabel]-(vPadding)-[_redLabel]-(vPadding)-[_greenLabel]";
    NSString *V02 = @"V:[_blueLabel(blueLabelHeight,_yellowLabel,_redLabel,_greenLabel)]";
    
    [self.containerView autoAddConstraintsWithVisualFormatArray:@[H01, H02, V01, V02] options:0 metrics:metrics views:views];
}

#pragma mark - Init Property

- (UIView *)containerView
{
    if (!_containerView) {
        _containerView = [UIView new];
        [_containerView useAutoLayout];
    }
    return _containerView;
}

- (UILabel *)blueLabel
{
    if (!_blueLabel) {
        _blueLabel = [UILabel new];
        [_blueLabel useAutoLayout];
        _blueLabel.backgroundColor = [UIColor blueColor];
        _blueLabel.text = @"BLUE";
        _blueLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _blueLabel;
}

- (UILabel *)yellowLabel
{
    if (!_yellowLabel) {
        _yellowLabel = [UILabel new];
        [_yellowLabel useAutoLayout];
        _yellowLabel.backgroundColor = [UIColor yellowColor];
        _yellowLabel.text = @"YELLOW";
        _yellowLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _yellowLabel;
}

- (UILabel *)redLabel
{
    if (!_redLabel) {
        _redLabel = [UILabel new];
        [_redLabel useAutoLayout];
        _redLabel.backgroundColor = [UIColor redColor];
        _redLabel.text = @"RED";
        _redLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _redLabel;
}

- (UILabel *)greenLabel
{
    if (!_greenLabel) {
        _greenLabel = [UILabel new];
        [_greenLabel useAutoLayout];
        _greenLabel.backgroundColor = [UIColor greenColor];
        _greenLabel.text = @"GREEN";
        _greenLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _greenLabel;
}

#pragma mark - Private Mehtod

- (void)addTapGestureRecognizer
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    self.view.userInteractionEnabled = YES;
    [self.view addGestureRecognizer:tap];
}

- (void)tapped:(id)sender
{
    self.tapClickCount ++;
    
    [self.containerView clearAllConstraints];
    
    [self.view setNeedsUpdateConstraints];
    [self.view updateConstraintsIfNeeded];
}

@end
