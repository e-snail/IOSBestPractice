//
//  UIView+frameAdjust.h
//  IOSBestPractice
//
//  Created by 吴永波 on 16/1/3.
//  Copyright © 2016年 Wilbur.Wu. All rights reserved.
//

#ifndef UIView_frameAdjust_h
#define UIView_frameAdjust_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIView (frameAdjust)

- (CGFloat) x;
- (void) setX:(CGFloat) x;

- (CGFloat) y;
- (void) setY:(CGFloat) y;

- (CGFloat) height;
- (void) setHeight: (CGFloat) height;

- (CGFloat) width;
- (void) setWidth: (CGFloat) width;

@end

#endif /* UIView_frameAdjust_h */
