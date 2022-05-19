//
//  Status.m
//  wb
//
//  Created by Admin on 2022/4/26.
//  Copyright © 2022年 admin. All rights reserved.
//

#import "Status.h"
#import <UIKit/UIKit.h>

@implementation Status

- (instancetype)initWithDict:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)statusWithDict:(NSDictionary *)dict{
    return [[self alloc]initWithDict:dict];
}


@end
