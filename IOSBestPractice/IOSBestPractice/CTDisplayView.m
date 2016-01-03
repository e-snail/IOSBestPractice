//
//  CTDisplayView.m
//  IOSBestPractice
//
//  Created by 吴永波 on 16/1/2.
//  Copyright © 2016年 Wilbur.Wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreText/CoreText.h"
#import "CTDisplayView.h"
#import "CoreTextLinkData.h"
#import "CoreTextImageData.h"
#import "CoreTextUtils.h"
#import "MagnifiterView.h"

#define ANCHOR_TARGET_TAG 1
#define FONT_HEIGHT  40

typedef enum CTDisplayViewState : NSInteger {
    CTDisplayViewStateNormal,       //普通状态
    CTDisplayViewStateTouching,     //正在按下，需要弹出放大镜
    CTDisplayViewStateSelecting     //选中一些文本，需要弹出复制菜单
}CTDisplayViewState;

@interface CTDisplayView()<UIGestureRecognizerDelegate>

@property (nonatomic) CTDisplayViewState state;
@property (nonatomic) NSInteger selectionStartPosition;
@property (nonatomic) NSInteger selectionEndPosition;
@property (strong, nonatomic) MagnifiterView *magnifierView;
@property (strong, nonatomic) UIImageView *leftSelectionAnchor;
@property (strong, nonatomic) UIImageView *rightSelectionAnchor;

@end


@implementation CTDisplayView

- (id) init {
    return [self initWithFrame:CGRectZero];
}

- (id) initWithFrame:(CGRect) frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupEvents];
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupEvents];
    }
    return self;
}

- (void) setupEvents {
    //添加tap识别器
    UIGestureRecognizer * tapRecognizer =
        [[UITapGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(userTapGestureDetected:)];
    
    [self addGestureRecognizer:tapRecognizer];
    
    //添加long press识别器
    UIGestureRecognizer *longPressRecognizer =
        [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                      action:@selector(userLongPressedGuestureDetected:)];
    [self addGestureRecognizer:longPressRecognizer];
    
    //添加pan识别器
    UIGestureRecognizer *panRecognizer =
        [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(userPanGuestureDetected:)];
    [self addGestureRecognizer:panRecognizer];

    self.userInteractionEnabled = YES;
}

- (void) userLongPressedGuestureDetected:(UIGestureRecognizer*) recognizer {
    CGPoint point = [recognizer locationInView:self];
    debugMethod();
    debugLog(@"state = %ld", (long)recognizer.state);
    debugLog(@"point = %@", NSStringFromCGPoint(point));
    if (recognizer.state == UIGestureRecognizerStateBegan ||
        recognizer.state == UIGestureRecognizerStateChanged)
    {
        CFIndex index = [CoreTextUtils touchContentOffsetInView:self atPoint:point data:self.data];
        if (index != -1 && index < self.data.content.length) {
            _selectionStartPosition = index;
            _selectionEndPosition = index + 2;
        }
        self.magnifierView.touchPoint = point;
        self.state = CTDisplayViewStateTouching;
    } else {
        if (_selectionStartPosition >= 0 && _selectionEndPosition <= self.data.content.length) {
            self.state = CTDisplayViewStateSelecting;
            [self showMenuController];
        } else {
            self.state = CTDisplayViewStateNormal;
        }
    }
}

- (void) userTapGestureDetected:(UIGestureRecognizer*) recognizer {
    CGPoint point = [recognizer locationInView:self];
    if (_state == CTDisplayViewStateNormal) {
        for (CoreTextImageData * imageData in self.data.imageList) {
            // 翻转坐标系，因为imageData中的坐标是CoreText的坐标系
            CGRect imageRect = imageData.imagePosition;
            CGPoint imagePosition = imageRect.origin;
            imagePosition.y = self.bounds.size.height - imageRect.origin.y - imageRect.size.height;
            CGRect rect = CGRectMake(imagePosition.x,
                                     imagePosition.y,
                                     imageRect.size.width,
                                     imageRect.size.height);
            // 检测点击位置 Point 是否在rect之内
            if (CGRectContainsPoint(rect, point)) {
                NSLog(@"hint image");
                // 在这里处理点击后的逻辑
                NSDictionary *userInfo = @{ @"imageData": imageData };
                [[NSNotificationCenter defaultCenter]
                                    postNotificationName:CTDisplayViewImagePressedNotification
                                    object:self
                                    userInfo:userInfo];
                return;
            }
        }
        
        CoreTextLinkData *linkData = [CoreTextUtils touchLinkInView:self
                                                    atPoint:point
                                                    data:self.data];
        if (linkData) {
            NSLog(@"hint link!");
            NSDictionary *userInfo = @{ @"linkData": linkData };
            [[NSNotificationCenter defaultCenter]
                        postNotificationName:CTDisplayViewLinkPressedNotification
                        object:self
                        userInfo:userInfo];
            return;
        }
    } else {
        self.state = CTDisplayViewStateNormal;
    }
}

- (void) userPanGuestureDetected:(UIGestureRecognizer*) recognizer {
}

- (void) setData:(CoreTextData *)data {
    _data = data;
    self.state = CTDisplayViewStateNormal;
}

- (void) drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    //得到当前绘制画布的上下文,用于后续将内容绘制在画布上。
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //将坐标系上下翻转。对于底层的绘制引擎来说,屏幕的左下角是 (0, 0) 坐标。
    //而对于上 层的 UIKit 来说,左上角是 (0, 0) 坐标。
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    //创建绘制的区域,CoreText 本身支持各种文字排版的区域,我们这里简单地将 UIView的整个界面作为排版的区域。
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, self.bounds);
    
    //
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:@"Hello World!"];
    CTFramesetterRef framesetter =
        CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attString);
    
    CTFrameRef frame =
        CTFramesetterCreateFrame(framesetter, CFRangeMake(0, [attString length]), path, NULL);
    
    CTFrameDraw(frame, context);
    
    CFRelease(frame);
    CFRelease(path);
    CFRelease(framesetter);
}

