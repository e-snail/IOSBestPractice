//
//  CTFrameParser.h
//  IOSBestPractice
//
//  Created by 吴永波 on 16/1/3.
//  Copyright © 2016年 Wilbur.Wu. All rights reserved.
//

#ifndef CTFrameParser_h
#define CTFrameParser_h

#import "CTFrameParserConfig.h"
#import "CoreTextData.h"

/**
 * 用于生成最后绘制界面需要的CTFrameRef实例
 */
@interface CTFrameParser : NSObject

+ (NSMutableDictionary *)attributesWithConfig:(CTFrameParserConfig *)config;

+ (CoreTextData *)parseContent:(NSString *)content config:(CTFrameParserConfig*)config;

+ (CoreTextData *)parseAttributedContent:(NSAttributedString *)content config:(CTFrameParserConfig*)config;

+ (CoreTextData *)parseTemplateFile:(NSString *)path config:(CTFrameParserConfig*)config;


@end

#endif /* CTFrameParser_h */
