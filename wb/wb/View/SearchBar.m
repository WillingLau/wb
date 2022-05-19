//
//  SearchBar.m
//  wb
//
//  Created by Admin on 2022/5/14.
//  Copyright © 2022年 admin. All rights reserved.
//

#import "SearchBar.h"

@interface SearchBar ()<UITextFieldDelegate>

@property (nonatomic,strong,readwrite) UITextField *textField;
@property (nonatomic,strong) NSMutableArray *StatusForSearch;

@end

@implementation SearchBar

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:({
            
            _textField = [[UITextField alloc]initWithFrame:CGRectMake(10,5, frame.size.width - 20, frame.size.height-10)];
            _textField.backgroundColor = [UIColor whiteColor];
            _textField.delegate = self;
            _textField.leftView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"search"]];
            _textField.leftViewMode = UITextFieldViewModeAlways;
            _textField.clearButtonMode = UITextFieldViewModeAlways;
            _textField.placeholder = @"请输入搜索内容";
            _textField;
            
        })];
    }
    
    return self;
}

#pragma mark delegate

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [_textField becomeFirstResponder];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *plistPath = [paths objectAtIndex:0];
    NSString *statusDataFileName = [plistPath stringByAppendingPathComponent:@"HistoryStatus.plist"];
    self.StatusForSearch = [[NSMutableArray alloc]initWithContentsOfFile:statusDataFileName];
    
}

#pragma mark 实现搜索

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    NSMutableArray *StatusSearchedArr = [[NSMutableArray alloc]init];
    
    BOOL isFind = NO;
    BOOL isEqual = NO;//是否重复找到同一个微博
    NSMutableArray *didFindStatusTextArr = [[NSMutableArray alloc]init];
    
    for (NSDictionary *tmpDic in self.StatusForSearch) {
        if ([[tmpDic objectForKey:@"text"] containsString:textField.text] || [[tmpDic objectForKey:@"name"] containsString:textField.text])
        {
            for (NSString *textInArr in didFindStatusTextArr) {
                if ([tmpDic objectForKey:@"text"] == textInArr) {
                    isEqual = YES;//找到重复微博
                    break;//中断遍历
                }
            }
            if (!isEqual) {//没找到重复微博
                [didFindStatusTextArr addObject:[tmpDic objectForKey:@"text"]];//将第一次找到的text存入arr
                [StatusSearchedArr addObject:tmpDic];
            }
            isFind = YES;
        }
    }
    
    
    if (isFind) {
        [self.delegate pushSearchedStatusWith:StatusSearchedArr];
    }
    else{
        [self.delegate notFindStatus];
    }
    

}

#pragma mark 实现记录搜索历史记录，持久化
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *plistPath = [paths objectAtIndex:0];
    NSString *searchDataFileName = [plistPath stringByAppendingPathComponent:@"SearchHistory.plist"];
    //先读出文件里的内容，防止被覆盖丢失
    NSMutableArray *fileData = [[NSMutableArray alloc]initWithContentsOfFile:searchDataFileName];
    //先查看记录中有无相同记录,有则删除，防止历史记录重复
    if([fileData containsObject:textField.text]) {
        [fileData removeObject:textField.text];
    }
    
    NSMutableArray *searchHistory = [[NSMutableArray alloc]init];
    
    [searchHistory addObjectsFromArray:fileData];
    
    [searchHistory insertObject:textField.text atIndex:0];
    
    [searchHistory writeToFile:searchDataFileName atomically:YES];
    
    [_textField resignFirstResponder];
    
    return YES;
}

-(void)keyboardHide:(UITapGestureRecognizer *)tap {
    [_textField resignFirstResponder];
}

@end
