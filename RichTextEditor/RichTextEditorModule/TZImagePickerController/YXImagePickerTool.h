//
//  YXImagePickerTool.h
//  HeroGameBox
//
//  Created by zdd on 2021/7/13.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface YXImagePickerTool : NSObject

+ (instancetype)shareInstance;
/// 判断图片的是否是GIF，是否超出限制大小
+ (void)yx_getImageData:(PHAsset *)asset completeHandler:(void (^)(BOOL isGifImage, BOOL overMaxLimit))completeHandler;

@end

NS_ASSUME_NONNULL_END
