//
//  NewStatusViewController.h
//  wb
//
//  Created by Admin on 2022/5/12.
//  Copyright © 2022年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewStatusViewController : UIViewController

@property (nonatomic,strong) NSMutableDictionary *userData;
@property (nonatomic,strong) NSString *StatusPath;
@property (nonatomic,strong) NSMutableArray *NewStatusArr;


@end

NS_ASSUME_NONNULL_END
