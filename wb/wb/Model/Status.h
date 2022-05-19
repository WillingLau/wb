//
//  Status.h
//  wb
//
//  Created by Admin on 2022/4/26.
//  Copyright © 2022年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Status : NSObject
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *icon;
@property (nonatomic,copy) NSString *text;
@property (nonatomic,copy) NSString *picture;
@property (nonatomic,copy) NSString *time;
@property (nonatomic,copy) NSString *likeCount;
@property (nonatomic,copy) NSString *commentsCount;
@property (nonatomic,copy) NSString *reportsCount;
@property (nonatomic,copy) NSString *source;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)statusWithDict:(NSDictionary *)dict;


@end

NS_ASSUME_NONNULL_END
