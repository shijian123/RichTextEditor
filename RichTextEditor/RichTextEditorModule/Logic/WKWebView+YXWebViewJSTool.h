//
//  WKWebView+YXWebViewJSTool.h
//  RichTextEditorDemo
//
//  Created by zcy on 2020/11/19.
//

#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WKWebView (YXWebViewJSTool)

/**
 *  返回标题文本
 */
//- (void)titleTextHandler:(void(^)(id))success;

/**
 *  设置标题内容
 @param title   标题内容
 */
//- (void)setupTitle:(NSString *)title;

/**
 *  返回文本内容
 */
- (void)contentTextHandler:(void(^)(id))success;

/**
 *  返回带标签的html格式的文本内容
 */
- (void)contentHtmlTextHandler:(void(^)(id))success;

/**
 *  设置文本内容

 @param content 内容
 */
- (void)setupContent:(NSString *)content;

/// 设置文本，修改本地图片类名重置为网络图
- (void)setupYXContent:(NSString *)content;

/// 监听复制事件，并删除内容格式
- (void)setupListenerPaste;

/**
 *  添加html
 */
- (void)insertHTML:(NSString *)htmlStr;

/**
 :初始化文章
 */
- (void)setupHtmlContent:(NSString *)content;
/**
 *  清除内容的占位文本
 */
- (void)clearContentPlaceholder;
/**
 *  动态更改占位符内容
 */
- (void)changePlaceholder:(NSString *)placeholder;

/// 在html尾部追加内容
- (void)appendContent:(NSString *)content;

/**
 *  显示内容的占位文本
 */
- (void)showContentPlaceholder;
/**
 *  内容可编辑
 */
- (void)setupEditEnable:(BOOL)enable;

//撤销
- (void)undo;
- (void)redo;
//加粗
- (void)bold;
//下划线
- (void)underline;
//斜体
- (void)italic;
//左对齐
- (void)justifyLeft;
//居中对齐
- (void)justifyCenter;
//右对齐
- (void)justifyRight;
// 向里缩进
- (void)indent;
// 向外缩进
- (void)outdent;

- (void)blockQuote;
//无序
- (void)orderlist;
- (void)unorderlist;

/**
 *  内容默认14号字体
 */
- (void)normalFontSize;

/**
 *  内容18号字体 (如需修改在normalize.css h1标签里面修改即可)
 */
- (void)heading1;

/**
 *  内容16号字体 (如需修改在normalize.css h1标签里面修改即可)
 */
- (void)heading2;

/**
 *  内容14号字体 (默认14,如需修改在normalize.css h1标签里面修改即可)
 */
- (void)heading3;

/**
 *  插入链接
 @param url     链接地址
 @param title   链接标题
 @param content 链接内容
 */
- (void)insertLinkUrl:(NSString *)url title:(NSString*)title content:(NSString *)content;

/**
 *  插入图片链接
 @param imageUrl 图片地址
 @param alt 图片标题
 */
- (void)insertImageUrl:(NSString *)imageUrl alt:(NSString *)alt;
/**
 *  插入图片 有删除按钮
 */
- (void)insertImageUrl:(NSString *)imageUrl delUrl:(NSString *)delUrl alt:(NSString *)alt;
/**
 :设置 插入图片的 点击事件
 */
- (void)insertUpdateImg:(NSString *)imageKey imgUrl:(NSString *)imgUrl;
/**
 *  清除被选中的链接内容
 */
- (void)clearLink;

/**
 *  获取被选中的内容
 */
//- (NSString *)getSelection;
- (void)getSelectionHandler:(void(^)(id))success;

/**
 *  获取被选中内容标签内容
 */
//- (NSString *)getSelectString;
- (void)getSelectStringHandler:(void(^)(id))success;

//- (CGFloat)getCaretYPosition;
- (void)getCaretYPositionHandler:(void(^)(id))success;