- (void)showMenuController {
    if ([self becomeFirstResponder]) {
        CGRect selectionRect = [self rectForMenuController];
        // 翻转坐标系
        CGAffineTransform transform =  CGAffineTransformMakeTranslation(0, self.bounds.size.height);
        transform = CGAffineTransformScale(transform, 1.f, -1.f);
        selectionRect = CGRectApplyAffineTransform(selectionRect, transform);
        
        UIMenuController *theMenu = [UIMenuController sharedMenuController];
        [theMenu setTargetRect:selectionRect inView:self];
        [theMenu setMenuVisible:YES animated:YES];
    }
}

- (void)hideMenuController {
    if ([self resignFirstResponder]) {
        UIMenuController *theMenu = [UIMenuController sharedMenuController];
        [theMenu setMenuVisible:NO animated:YES];
    }
}

- (CGRect)rectForMenuController {
    if (_selectionStartPosition < 0 || _selectionEndPosition > self.data.content.length) {
        return CGRectZero;
    }
    CTFrameRef textFrame = self.data.ctFrameRef;
    CFArrayRef lines = CTFrameGetLines(self.data.ctFrameRef);
    if (!lines) {
        return CGRectZero;
    }
    CFIndex count = CFArrayGetCount(lines);
    // 获得每一行的origin坐标
    CGPoint origins[count];
    CTFrameGetLineOrigins(textFrame, CFRangeMake(0,0), origins);
    
    CGRect resultRect = CGRectZero;
    for (int i = 0; i < count; i++) {
        CGPoint linePoint = origins[i];
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        CFRange range = CTLineGetStringRange(line);
        // 1. start和end在一个line,则直接弄完break
        if ([self isPosition:_selectionStartPosition inRange:range] &&
            [self isPosition:_selectionEndPosition inRange:range])
        {
            CGFloat ascent, descent, leading, offset, offset2;
            offset = CTLineGetOffsetForStringIndex(line, _selectionStartPosition, NULL);
            offset2 = CTLineGetOffsetForStringIndex(line, _selectionEndPosition, NULL);
            CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
            CGRect lineRect = CGRectMake(linePoint.x + offset, linePoint.y - descent, offset2 - offset, ascent + descent);
            resultRect = lineRect;
            break;
        }
    }
    if (!CGRectIsEmpty(resultRect)) {
        return resultRect;
    }
    
    // 2. start和end不在一个line
    for (int i = 0; i < count; i++) {
        CGPoint linePoint = origins[i];
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        CFRange range = CTLineGetStringRange(line);
        // 如果start在line中，则记录当前为起始行
        if ([self isPosition:_selectionStartPosition inRange:range]) {
            CGFloat ascent, descent, leading, width, offset;
            offset = CTLineGetOffsetForStringIndex(line, _selectionStartPosition, NULL);
            width = CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
            CGRect lineRect = CGRectMake(linePoint.x + offset, linePoint.y - descent, width - offset, ascent + descent);
            resultRect = lineRect;
        }
    }
    return resultRect;
}

