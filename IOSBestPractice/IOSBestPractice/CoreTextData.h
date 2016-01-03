//
//  CoreTextData.h
//  IOSBestPractice
//
//  Created by 吴永波 on 16/1/3.
//  Copyright © 2016年 Wilbur.Wu. All rights reserved.
//

#ifndef CoreTextData_h
#define CoreTextData_h

#import <UIKit/UIKit.h>

/**
 * 用于保存由CTFrameParser类生成的CTFrameRef实例，以及CTFrameRef实际绘制需要的高度
 */
@interface CoreTextData : NSObject

@property (assign, nonatomic) CTFrameRef ctFrameRef;
@property (assign, nonatomic) CGFloat height;
@property (strong, nonatomic) NSArray *linkList;
@property (strong, nonatomic) NSArray *imageList;
@property (strong, nonatomic) NSAttributedString *content;

@end

#endif /* CoreTextData_h */
