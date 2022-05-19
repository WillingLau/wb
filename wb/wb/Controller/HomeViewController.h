//
//  HomeViewController.h
//  wb
//
//  Created by Admin on 2022/4/27.
//  Copyright © 2022年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailViewController.h"
#import "NewStatusViewController.h"
#import "LoginViewController.h"


NS_ASSUME_NONNULL_BEGIN

@interface HomeViewController : UITableViewController

@property (nonatomic,strong) NSString *StatusFile;
@property (nonatomic,strong) NSString *historyDataFileName;
@property (nonatomic,strong) NSString *likeStatusDataFileName;

//储存已存入本地的微博
@property (nonatomic,strong) NSMutableArray *dataArr;
//储存自己本地发的微博的数据的数组
@property (nonatomic,strong) NSMutableArray *NewStatusDataArr;
//点击网页链接后跳转的view
@property (nonatomic,strong) DetailViewController *detailViewController;
//浏览记录
@property (nonatomic,strong) NSMutableArray *historyStatusFrameTostore;
//收藏记录
@property (nonatomic,strong) NSMutableArray *likeStatusTostore;

-(void)jumpToURL:(UITapGestureRecognizer *)param;
@end

NS_ASSUME_NONNULL_END
