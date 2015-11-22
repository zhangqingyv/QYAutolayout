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

- (void)autoPinEdgesToSuperview
{
    [self autoPinEdgesToSuperviewWithInsets:UIEdgeInsetsZero];
}

- (void)autoPinEdgesToSuperviewWithInsets:(UIEdgeInsets)insets
{
    UIView *superView = self.superview;
    
    NSDictionary *view = @{@"contentView":self};
    NSDictionary *metrics = @{@"top": @(insets.top), @"left": @(insets.left), @"bottom": @(insets.bottom), @"right": @(insets.right)};
    NSString *H01 = @"H:|-left-[contentView]-right-|";
    NSString *V01 = @"V:|-top-[contentView]-bottom-|";
    
    [superView autoAddConstraintsWithVisualFormatArray:@[H01,V01] options:0 metrics:metrics views:view];
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
    UIView *superview = [self qy_commonSuperviewWithView:relatedView];
    NSAssert(superview, @"View's superview must not be nil.\nView: %@", self);
    NSLayoutAttribute attribute = (NSLayoutAttribute)alignType;
    [superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:attribute relatedBy:NSLayoutRelationEqual toItem:relatedView attribute:attribute multiplier:1.0f constant:constant]];
}

- (void)autoAlign:(QYAutoLayoutAlignType)alignType relatedView:(UIView *)relatedView relatedAlign:(QYAutoLayoutAlignType)relatedAlign constant:(CGFloat)constant
{
    UIView *superview = [self qy_commonSuperviewWithView:relatedView];
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
    UIView *superview = [self qy_commonSuperviewWithView:relatedView];
    NSAssert(superview, @"View's superview must not be nil.\nView: %@", self);
    [superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:(NSLayoutAttribute)sizeType1 relatedBy:NSLayoutRelationEqual toItem:relatedView attribute:(NSLayoutAttribute)sizeType2 multiplier:rate constant:constant]];
}

- (void)clearAllConstraints
{
    [self autoRemoveConstraintsAffectingViewIncludingImplicitConstraints:NO];
    
    for (UIView *sub in [self subviews]) {
        [sub autoRemoveConstraintsAffectingViewIncludingImplicitConstraints:NO];
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

#pragma mark - Private Methods

- (void)autoRemoveConstraintsAffectingViewIncludingImplicitConstraints:(BOOL)shouldRemoveImplicitConstraints
{
    NSMutableArray *constraintsToRemove = [NSMutableArray new];
    UIView *startView = self;
    do {
        for (NSLayoutConstraint *constraint in startView.constraints) {
            BOOL isImplicitConstraint = [NSStringFromClass([constraint class]) isEqualToString:@"NSContentSizeLayoutConstraint"];
            if (shouldRemoveImplicitConstraints || !isImplicitConstraint) {
                if (constraint.firstItem == self || constraint.secondItem == self) {
                    [constraintsToRemove addObject:constraint];
                }
            }
        }
        startView = startView.superview;
    } while (startView);
    [UIView autoRemoveConstraints:constraintsToRemove];
}

+ (void)autoRemoveConstraints:(NSArray *)constraints
{
    for (id object in constraints) {
        if ([object isKindOfClass:[NSLayoutConstraint class]]) {
            [self autoRemoveConstraint:((NSLayoutConstraint *)object)];
        } else {
            NSAssert(nil, @"All constraints to remove must be instances of NSLayoutConstraint.");
        }
    }
}

+ (void)autoRemoveConstraint:(NSLayoutConstraint *)constraint
{
    if (constraint.secondItem) {
        UIView *commonSuperview = [constraint.firstItem qy_commonSuperviewWithView:constraint.secondItem];
        while (commonSuperview) {
            if ([commonSuperview.constraints containsObject:constraint]) {
                [commonSuperview removeConstraint:constraint];
                return;
            }
            commonSuperview = commonSuperview.superview;
        }
    }
    else {
        [constraint.firstItem removeConstraint:constraint];
        return;
    }
    NSAssert(nil, @"Failed to remove constraint: %@", constraint);
}

/// 返回 最小公共 superView
- (UIView *)qy_commonSuperviewWithView:(UIView *)peerView
{
    UIView *commonSuperview = nil;
    UIView *startView = self;
    do {
        if ([peerView isDescendantOfView:startView]) {
            commonSuperview = startView;
        }
        startView = startView.superview;
    } while (startView && !commonSuperview);
    NSAssert(commonSuperview, @"Can't constrain two views that do not share a common superview. Make sure that both views have been added into the same view hierarchy.");
    return commonSuperview;
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
