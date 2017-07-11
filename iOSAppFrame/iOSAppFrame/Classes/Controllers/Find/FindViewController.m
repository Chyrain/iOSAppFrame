//
//  FindViewController.m
//  iOSAppFrame
//
//  Created by chyrain on 2017/6/23.
//  Copyright © 2017年 Chyrain. All rights reserved.
//

#import "FindViewController.h"
#import "XLBubbleTransition.h"
#import "Masonry.h"
#import "AnimationsTableViewController.h"
#import "UIViewController+NIB.h"
#import "IBDesigbableImageview.h"

static NSString * cellIdentifier = @"hyCellID";
#define FIND_BG [UIColor orangeColor] //[UIColor colorWithRed:253/255.0 green:216/255.0 blue:97/255.0 alpha:1]

@interface FindViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet IBDesigbableImageview *desigableView;
@property (nonatomic, strong) UITableView * tableView;
@property (strong, nonatomic) UIButton *button;
@end

@implementation FindViewController

#pragma mark - life

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = LocalStr(@"Find", @"发现");
    self.view.backgroundColor = FIND_BG;
    
    //[self.view addSubview:self.tableView];
    
    //示例label
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor whiteColor];
    label.text = @"Hello!";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"AmericanTypewriter" size:40];
    label.textColor = [UIColor whiteColor];
    [self.view addSubview:label];
    [self setupConstraintsOfLabel:label];
    
    self.button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    self.button.center = CGPointMake(CGRectGetMidX(self.view.frame), CGRectGetMaxY(self.view.frame) - TAB_CENTER_BTN_MARGIN_BOTTOM);
    [self.button setImage:[UIImage imageNamed:@"Add_icn"] forState:UIControlStateNormal];
    [self.button setBackgroundColor:[UIColor whiteColor]];
    self.button.layer.cornerRadius = self.button.bounds.size.width/2.0f;
    [self.button addTarget:self action:@selector(popMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.button];
    
    //在ViewControllerB中添加Present和Dismiss的动画
    self.xl_presentTranstion = [XLBubbleTransition transitionWithAnchorRect:self.button.frame];
    self.xl_dismissTranstion = [XLBubbleTransition transitionWithAnchorRect:self.button.frame];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [UIView animateWithDuration:0.35f animations:^{
        [self.button setTransform:CGAffineTransformMakeRotation(M_PI_4)];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - selector

-(void)popMethod:(UIButton *)sender{
    //旋转X按钮
    [UIView animateWithDuration:0.35f animations:^{
        [sender setTransform:CGAffineTransformMakeRotation(-M_PI_4/2)];
    }];
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:true];
    } else{
        [self dismissViewControllerAnimated:true completion:nil];
    }
}

#pragma mark - Constraints & frame

- (void)setupConstraintsOfLabel:(UILabel *)label {
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.mas_equalTo(self.view);
        make.center.mas_equalTo(self.view);
    }];
}

#pragma mark - set_and_get

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = FIND_BG;
        
        //去掉tableView多余行
        [_tableView setTableHeaderView:[[UIView alloc] initWithFrame:CGRectZero]];
        [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
        //顶部预留状态栏距离
        _tableView.contentInset = UIEdgeInsetsMake(kStatusBarHeight, 0, 0, 0);
    }
    return _tableView;
}

- (NSArray *)dataArray {
    return @[@"UI - 动画"];
}

#pragma mark - dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self dataArray].count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = FIND_BG;//[UIColor orangeColor];
    cell.textLabel.text = [self dataArray][indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    return cell;
}

#pragma mark - delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"选择 %ld 行", (long)indexPath.row);
    switch (indexPath.row) {
        case 0: {
            AnimationsTableViewController *animVC = [AnimationsTableViewController loadFromNib];
            [self presentViewController:[[UINavigationController alloc] initWithRootViewController:animVC] animated:YES completion:^{
                //
            }];
        }
            break;
            
        default:
            break;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
