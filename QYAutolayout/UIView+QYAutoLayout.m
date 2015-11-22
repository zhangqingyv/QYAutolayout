//
//  UIView+QYAutoLayout.m
//  QYAutolayout Example
//
//  Created by Terry Zhang on 15/11/16.
//  Copyright © 2015年 terry. All rights reserved.
//

#import "UIView+QYAutoLayout.h"

@implementation UIView (QYAutoLayout)

#pragma mark - for self

- (void)useAutoLayout
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
}

- (void)autoCenterInSuperview
{
    [self autoAlignInSuperview:QYAutoLayoutAlignCenterX];
    [self autoAlignInSuperview:QYAutoLayoutAlignCenterY];
}

- (void)autoAlignInSuperview:(QYAutoLayoutAlignType)alignType
{
    [self autoAlignInSuperview:alignType constant:.0];
}

- (void)autoAlignInSuperview:(QYAutoLayoutAlignType)alignType constant:(CGFloat)constant;
{
    UIView *superview = self.superview;
    NSAssert(superview, @"View's superview must not be nil.\nView: %@", self);
    [self autoAlign:alignType relatedView:superview constant:constant];
}

- (void)autoAlign:(QYAutoLayoutAlignType)alignType relatedView:(UIView *)relatedView constant:(CGFloat)constant
{
    UIView *superview = self.superview;
    NSAssert(superview, @"View's superview must not be nil.\nView: %@", self);
    NSLayoutAttribute attribute = (NSLayoutAttribute)alignType;
    [superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:attribute relatedBy:NSLayoutRelationEqual toItem:relatedView attribute:attribute multiplier:1.0f constant:constant]];
}

- (void)autoAlign:(QYAutoLayoutAlignType)alignType relatedView:(UIView *)relatedView relatedAlign:(QYAutoLayoutAlignType)relatedAlign constant:(CGFloat)constant
{
    UIView *superview = self.superview;
    NSAssert(superview, @"View's superview must not be nil.\nView: %@", self);
    NSLayoutAttribute attribute1 = (NSLayoutAttribute)alignType;
    NSLayoutAttribute attribute2 = (NSLayoutAttribute)relatedAlign;
    [superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:attribute1 relatedBy:NSLayoutRelationEqual toItem:relatedView attribute:attribute2 multiplier:1.0f constant:constant]];
}

- (void)autoMatchSizeType:(QYAutoLayoutSizeType)sizeType1 sizeType2:(QYAutoLayoutSizeType)sizeType2 rate:(CGFloat)rate
{
    UIView *superview = self.superview;
    NSAssert(superview, @"View's superview must not be nil.\nView: %@", self);
    [superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:(NSLayoutAttribute)sizeType1 relatedBy:NSLayoutRelationEqual toItem:self attribute:(NSLayoutAttribute)sizeType2 multiplier:rate constant:.0]];
}

- (void)autoMatchSizeType:(QYAutoLayoutSizeType)sizeType1 relatedView:(UIView *)relatedView  sizeType2:(QYAutoLayoutSizeType)sizeType2 rate:(CGFloat)rate constant:(CGFloat)constant
{
    UIView *superview = self.superview;
    NSAssert(superview, @"View's superview must not be nil.\nView: %@", self);
    [superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:(NSLayoutAttribute)sizeType1 relatedBy:NSLayoutRelationEqual toItem:relatedView attribute:(NSLayoutAttribute)sizeType2 multiplier:rate constant:constant]];
}

- (void)clearAllConstraints
{
    NSMutableArray *constraintsToRemove = [NSMutableArray array];
    [self.constraints enumerateObjectsUsingBlock:^(__kindof NSLayoutConstraint * _Nonnull constraint, NSUInteger idx, BOOL * _Nonnull stop) {
        BOOL isImplicitConstraint = [NSStringFromClass([constraint class]) isEqualToString:@"NSContentSizeLayoutConstraint"];
        if (isImplicitConstraint) {
            [constraintsToRemove addObject:constraint];
        }
    }];
    [self removeConstraints:constraintsToRemove];
    
    for (UIView *sub in [self subviews]) {
        [sub clearAllConstraints];
    }
}

#pragma mark - for superView
- (void)autoAddConstraintsWithVisualFormatArray:(NSArray *)formatArr options:(NSLayoutFormatOptions)opts metrics:(NSDictionary *)metrics views:(NSDictionary *)views
{
    for (NSString *format in formatArr) {
        NSAssert([format isKindOfClass:[NSString class]], @"formatArr must be array of NSString");
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:format options:opts metrics:metrics views:views]];
    }
}

- (void)autoAddConstraintsWithVisualFormatArray:(NSArray *)formatArr optionsArray:(NSArray *)optsArray metrics:(NSDictionary *)metrics views:(NSDictionary *)views
{
    [formatArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSLayoutFormatOptions opts = [[optsArray objectAtIndex:idx] integerValue];
        NSAssert([obj isKindOfClass:[NSString class]], @"formatArr must be array of NSString");
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:obj options:opts metrics:metrics views:views]];
    }];
}

- (void)addFullContentView:(UIView *)contentView
{
    [self addContentView:contentView insets:UIEdgeInsetsZero];
}

- (void)addContentView:(UIView *)contentView insets:(UIEdgeInsets)insets
{
    NSDictionary *view = NSDictionaryOfVariableBindings(contentView);
    NSDictionary *metrics = @{@"top": @(insets.top), @"left": @(insets.left), @"bottom": @(insets.bottom), @"right": @(insets.right)};
    NSString *H01 = @"H:|-left-[contentView]-right-|";
    NSString *V01 = @"V:|-top-[contentView]-bottom-|";
    [self autoAddConstraintsWithVisualFormatArray:@[H01,V01] options:0 metrics:metrics views:view];
}

@end

@implementation NSArray (QYAutoLayout)

- (void)autoAlignWithType:(QYAutoLayoutAlignType)type relatedView:(UIView *)relatedView constant:(CGFloat)constant
{
    for (UIView *view in self) {
        if ([view isKindOfClass:[UIView class]]) {
            [view autoAlign:type relatedView:relatedView constant:constant];
            view.translatesAutoresizingMaskIntoConstraints = NO;
        }
    }
}

#pragma mark - Privite
- (BOOL)isContainsMinimumNumberOfViews:(NSUInteger)minimumNumberOfViews
{
    NSUInteger numberOfViews = 0;
    for (id object in self) {
        if ([object isKindOfClass:[UIView class]]) {
            numberOfViews++;
            if (numberOfViews >= minimumNumberOfViews) {
                return YES;
            }
        }
    }
    return numberOfViews >= minimumNumberOfViews;
}

@end
