//
//  NewStatusViewController.m
//  wb
//
//  Created by Admin on 2022/5/12.
//  Copyright © 2022年 admin. All rights reserved.
//

#import "NewStatusViewController.h"

@interface NewStatusViewController ()<UITextViewDelegate> {
    UITextView *_textView;
}

@end

@implementation NewStatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _textView.delegate  = self;
    [self.view addSubview:_textView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(addDone)];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *plistPath = [paths objectAtIndex:0];
    NSString *path = [plistPath stringByAppendingPathComponent:@"UserInfo.plist"];
    NSMutableDictionary *UserData = [[NSMutableDictionary alloc]initWithContentsOfFile:path];
    self.userData = [[NSMutableDictionary alloc]init];
    [self.userData setObject:[UserData objectForKey:@"name"] forKey:@"name"];
    [self.userData setObject:[UserData objectForKey:@"iconUrl"] forKey:@"icon"];
    NSLog(@"%@",UserData);

    [_textView becomeFirstResponder];
    
    NSArray *StatusPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *StatusPlistPath = [StatusPaths objectAtIndex:0];
    self.StatusPath = [StatusPlistPath stringByAppendingPathComponent:@"NewStatus.plist"];
    self.NewStatusArr = [[NSMutableArray alloc]initWithContentsOfFile:self.StatusPath];

    
}

//点击"完成" 完成新建
- (void)addDone {
    [self.navigationController popViewControllerAnimated:YES];
    //空的内容，不添加
    if ([_textView.text isEqualToString:@""]) {
        return;
    }
    //获取当前添加的时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm"];
    NSString *time = [formatter stringFromDate:[NSDate date]];
    [self.userData setObject:time forKey:@"time"];
    //获取内容
    NSString *text = _textView.text;
    [self.userData setObject:text forKey:@"text"];
    //
    NSString *attitudes_count = @"777";
    [self.userData setObject:attitudes_count forKey:@"likeCount"];
    //
    NSString *reposts_count = @"666";
    [self.userData setObject:reposts_count forKey:@"reportsCount"];
    //
    NSString *comments_count = @"999";
    [self.userData setObject:comments_count forKey:@"commentsCount"];
    //
    
    NSMutableArray *DataToStore = [[NSMutableArray alloc]init];
    [DataToStore addObjectsFromArray:self.NewStatusArr];
    [DataToStore insertObject:self.userData atIndex:0];
    
    if([DataToStore writeToFile:self.StatusPath atomically:YES])
    {NSLog(@"yes");
    }
    
  //  _textView.text = @"";//防止下次进入页面还有以前的数据
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
