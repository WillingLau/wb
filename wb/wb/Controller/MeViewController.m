//
//  MeViewController.m
//  wb
//
//  Created by Admin on 2022/4/26.
//  Copyright © 2022年 admin. All rights reserved.
//

#import "MeViewController.h"
#import "HistoryTableViewController.h"
#import "LikesTableViewController.h"

@interface MeViewController ()

@property (nonatomic,strong) NSDictionary *dic;

@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _mine = @[@"请登录",@"收藏",@"历史记录",@"登录"];
    self.navigationItem.title = @"我的";
    self.tableView.delegate = self;
    self.navigationController.navigationBar.barTintColor = [UIColor orangeColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];

}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
//    return 0;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _mine.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 100;
    }
    else{
    return 50;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    

    if (indexPath.row == 0) {
        NSString *cellIdentifier = @"MECellIdentifier";
        UserTableViewCell *userCell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *plistPath = [paths objectAtIndex:0];
        NSString *path = [plistPath stringByAppendingPathComponent:@"UserInfo.plist"];
        NSMutableDictionary *userData = [[NSMutableDictionary alloc]initWithContentsOfFile:path];
        if (userCell || userData) {
            userCell = [[UserTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
            
            return userCell;
            
        }
    }
    
    
    NSString *cellIdentifier = @"MECellIdentifier";
    UITableViewCell *cell;
    cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell =  [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = _mine[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 3) {
        self.loginviewController = [[LoginViewController alloc]init];
        [self.navigationController pushViewController:self.loginviewController animated:YES];
    }
    //点击跳转个人主页
    else if(indexPath.row == 0){
        self.myBolgViewController = [[MyBlogViewController alloc]init];
         self.myBolgViewController.dataFileName = self.dataFileName;
        [self.navigationController pushViewController:self.myBolgViewController animated:YES];
    }
    //点击跳转浏览历史
    else if (indexPath.row == 2){
        HistoryTableViewController *historyStatusView = [[HistoryTableViewController alloc]init];
        [self.navigationController pushViewController:historyStatusView animated:YES];
    }
    //点击浏览收藏微博
    else if (indexPath.row == 1){
        LikesTableViewController *likeViewController = [[LikesTableViewController alloc]init];
        [self.navigationController pushViewController:likeViewController animated:YES];
    }
    
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
