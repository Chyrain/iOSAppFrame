//
//  RootTabBarController.m
//  iOSAppFrame
//
//  Created by chyrain on 2017/6/23.
//  Copyright © 2017年 Chyrain. All rights reserved.
//

#import "RootTabBarController.h"
#import "FindViewController.h"
#import "TabNavigationController.h"
#import "Macros.h"
#import "XLBubbleTransition.h"

@interface RootTabBarController ()<UITabBarControllerDelegate>

@property (nonatomic, strong) UIButton *centerBtn;
@end

@implementation RootTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate = self;
    [self initCutomBar];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:ImageWithName(@"tapbar_top_line")]; // tab_background
    
    // 设置tabbar背景颜色
    [[UITabBar appearance] setBackgroundColor:[UIColor whiteColor]]; // 设置tabbar背景颜色
    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];    // 设置tabbar背景颜色
    [[UITabBar appearance] setTintColor:[UIColor orangeColor]];   // 选中状态时候的字体颜色及背景UIColorFromRGB(0xe9a658)
    // 如果需要自定义图片就需要设置以下几行
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : UIColorFromRGB(0x252729)} forState:UIControlStateNormal]; // UITabBarItem未选中状态的颜色
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : UIColorFromRGB(0xe9a658)} forState:UIControlStateSelected]; // UITabBarItem选中状态的颜色
    
    // KVO tabbar hidden
    [self.tabBar addObserver:self forKeyPath:@"hidden" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    @try {
        [self.tabBar removeObserver:self forKeyPath:@"hidden" context:nil]; // remove Observer
    }
    @catch (NSException * __unused exception) {}
}

- (void)initCutomBar
{
    self.delegate = self;
    
#pragma mark: 首页storyboard: Tab0_Host
    UIStoryboard *hostSB = [UIStoryboard storyboardWithName:@"Tab0_Host" bundle:nil];
    TabNavigationController *hostNaviVC = [hostSB instantiateViewControllerWithIdentifier:@"hostNavigationC"];
    [self setChildViewController:hostNaviVC selectedImage:@"hostViewSelect.png" unSelectedImage:@"hostViewUnSelect.png" title:LocalStr(@"Host", @"首页")];
    hostNaviVC.tabBarItem.tag = 0;
    
#pragma mark: 关注storyboard: Tab1_Attention
    UIStoryboard *attentionSB = [UIStoryboard storyboardWithName:@"Tab1_Attention" bundle:nil];
    TabNavigationController *attentionNaviVC = [attentionSB instantiateViewControllerWithIdentifier:@"attentionNavigationC"];
    [self setChildViewController:attentionNaviVC selectedImage:@"attentionSelect.png" unSelectedImage:@"attentionUnSelect.png" title:LocalStr(@"Attention", @"关注")];
    attentionNaviVC.tabBarItem.tag = 1;
    
#pragma mark: 发现storyboard: Tab2_Find
    UIStoryboard *findSB = [UIStoryboard storyboardWithName:@"Tab2_Find" bundle:nil];
    TabNavigationController *findNaviVC = [findSB instantiateViewControllerWithIdentifier:@"findNavigationC"];
    [self setChildViewController:findNaviVC selectedImage:nil unSelectedImage:nil title:LocalStr(@"Find", @"发现")]; //LocalStr(@"Find", @"发现")
    findNaviVC.tabBarItem.tag = 2;
    findNaviVC.tabBarItem.enabled = NO;
    [self addCenterButton:ImageWithName(@"findSelect.png")
            selectedImage:ImageWithName(@"findUnSelect.png")];
//    [self addCenterButton:ImageWithName(@"Menu_icn.png")
//            selectedImage:ImageWithName(@"Close_icn.png")];
    
#pragma mark: 购物车storyboard: Tab3_GoodsCar
    UIStoryboard *goodsCarSB = [UIStoryboard storyboardWithName:@"Tab3_GoodsCar" bundle:nil];
    TabNavigationController *goodsCarNaviVC = [goodsCarSB instantiateViewControllerWithIdentifier:@"goodsCarNavigationC"];
    [self setChildViewController:goodsCarNaviVC selectedImage:@"goodsCarSelect.png" unSelectedImage:@"goodsCarUnSelect.png" title:LocalStr(@"GoodsCar", @"购物车")];
    goodsCarNaviVC.tabBarItem.tag = 3;
    
#pragma mark: 个人中心storyboard: Tab4_MineCenter
    UIStoryboard *mineCenterSB = [UIStoryboard storyboardWithName:@"Tab4_MineCenter" bundle:nil];
    TabNavigationController *mineCenterNaviVC = [mineCenterSB instantiateViewControllerWithIdentifier:@"mineCenterNavigationC"];
    [self setChildViewController:mineCenterNaviVC selectedImage:@"mineCenterSelect.png" unSelectedImage:@"mineCenterUnSelect.png" title:LocalStr(@"MineCenter", @"我")];
    mineCenterNaviVC.tabBarItem.tag = 4;
    
    self.viewControllers = @[hostNaviVC, attentionNaviVC, findNaviVC, goodsCarNaviVC, mineCenterNaviVC];
}


