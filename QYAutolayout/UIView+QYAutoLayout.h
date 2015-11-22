//
//  UIView+QYAutoLayout.h
//  QYAutolayout Example
//
//  Created by Terry Zhang on 15/11/16.
//  Copyright © 2015年 terry. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, QYAutoLayoutAlignType) {
    QYAutoLayoutAlignCenterX = NSLayoutAttributeCenterX,
    QYAutoLayoutAlignCenterY = NSLayoutAttributeCenterY,
    QYAutoLayoutAlignTop = NSLayoutAttributeTop,
    QYAutoLayoutAlignLeft = NSLayoutAttributeLeft,
    QYAutoLayoutAlignBottom = NSLayoutAttributeBottom,
    QYAutoLayoutAlignRight = NSLayoutAttributeRight,
    QYAutoLayoutAlignBaseline = NSLayoutAttributeBaseline
};

typedef NS_ENUM(NSInteger, QYAutoLayoutSizeType) {
    QYAutoLayoutSizeWidth           = NSLayoutAttributeWidth,
    QYAutoLayoutSizeHeight          = NSLayoutAttributeHeight,
    QYAutoLayoutSizeNotAnAttribute  = NSLayoutAttributeNotAnAttribute
};

@interface UIView (QYAutoLayout)

#pragma mark - for self
/**
 启用autolayout
 **/
- (void)useAutoLayout;

/**
 相对superView对齐，水平，垂直居中
 **/
- (void)autoCenterInSuperview;

/**
 *  全屏加子view
 *
 *  @param contentView 子view
 *
 */
- (void)autoPinEdgesToSuperview;

/**
 *  添加子view
 *
 *  @param contentView 子view
 *  @param insets 相对父view上下左右空多少
 *
 */
- (void)autoPinEdgesToSuperviewWithInsets:(UIEdgeInsets)insets;

/**
 相对superView对齐，根据type
 **/
- (void)autoAlignInSuperview:(QYAutoLayoutAlignType)alignType;

/**
 相对superView对齐，根据type, constant
 **/
- (void)autoAlignInSuperview:(QYAutoLayoutAlignType)alignType constant:(CGFloat)constant;

/**
 *  相对relatedView对齐，self.alignType = relatedView.alignType + constant
 *  @param alignType
 *  @param relatedView
 *  @param constant
 */
- (void)autoAlign:(QYAutoLayoutAlignType)alignType relatedView:(UIView *)relatedView constant:(CGFloat)constant;

/**
 *  相对relatedView对齐，self.alignType = relatedView.relatedAlign + constant
 *  @param alignType
 *  @param relatedView
 *  @param relatedAlign
 *  @param constant
 */
- (void)autoAlign:(QYAutoLayoutAlignType)alignType relatedView:(UIView *)relatedView relatedAlign:(QYAutoLayoutAlignType)relatedAlign constant:(CGFloat)constant;

/**
 *  添加宽高比约束 sizeType1 = sizeType2 * rate
 */
- (void)autoMatchSizeType:(QYAutoLayoutSizeType)sizeType1 sizeType2:(QYAutoLayoutSizeType)sizeType2 rate:(CGFloat)rate;

/**
 *  添加宽高相关约束 self.sizeType1 = relatedView.sizeType2 * rate + constant
 */
- (void)autoMatchSizeType:(QYAutoLayoutSizeType)sizeType1 relatedView:(UIView *)relatedView  sizeType2:(QYAutoLayoutSizeType)sizeType2 rate:(CGFloat)rate constant:(CGFloat)constant;

/**
 *  清除所有Constraint, 包括subview
 */
- (void)clearAllConstraints;

#pragma mark - for superView
/**
 *  VFL 方式
 *
 *  @param formatArr VFL数组
 *  @param opts
 *  @param metrics
 *  @param views
 *
 */
- (void)autoAddConstraintsWithVisualFormatArray:(NSArray *)formatArr options:(NSLayoutFormatOptions)opts metrics:(NSDictionary *)metrics views:(NSDictionary *)views;

/**
 *  VFL 方式 和上一个的区别就是opts 也是数组
 */
- (void)autoAddConstraintsWithVisualFormatArray:(NSArray *)formatArr optionsArray:(NSArray *)optsArray metrics:(NSDictionary *)metrics views:(NSDictionary *)views;

@end

@interface NSArray (QYAutoLayout)

/**
 *  数组内的view设定对齐条件
 *
 *  @param type 对齐方式
 *  @param relatedView 相对参照物
 *  @param constant 偏移量
 *
 */
- (void)autoAlignWithType:(QYAutoLayoutAlignType)type relatedView:(UIView *)relatedView constant:(CGFloat)constant;

@end
