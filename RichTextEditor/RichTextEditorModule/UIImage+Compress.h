//
//  UIImage+Compress.h
//  HeroGameBox
//
//  Created by zcy on 2021/1/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Compress)
//此方法是先压缩质量，如果还不能满足 压缩的要求 ，就压缩图片的大小，压缩比例过低也没问题 -- 推荐使用
- (NSData *)compressWithMaxLengthKB:(NSUInteger)maxLengthKB;

/// 指定图片压缩到指定大小并压缩比例
/// @param imageWidth 图片压缩后的宽
/// @param imageHeight 图片压缩后的宽
/// @param compression 图片压缩比例
- (NSData *)compressWithWidth: (NSUInteger)imageWidth height: (NSUInteger)imageHeight compression: (NSUInteger)compression;

//此方法是先压缩质量，如果还不能满足 压缩的要求 ，就压缩图片的大小，压缩比例过低也没问题 -- 推荐使用
+ (void)compressWithMaxLengthKB:(NSUInteger)maxLengthKB image:(UIImage *)image Block :(void (^)(NSData *imageData))block;

@end

NS_ASSUME_NONNULL_END