- (BOOL)isPosition:(NSInteger)position inRange:(CFRange)range {
    if (position >= range.location && position < range.location + range.length) {
        return YES;
    } else {
        return NO;
    }
}

- (void)fillSelectionAreaInRect:(CGRect)rect {
    UIColor *bgColor = RGB(204, 221, 236);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, bgColor.CGColor);
    CGContextFillRect(context, rect);
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}


- (void)setState:(CTDisplayViewState)state {
    if (_state == state) {
        return;
    }
    _state = state;
    if (_state == CTDisplayViewStateNormal) {
        _selectionStartPosition = -1;
        _selectionEndPosition = -1;
        [self removeSelectionAnchor];
        [self removeMaginfierView];
        [self hideMenuController];
    } else if (_state == CTDisplayViewStateTouching) {
        if (_leftSelectionAnchor == nil && _rightSelectionAnchor == nil) {
            [self setupAnchors];
        }
    } else if (_state == CTDisplayViewStateSelecting) {
        if (_leftSelectionAnchor == nil && _rightSelectionAnchor == nil) {
            [self setupAnchors];
        }
        if (_leftSelectionAnchor.tag != ANCHOR_TARGET_TAG && _rightSelectionAnchor.tag != ANCHOR_TARGET_TAG) {
            [self removeMaginfierView];
            [self hideMenuController];
        }
    }
    [self setNeedsDisplay];
}

- (void)setupAnchors {
    _leftSelectionAnchor = [self createSelectionAnchorWithTop:YES];
    _rightSelectionAnchor = [self createSelectionAnchorWithTop:NO];
    [self addSubview:_leftSelectionAnchor];
    [self addSubview:_rightSelectionAnchor];
}

- (UIImageView *)createSelectionAnchorWithTop:(BOOL)isTop {
    UIImage *image = [self cursorWithFontHeight:FONT_HEIGHT isTop:isTop];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(0, 0, 11, FONT_HEIGHT);
    return imageView;
}


- (UIImage *)cursorWithFontHeight:(CGFloat)height isTop:(BOOL)top {
    // 22
    CGRect rect = CGRectMake(0, 0, 22, height * 2);
    UIColor *color = RGB(28, 107, 222);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    // draw point
    if (top) {
        CGContextAddEllipseInRect(context, CGRectMake(0, 0, 22, 22));
    } else {
        CGContextAddEllipseInRect(context, CGRectMake(0, height * 2 - 22, 22, 22));
    }
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillPath(context);
    // draw line
    [color set];
    CGContextSetLineWidth(context, 4);
    CGContextMoveToPoint(context, 11, 22);
    CGContextAddLineToPoint(context, 11, height * 2 - 22);
    CGContextStrokePath(context);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)removeSelectionAnchor {
    if (_leftSelectionAnchor) {
        [_leftSelectionAnchor removeFromSuperview];
        _leftSelectionAnchor = nil;
    }
    if (_rightSelectionAnchor) {
        [_rightSelectionAnchor removeFromSuperview];
        _rightSelectionAnchor = nil;
    }
}

- (void)removeMaginfierView {
    if (_magnifierView) {
        [_magnifierView removeFromSuperview];
        _magnifierView = nil;
    }
}

@end