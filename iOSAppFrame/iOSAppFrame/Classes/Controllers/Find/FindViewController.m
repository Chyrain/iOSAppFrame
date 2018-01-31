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
@property (strong, nonatomic) UILabel *label;
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
    self.label = [[UILabel alloc] init];
    self.label.textColor = [UIColor whiteColor];
    self.label.text = @"Hello!";
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.font = [UIFont fontWithName:@"AmericanTypewriter" size:40];
    self.label.textColor = [UIColor whiteColor];
    [self.view addSubview:self.label];
    [self setupConstraintsOfLabel:self.label];
    
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
    
    
    //翻转动画
    [self cubeTransitionLabel:self.label text:@"World" direction:AnimationDirectionPositive];
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

/**
 * UILabel立体上下旋转切换动画 x
 */
- (void)cubeTransitionLabel:(UILabel *)label text:(NSString *)text direction:(AnimationDirection)direction {
    // 1. 备用label和展示的label具有同样的基本属性，只是text不一样
    UILabel *auxLabel = [[UILabel alloc] initWithFrame:label.frame];
    auxLabel.text = text;
    auxLabel.font = label.font;
    auxLabel.textAlignment = label.textAlignment;
    auxLabel.textColor = label.textColor;
    auxLabel.backgroundColor = label.backgroundColor;
    
    NSInteger flag = direction == AnimationDirectionPositive ? 1 : -1;
    // 2. 为什么将auxLabel的偏移量设置为label高度的一半？ 因为下面又进行了MakeScale操作，而MakeScale操作是以label的中心线为基准的，所以执行之后，auxLabelOffset的位置看上去就是在label的正上方。
    CGFloat auxLabelOffset = flag * label.frame.size.height * 0.5;
    auxLabel.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(1.0, 0.1), CGAffineTransformMakeTranslation(0.0, auxLabelOffset));
    
    // 3. 添加auxLabel
    [self.view addSubview:auxLabel];
    
    [UIView animateWithDuration:3.0 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        // 4. 动画执行过程中,auxLabel整体慢慢显示出来
        auxLabel.transform = CGAffineTransformIdentity;
        // 5. 动画执行过程中,label被慢慢“压倒”底部或者顶部
        label.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(1.0, 0.1), CGAffineTransformMakeTranslation(0.0, -auxLabelOffset));
    } completion:^(BOOL finished) {
        // 6. 动画执行完毕，label的值被赋值为auxLabel的值；label还原回来，并且将临时的auxLabel移除掉
        label.text = auxLabel.text;
        label.transform = CGAffineTransformIdentity;
        [auxLabel removeFromSuperview];
    }];
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
