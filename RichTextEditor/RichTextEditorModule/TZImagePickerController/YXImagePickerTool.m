//
//  YXImagePickerTool.m
//  HeroGameBox
//
//  Created by zdd on 2021/7/13.
//

#import "YXImagePickerTool.h"
#import <CoreServices/CoreServices.h>

@implementation YXImagePickerTool

+ (instancetype)shareInstance {
    
    static dispatch_once_t onceToken;
    static YXImagePickerTool *share = nil;
    dispatch_once(&onceToken, ^{
        if (share == nil) {
            share = [[YXImagePickerTool alloc] init];
        }
    });
    return share;
}

/// 判断图片的是否是GIF，是否超出限制大小
+ (void)yx_getImageData:(PHAsset *)asset completeHandler:(void (^)(BOOL isGifImage, BOOL overMaxLimit))completeHandler {
    
    PHImageManager * imageManager = [PHImageManager defaultManager];
    
    [imageManager requestImageDataForAsset:asset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        //NSURL *url = [info valueForKey:@"PHImageFileURLKey"];
        //NSString *str = [url absoluteString];   //url>string
        //NSArray *arr = [str componentsSeparatedByString:@"/"];
        //NSString *imgName = [arr lastObject];  // 图片名字
        NSInteger length = imageData.length;   // 图片大小，单位B
        //UIImage * image = [UIImage imageWithData:imageData];
        
        NSArray *tokens = @[@"bytes", @"KB", @"MB", @"GB", @"TB", @"PB", @"EB", @"ZB", @"YB"];
        
        NSInteger multiplyFactor = 0;
        
        CGFloat count = length;
        
        while (count > 1024) {
            count = count/1024;
            multiplyFactor += 1;
        }
        
        NSString *string = [NSString stringWithFormat:@"%4.2f %@", count, tokens[multiplyFactor]];
        
        NSLog(@"%@", string);
        
        BOOL isGifImage = NO;
        BOOL isOverMaxLimit = NO;
        //gif 图片
        if ([dataUTI isEqualToString:(__bridge NSString *)kUTTypeGIF]) {
            isGifImage = YES;
            // 判断单位为KB B
            if (multiplyFactor <= 1) {
                isOverMaxLimit = NO;
            }else if (multiplyFactor == 2) { //判断单位为MB
                isOverMaxLimit = [string floatValue] > 10;
            }else { //单位大于MB
                isOverMaxLimit = YES;
            }
            
        }else { // 其他格式图片
            isGifImage = NO;
            isOverMaxLimit = NO;
        }
        if (completeHandler) {
            completeHandler(isGifImage, isOverMaxLimit);
        }
    }];
    
}

@end