//- (CGFloat)calculateEditorHeightWithCaretPosition;
- (void)calculateEditorHeightWithCaretPositionHandler:(void(^)(id))success;


/// 滚动到对应位置
- (void)autoScrollTop:(CGFloat)offsetY;

/**
 *  设置字体大小
 */
- (void)setFontSize:(NSString *)size;



/**
 *  插入图片
 @param imageData 二进制数据(BASE64编码)
 @param key 图片的唯一ID（为了后面点击图片进行后续操作）
 */
- (void)insertImage:(NSData *)imageData key:(NSString *)key;


/// 追加图片
/// @param imageData 二进制数据(BASE64编码)
/// @param key 图片的唯一ID（为了后面点击图片进行后续操作）
- (void)appendImage:(NSData *)imageData key:(NSString *)key;


/**
 *  更新图片的进度条
 @param imageKey 图片的唯一ID
 @param progress 进度值
 */
- (void)insertImageKey:(NSString *)imageKey progress:(CGFloat)progress;

/// 加载本地图片
/// @param imageData 本地图片的Data
/// @param key 本地图片的Id
- (void)insertLocalImage:(NSData *)imageData key:(NSString *)key;

//图片上传成功 替换img标签

/**
 *  图片上传成功，替换成图片地址
 @param imageKey 图片的唯一ID
 @param imgUrl 图片URL
 */
//- (void)insertSuccessImageKey:(NSString *)imageKey imgUrl:(NSString *)imgUrl;

/// 图片上传成功，替换成图片地址
/// @param imageKey 图片的唯一ID
/// @param imgUrl 图片URL
/// @param img_size 图片的宽高
/// @param div_h div的高度
- (void)insertSuccessImageKey:(NSString *)imageKey imgUrl:(NSString *)imgUrl img_size:(CGSize)img_size div_h:(CGFloat)div_h;

/**
 *  加载视频
 */
- (void)insertSuccessVideoKey:(NSString *)videoKey videoUrl:(NSString *)videoUrl;


/// 为图片添加删除事件
/// @param key 图片的唯一ID
- (void)addImgEventKey:(NSString *)key;

/**
 *  删除图片
 @param key 图片的唯一ID
 */
- (void)deleteImageKey:(NSString *)key;
/**
 *  删除视频
 @param key 视频的唯一ID
 */
- (void)deleteVideoKey:(NSString *)key;

/**
 *  删除图片上传失败的样式

 @param key 图片的唯一ID
 @param isHide 是否显示失败按钮
 */
- (void)removeBtnErrorKey:(NSString *)key isHide:(BOOL)isHide;

/**
 *  设置图片上传失败的样式
 @param key 图片的唯一ID
 */
- (void)uploadErrorKey:(NSString *)key;

/**
 *  设置编辑器内容是否可编辑(解决弹出键盘问题)
 */
- (void)setupContentDisable:(BOOL)disable;


/**
 *  聚焦标题
 */
- (void)showKeyboardTitle;

/**
 *  聚焦内容
 */
- (void)showKeyboardContent;

/**
 *  唤起键盘
 */
- (void)focusTextEditor;

/**
 *  键盘退出
 */
- (void)hiddenKeyboard;


/**
 *  处理HTML的特殊字符转换成文本内容
 */
- (NSString *)removeQuotesFromHTML:(NSString *)html;

/// 添加外链卡片
/// @param cardKey 卡片ID
/// @param cardHtml 卡片html
- (void)insertLinkCardKey:(NSString *)cardKey cardHtml:(NSString *)cardHtml;


/// 外链卡片新增响应事件
/// @param key 卡片的id
- (void)addCardEventKey:(NSString *)key;

/// 删除外链卡片
/// @param key 卡片ID
- (void)deleteLinkCardKey:(NSString *)key;


@end


@interface NSString (UUID)

/**
 *  获取图片的唯一ID
 */
+ (NSString *)imageUUID;

- (id)jsonObject;

@end

NS_ASSUME_NONNULL_END
