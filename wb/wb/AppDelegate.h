//
//  AppDelegate.h
//  wb
//
//  Created by Admin on 2022/4/25.
//  Copyright © 2022年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "MeViewController.h"
#import "HomeViewController.h"
#import "LoginViewController.h"
#import "UserTableViewCell.h"
#import "SearchViewController.h"



@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;
@property (strong,nonatomic) UINavigationController *HomeNavViewController;
@property (strong,nonatomic) UINavigationController *MessageNavViewController;
@property (strong,nonatomic) UINavigationController *MineNavViewController;
@property (strong,nonatomic) UINavigationController *SearchNavViewController;

@property (strong,nonatomic) NSString *wbtoken;

- (void)saveContext;


@end

