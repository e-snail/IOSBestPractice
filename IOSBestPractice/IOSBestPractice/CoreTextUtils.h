//
//  CoreTextUtils.h
//  IOSBestPractice
//
//  Created by 吴永波 on 16/1/3.
//  Copyright © 2016年 Wilbur.Wu. All rights reserved.
//

#ifndef CoreTextUtils_h
#define CoreTextUtils_h

#import <Foundation/Foundation.h>
#import "CoreTextLinkData.h"
#import "CoreTextData.h"

@interface CoreTextUtils : NSObject

+ (CoreTextLinkData *)touchLinkInView:(UIView *)view atPoint:(CGPoint)point data:(CoreTextData*)data;

+ (CFIndex)touchContentOffsetInView:(UIView *)view atPoint:(CGPoint)point data:(CoreTextData*)data;

@end

#endif /* CoreTextUtils_h */
