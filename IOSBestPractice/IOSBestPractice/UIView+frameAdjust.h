//
//  UIView+frameAdjust.h
//  IOSBestPractice
//
//  Created by 吴永波 on 16/1/3.
//  Copyright © 2016年 Wilbur.Wu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIView (frameAdjust)

- (CGPoint)origin;
- (void)setOrigin:(CGPoint) point;

- (CGSize)size;
- (void)setSize:(CGSize) size;

- (CGFloat)x;
- (void)setX:(CGFloat)x;

- (CGFloat)y;
- (void)setY:(CGFloat)y;

- (CGFloat)height;
- (void)setHeight:(CGFloat)height;

- (CGFloat)width;
- (void)setWidth:(CGFloat)width;

- (CGFloat)tail;
- (void)setTail:(CGFloat)tail;

- (CGFloat)bottom;
- (void)setBottom:(CGFloat)bottom;

- (CGFloat)right;
- (void)setRight:(CGFloat)right;


@end
