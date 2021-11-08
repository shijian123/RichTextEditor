//
//  YXHtmlEditTool.m
//  RichTextEditorDemo
//
//  Created by zcy on 2020/11/27.
//

#import "YXHtmlEditTool.h"

@implementation YXHtmlEditTool

/// 获取IMG标签
+ (NSArray *)getImgTags:(NSString *)htmlText {
    if (htmlText == nil) {
        return nil;
    }
    NSError *error;
    NSString *regulaStr = @"<img[^>]+src\\s*=\\s*['\"]([^'\"]+)['\"][^>]*>";
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern:regulaStr
                                  options:NSRegularExpressionCaseInsensitive
                                  error:&error];
    NSArray *arrayOfAllMatches =
    [regex matchesInString:htmlText
                   options:0
                     range:NSMakeRange(0, [htmlText length])];
    
    return arrayOfAllMatches;
}

/// 获取上传图片list
+ (NSArray *)getUploadImgTags:(NSString *)htmlText {
    if (htmlText == nil) {
        return nil;
    }
    NSError *error;
    NSString *regulaStr = @"networkImage-f-div";
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern:regulaStr
                                  options:NSRegularExpressionCaseInsensitive
                                  error:&error];
    NSArray *arrayOfAllMatches =
    [regex matchesInString:htmlText
                   options:0
                     range:NSMakeRange(0, [htmlText length])];
    
    return arrayOfAllMatches;
}

/// 正则匹配
+ (NSArray *)matchString:(NSString *)string toRegexString:(NSString *)regexStr {
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern:regexStr
                                  options:NSRegularExpressionCaseInsensitive
                                  error:nil];
    
    NSArray *matches = [regex matchesInString:string
                                      options:0
                                        range:NSMakeRange(0, [string length])];
    // match: 所有匹配到的字符,根据() 包含级
    NSMutableArray *array = [NSMutableArray array];
    
    for (NSTextCheckingResult *match in matches) {
        for (int i = 0; i < [match numberOfRanges]; i++) {
            //以正则中的(),划分成不同的匹配部分
            NSString *component = [string substringWithRange:[match rangeAtIndex:i]];
            
            [array addObject:component];
        }
    }
    return array;
}

/**
 * 正则替换
 */
+ (NSString *)matchReplaceHtmlString:(NSString *)string
                         RegexString:(NSString *)regexStr
                          withString:(NSString *)replaceStr {
    if (!string || string.length == 0 || regexStr.length == 0 ||
        replaceStr.length == 0) {
        return string;
    }
    
    NSRegularExpression *regularExpretion =
    [NSRegularExpression regularExpressionWithPattern:regexStr
                                              options:0
                                                error:nil];
    string = [regularExpretion
              stringByReplacingMatchesInString:string
              options:NSMatchingReportProgress
              range:NSMakeRange(0, string.length)
              withTemplate:replaceStr];
    
    return string;
}

@end