- (void)setChildViewController:(UIViewController *)viewController selectedImage:(NSString *)selectedImage unSelectedImage:(NSString *)unSelectedImage title:(NSString *)title {
    UIImage *mineCenterSelectImg = ImageWithName(selectedImage);
    UIImage *mineCenterUnSelectImg = ImageWithName(unSelectedImage);
    viewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:[self scaleImage:mineCenterUnSelectImg] selectedImage:[self scaleImage:mineCenterSelectImg]];
}

- (UIImage *)scaleImage:(UIImage *)image {
    return [UIImage imageWithCGImage:image.CGImage scale:1.8 orientation:image.imageOrientation];
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_9_0
- (NSUInteger)supportedInterfaceOrientations
#else
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
#endif
{
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - tabbar的代理方法，

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
//    CATransition *animation = [CATransition animation]; //创建CATransition对象
//    animation.duration = 0.35f;  //设置运动时间
////    animation.type = @"pageUnCurl"; //设置运动type
//    animation.type = kCATransitionFade;
//    animation.subtype = kCATransitionFromBottom; //设置子类
//    animation.timingFunction = UIViewAnimationOptionCurveEaseInOut; //设置运动速度
//    [self.view.layer addAnimation:animation forKey:@"animation"];
}

#pragma mark: 每次单击item的时候，如果需要切换则返回yes，否则no
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    return YES;
}

#pragma mark: 只要上面的shouldSelectViewController返回yes，下一步就执行该方法
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    _centerBtn.selected = (self.selectedIndex == 2) ? YES : NO;
    
}

#pragma mark: Create a custom UIButton
- (void)addCenterButton:(UIImage*)buttonImage selectedImage:(UIImage*)selectedImage {
    _centerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_centerBtn addTarget:self action:@selector(centerBtn:) forControlEvents:UIControlEventTouchUpInside];
    _centerBtn.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    
    _centerBtn.frame = CGRectMake(0, 0, 60, 60); //  设定button大小为适应图片
    [_centerBtn setImage:buttonImage forState:UIControlStateNormal];
    [_centerBtn setImage:selectedImage forState:UIControlStateSelected];
    //_centerBtn.layer.cornerRadius = 30.0f;
    //_centerBtn.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
    _centerBtn.adjustsImageWhenHighlighted = NO;
    CGPoint center = self.tabBar.center;
    center.y = center.y - buttonImage.size.height/4;
    _centerBtn.center = center;
    [self.view addSubview:_centerBtn];
}

- (void)centerBtn:(UIButton *)sender {
//    [self setSelectedIndex:2];
//    sender.selected = YES;
//    
//    //触发tabBar:didSelectItem:
//    if (self.tabBar.delegate) {
//        [self.tabBar.delegate tabBar:self.tabBar didSelectItem:self.tabBar.selectedItem];
//    }
    
    //present新页面
    UINavigationController *vc = (UINavigationController *)self.viewControllers[2];
    //在ViewControllerA中添加push和pop的动画
    vc.xl_pushTranstion = [XLBubbleTransition transitionWithAnchorRect:sender.frame];
    vc.xl_popTranstion = [XLBubbleTransition transitionWithAnchorRect:sender.frame];
    FindViewController *findVC = [[FindViewController alloc] init];
    [self presentViewController:findVC animated:true completion:nil];
}

#pragma mark -
// KVO tabbar hidden
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([object isEqual:self.tabBar] && [keyPath isEqualToString:@"hidden"]) {
        _centerBtn.hidden = self.tabBar.hidden; // synchronization view state
        
//        if ([object isFinished]) {
//            @try {
//                [object removeObserver:self forKeyPath:@"hidden" context:nil]; // remove Observer
//            }
//            @catch (NSException * __unused exception) {}
//        }
    }
}

@end
