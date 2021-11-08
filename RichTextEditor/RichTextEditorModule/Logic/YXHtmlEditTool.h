//
//  YXHtmlEditTool.h
//  RichTextEditorDemo
//
//  Created by zcy on 2020/11/27.
//

#import <Foundation/Foundation.h>
//#import "YXEmojiDataManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface YXHtmlEditTool : NSObject

/// 获取IMG标签
+ (NSArray *)getImgTags:(NSString *)htmlText;

/// 获取上传图片list
+ (NSArray *)getUploadImgTags:(NSString *)htmlText;

/// 正则匹配
+ (NSArray *)matchString:(NSString *)string toRegexString:(NSString *)regexStr;
/**
 * 正则替换
 */
+ (NSString *)matchReplaceHtmlString:(NSString *)string
                         RegexString:(NSString *)regexStr
                          withString:(NSString *)replaceStr;

@end

NS_ASSUME_NONNULL_END
