//
//  SearchViewController.m
//  wb
//
//  Created by Admin on 2022/5/14.
//  Copyright © 2022年 admin. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchBar.h"
#import "PushSearchedProtocol.h"
#import "SearchedStatusViewController.h"

@interface SearchViewController ()<PushSearchedProtocol>

@property (nonatomic,strong) NSMutableArray *searchHistory;
@property (nonatomic,strong) NSMutableArray *statusFrames;//存放所有微博的模型和数据
@property (nonatomic,strong) NSString *searchDataFileName;
@property (nonatomic,strong) SearchBar *searchBar;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super loadView];
    
    self.navigationController.navigationBar.barTintColor = [UIColor orangeColor];
    self.searchBar = [[SearchBar alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 20, self.navigationController.navigationBar.bounds.size.height)];
    self.navigationItem.titleView = self.searchBar;
    self.searchBar.delegate = self;
    //设置隐藏键盘手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self.searchBar action:@selector(keyboardHide:)];
    tap.cancelsTouchesInView = NO;//设置为no表示当前控件响应后会传播到其他控件上，默认是yes
    [self.view addGestureRecognizer:tap];
   
}

-(void)viewWillAppear:(BOOL)animated{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *plistPath = [paths objectAtIndex:0];
    self.searchDataFileName = [plistPath stringByAppendingPathComponent:@"SearchHistory.plist"];
    self.searchHistory = [[NSMutableArray alloc]initWithContentsOfFile:self.searchDataFileName];
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.searchHistory.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier = @"SearchCellIdentifier";
    UITableViewCell *cell;
    cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell =  [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = self.searchHistory[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableArray *StatusSearchedArr = [[NSMutableArray alloc]init];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *plistPath = [paths objectAtIndex:0];
    NSString *historyStatusFile = [plistPath stringByAppendingPathComponent:@"HistoryStatus.plist"];
    NSMutableArray *dataArr = [[NSMutableArray alloc] initWithContentsOfFile:historyStatusFile];
    
    BOOL isFind = NO;//是否找到对应微博
    BOOL isEqual = NO;//是否重复找到同一个微博
    NSMutableArray *didFindStatusTextArr = [[NSMutableArray alloc]init];
    
    for (NSDictionary *tmpDic in dataArr) {
        if ([[tmpDic objectForKey:@"text"] containsString:self.searchHistory[indexPath.row]] || [[tmpDic objectForKey:@"name"] containsString:self.searchHistory[indexPath.row]])
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
    
    NSString *searchTOtop = self.searchHistory[indexPath.row];
    [self.searchHistory removeObjectAtIndex:indexPath.row];
    [self.searchHistory insertObject:searchTOtop atIndex:0];
    [self.searchHistory writeToFile:self.searchDataFileName atomically:YES];
    
    if (isFind) {
        [self pushSearchedStatusWith:StatusSearchedArr];
    }
    else{
        [self notFindStatus];
    }
    
}


#pragma mark 滑动删除
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(editingStyle == UITableViewCellEditingStyleDelete) {
        [self.searchHistory removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
        [self.searchHistory writeToFile:self.searchDataFileName atomically:YES];
    }
}

#pragma mark 更改滑动按钮文本
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

-(void)pushSearchedStatusWith:(NSArray *)SearchedStatus{
    
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *plistPath = [paths objectAtIndex:0];
        NSString *StatusSearchedFileName = [plistPath stringByAppendingPathComponent:@"statusSearched.plist"];
        [SearchedStatus writeToFile:StatusSearchedFileName atomically:YES];
        SearchedStatusViewController *StatusView = [[SearchedStatusViewController alloc]init];
        [self.navigationController pushViewController:StatusView animated:YES];
    
}
-(void)notFindStatus{

     UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"搜索失败" message:@"没有找到有关的微博" preferredStyle:UIAlertControllerStyleAlert];
     UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel
     handler:^(UIAlertAction * action) {
     [self.navigationController popViewControllerAnimated:YES];
     }];
     [alert addAction:cancelAction];//添加按钮
     [self presentViewController:alert animated:YES completion:nil];
    //重新读取数据，才能更新
     self.searchHistory = [[NSMutableArray alloc]initWithContentsOfFile:self.searchDataFileName];
     [self.tableView reloadData];
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
