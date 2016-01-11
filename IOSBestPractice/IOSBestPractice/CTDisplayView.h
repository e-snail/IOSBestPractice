//
//  CTDisplayView.h
//  IOSBestPractice
//
//  Created by 吴永波 on 16/1/2.
//  Copyright © 2016年 Wilbur.Wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreTextData.h"

extern NSString *const CTDisplayViewImagePressedNotification;
extern NSString *const CTDisplayViewLinkPressedNotification;

//持有CoreTextData类的实例，负责将CTFrameRef绘制到界面上
@interface CTDisplayView : UIView

@property (strong, nonatomic) CoreTextData *data;

@end