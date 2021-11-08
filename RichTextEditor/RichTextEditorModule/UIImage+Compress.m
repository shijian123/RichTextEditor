//
//  UIImage+Compress.m
//  HeroGameBox
//
//  Created by zcy on 2021/1/12.
//

#import "UIImage+Compress.h"

#ifdef DEBUG
#   define XLog(fmt, ...) NSLog((@"\nfunction:%s,line:%d\n" fmt @"\n"), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define XLog(...)
#endif

@implementation UIImage (Compress)


/// 压缩图片到指定大小
/// @param maxLengthKB 压缩到的大小
- (NSData *)compressWithMaxLengthKB:(NSUInteger)maxLengthKB {
    if (maxLengthKB <= 0 || [self isKindOfClass:[NSNull class]] || self == nil) {
        return nil;
    };
    // 扩展20kb
    maxLengthKB = maxLengthKB+20;
    maxLengthKB = maxLengthKB*1024;
    
    CGFloat compression = 0.8;
    NSData *data = UIImageJPEGRepresentation(self, compression);
    XLog(@"初始 : %ld KB",data.length/1024);
    if (data.length < maxLengthKB){
        XLog(@"压缩完成： %zd kb", data.length/1024);
        return data;
    }
    
    //质量压缩
    CGFloat scale = 1;
    CGFloat lastLength=0;
    for (int i = 0; i < 7; ++i) {
        compression = scale / 2;
        data = UIImageJPEGRepresentation(self, compression);
        XLog(@"质量压缩中： %ld KB", data.length / 1024);
        if (i>0) {
            if (data.length>0.95*lastLength) break;//当前压缩后大小和上一次进行对比，如果大小变化不大就退出循环
        }
        if (data.length < maxLengthKB) break;//当前压缩后大小和目标大小进行对比，小于则退出循环
        scale = compression;
        lastLength = data.length;
        
    }
    XLog(@"压缩图片质量后: %ld KB", data.length / 1024);
    if (data.length < maxLengthKB){
        XLog(@"压缩完成： %ld kb", data.length/1024);
        return data;
    }
    
    //大小压缩
    UIImage *resultImage = [UIImage imageWithData:data];
    NSUInteger lastDataLength = 0;
    while (data.length > maxLengthKB && data.length != lastDataLength) {
        lastDataLength = data.length;
        CGFloat ratio = (CGFloat)maxLengthKB / data.length;
        XLog(@"Ratio = %.1f", ratio);
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio)));
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(resultImage, compression);
        XLog(@"绘图压缩中： %ld KB", data.length / 1024);
    }

    XLog(@"压缩完成： %ld kb", data.length/1024);
    return data;
}

/*
 *maxLengthKB 压缩到的大小
 *image 准备压缩的图片
 */
+ (void)compressWithMaxLengthKB:(NSUInteger)maxLengthKB image:(UIImage *)image Block :(void (^)(NSData *imageData))block{
    if (maxLengthKB <= 0 || [image isKindOfClass:[NSNull class]] || image == nil) block(nil);
    
    maxLengthKB = maxLengthKB*1024;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        CGFloat compression = 1;
        NSData *data = UIImageJPEGRepresentation(image, compression);
        XLog(@"初始 : %ld KB",data.length/1024);
        if (data.length < maxLengthKB){
            dispatch_async(dispatch_get_main_queue(), ^{
                XLog(@"压缩完成： %zd kb", data.length/1024);
                block(data);
            });
            return;
        }
        
        //质量压缩
        CGFloat scale = 1;
        CGFloat lastLength=0;
        for (int i = 0; i < 7; ++i) {
            compression = scale / 2;
            data = UIImageJPEGRepresentation(image, compression);
            XLog(@"质量压缩中： %ld KB", data.length / 1024);
            if (i>0) {
                if (data.length>0.95*lastLength) break;//当前压缩后大小和上一次进行对比，如果大小变化不大就退出循环
                if (data.length < maxLengthKB) break;//当前压缩后大小和目标大小进行对比，小于则退出循环
            }
            scale = compression;
            lastLength = data.length;
            
        }
        XLog(@"压缩图片质量后: %ld KB", data.length / 1024);
        if (data.length < maxLengthKB){
            dispatch_async(dispatch_get_main_queue(), ^{
                XLog(@"压缩完成： %zd kb", data.length/1024);
                block(data);
            });
            return;
        }
        
        //大小压缩
        UIImage *resultImage = [UIImage imageWithData:data];
        NSUInteger lastDataLength = 0;
        while (data.length > maxLengthKB && data.length != lastDataLength) {
            lastDataLength = data.length;
            CGFloat ratio = (CGFloat)maxLengthKB / data.length;
            XLog(@"Ratio = %.1f", ratio);
            CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                     (NSUInteger)(resultImage.size.height * sqrtf(ratio)));
            UIGraphicsBeginImageContext(size);
            [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
            resultImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            data = UIImageJPEGRepresentation(resultImage, compression);
            XLog(@"绘图压缩中： %ld KB", data.length / 1024);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            XLog(@"压缩完成： %ld kb", data.length/1024);
            block(data);
        });return;
    });
    
}

/// 指定图片压缩到指定大小并压缩比例
/// @param imageWidth 图片压缩后的宽
/// @param imageHeight 图片压缩后的宽
/// @param compression 图片压缩比例
- (NSData *)compressWithWidth: (NSUInteger)imageWidth height: (NSUInteger)imageHeight compression: (NSUInteger)compression {
    
    // 默认最大300KB 扩展20kb
    NSUInteger maxLengthKB = 300+20;
    maxLengthKB = maxLengthKB*1024;
    
    NSData *data = UIImageJPEGRepresentation(self, compression);
    XLog(@"初始 : %ld KB",data.length/1024);
    if (data.length < maxLengthKB){
        XLog(@"压缩完成： %zd kb", data.length/1024);
        return data;
    }
    
    UIImage *resultImage = [UIImage imageWithData:data];
    CGSize size = CGSizeMake(imageWidth, imageHeight);
    UIGraphicsBeginImageContext(size);
    [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
    resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    data = UIImageJPEGRepresentation(resultImage, compression);
    XLog(@"压缩完成： %ld kb", data.length/1024);
    return data;

}

@end
