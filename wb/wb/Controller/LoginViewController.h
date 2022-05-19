//
//  LoginViewController.h
//  wb
//
//  Created by Admin on 2022/5/3.
//  Copyright © 2022年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface LoginViewController : UIViewController


@property(nonatomic,strong) NSMutableDictionary *userInfo;
@property(nonatomic,strong) NSMutableDictionary *StatusInfo;
@property (nonatomic,strong) NSString *uid;

@end

NS_ASSUME_NONNULL_END
