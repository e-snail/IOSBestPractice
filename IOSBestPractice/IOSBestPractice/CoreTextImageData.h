//
//  CoreTextImageData.h
//  IOSBestPractice
//
//  Created by 吴永波 on 16/1/3.
//  Copyright © 2016年 Wilbur.Wu. All rights reserved.
//

#ifndef CoreTextImageData_h
#define CoreTextImageData_h

#import <Foundation/Foundation.h>

@interface CoreTextImageData : NSObject

@property (strong, nonatomic) NSString *name;
@property (nonatomic) int position;
//CoreText的坐标系，不是UIKit的坐标系
@property (nonatomic) CGRect imagePosition;

@end

#endif /* CoreTextImageData_h */
