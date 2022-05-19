//
//  PushSearchedProtocol.h
//  wb
//
//  Created by Admin on 2022/5/14.
//  Copyright © 2022年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol PushSearchedProtocol <NSObject>

-(void)pushSearchedStatusWith:(NSArray *)SearchedStatus;
-(void)notFindStatus;

@end

NS_ASSUME_NONNULL_END
