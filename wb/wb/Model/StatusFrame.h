//
//  StatusFrame.h
//  wb
//
//  Created by Admin on 2022/4/29.
//  Copyright © 2022年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class Status;

@interface StatusFrame : NSObject
//头像尺寸
@property (nonatomic,assign,readonly) CGRect iconF;
//名字尺寸
@property (nonatomic,assign,readonly) CGRect nameF;
//正文尺寸
@property (nonatomic,assign,readonly) CGRect textF;
//图片尺寸
@property (nonatomic,assign,readonly) CGRect pictureF;
//点赞数尺寸
@property (nonatomic,assign,readonly) CGRect likesCountF;
//时间尺寸
@property (nonatomic,assign,readonly) CGRect timeF;
//转发数尺寸
@property (nonatomic,assign,readonly) CGRect reportsCountF;
//评论数尺寸
@property (nonatomic,assign,readonly) CGRect commentsCountF;
//cell的h高度
@property (nonatomic,assign,readonly) CGFloat cellHeight;
//网页链接的尺寸
@property (nonatomic,assign,readonly) CGRect sourceF;
//储存微博数据
@property (nonatomic,strong) Status *status;

//计算尺寸
- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize;

@end

NS_ASSUME_NONNULL_END
