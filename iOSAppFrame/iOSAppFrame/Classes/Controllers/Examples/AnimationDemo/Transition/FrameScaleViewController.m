//
//  FrameScaleViewController.m
//  iOSAppFrame
//
//  Created by chyrain on 2017/7/10.
//  Copyright © 2017年 Chyrain. All rights reserved.
//

#import "FrameScaleViewController.h"
#import "UITools.h"
#import "UIGestureRecognizer+Block.h"
#import "HYImageBrowser.h"

@interface FrameScaleViewController ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *folderImageView;
/** 动画元素 */
@property(nonatomic, strong) UIImageView *animationImageView;
/** 是否是打开预览动画 */
@property(nonatomic, assign)BOOL isOpenOverView;

@end

// 放大倍数
const CGFloat magnificateMultiple = 3.;

@implementation FrameScaleViewController

#pragma mark - get & set

- (UIImageView *)folderImageView {
    if (!_folderImageView) {
        UIImage *image = ImageWithName(@"folder");
        _folderImageView = [[UIImageView alloc] initWithImage:image];
        _folderImageView.frame = CGRectMake((self_VIEW_FRM_WIDTH - image.size.width)/2,
                                            100,//(self_VIEW_FRM_HEIGHT - image.size.height)/2,
                                            image.size.width,
                                            image.size.height);
        _folderImageView.userInteractionEnabled = YES;
        [_folderImageView addGestureRecognizer:[UITapGestureRecognizer nvm_gestureRecognizerWithActionBlock:^(id UIGestureRecognizer) {
            [self startAnimation];
            //[HYImageBrowser showImage:_folderImageView];
        }]];
    }
    return _folderImageView;
}

- (UIImageView *)animationImageView {
    if (!_animationImageView) {
        _animationImageView = [UIImageView new];
        _animationImageView.userInteractionEnabled = YES;
        [_animationImageView addGestureRecognizer:[UITapGestureRecognizer nvm_gestureRecognizerWithActionBlock:^(id UIGestureRecognizer) {
            [self stopAnimation];
        }]];
        
    }
    return _animationImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((self_VIEW_FRM_WIDTH - 50)/2, self_VIEW_FRM_HEIGHT - 150, 60, 36)];
        _titleLabel.text = @"Title";
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.userInteractionEnabled = YES;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [_titleLabel addGestureRecognizer:[UITapGestureRecognizer nvm_gestureRecognizerWithActionBlock:^(id UIGestureRecognizer) {
            [HYImageBrowser showImage:_titleLabel];
        }]];
    }
    return _titleLabel;
}


#pragma mark - life

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Frame scale";
    
    self.isOpenOverView = YES;
    [self.view addSubview:self.folderImageView];
    [self.view addSubview:self.titleLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onFirstLayoutSubviews {
    self.titleLabel.frame = CGRectMake((self_VIEW_FRM_WIDTH - 50)/2, self_VIEW_FRM_HEIGHT - 150, 60, 36);
    self.folderImageView.frame = CGRectMake((self_VIEW_FRM_WIDTH - self.folderImageView.image.size.width)/2,
                                            100,//(self_VIEW_FRM_HEIGHT - image.size.height)/2,
                                            self.folderImageView.image.size.width,
                                            self.folderImageView.image.size.height);
}

#pragma mark -

- (void)startAnimation {
    // 先将文件夹那个视图进行截图
    UIImage *animationImage = [UITools snapImageForView:self.folderImageView];
    
    // 再将文件夹视图的坐标系迁移到窗口坐标系（绝对坐标系）
    CGRect targetFrame_start = [self.folderImageView.superview convertRect:self.folderImageView.frame toView:nil];
    
    // 计算动画终点位置
    CGFloat targetW = targetFrame_start.size.width * magnificateMultiple;
    CGFloat targetH = targetFrame_start.size.height * magnificateMultiple;
    CGFloat targetX = (self_VIEW_FRM_WIDTH - targetW) / 2.0;
    CGFloat targetY = (self_VIEW_FRM_HEIGHT - targetH) / 2.0;
    CGRect targetFrame_end = CGRectMake(targetX, targetY, targetW, targetH);
    
    // 添加做动画的元素
    if (!self.animationImageView.superview) {
        self.animationImageView.image = animationImage;
        self.animationImageView.frame = targetFrame_start;
        [self.view.window addSubview:self.animationImageView];
    }
    // 预览动画
    [UIView animateWithDuration:.35 delay:0. options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.animationImageView.frame = targetFrame_end;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)stopAnimation {
    // 再将文件夹视图的坐标系迁移到窗口坐标系（绝对坐标系）
    CGRect targetFrame_start = [self.folderImageView.superview convertRect:self.folderImageView.frame toView:nil];
    // 关闭预览动画
    [UIView animateWithDuration:.35 delay:0. options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.animationImageView.frame = targetFrame_start;
    } completion:^(BOOL finished) {
        [self.animationImageView removeFromSuperview];
    }];
}

//
//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//
//    // 先将文件夹那个视图进行截图
//    UIImage *animationImage = [UITools snapImageForView:self.folderImageView];
//    
//    // 再将文件夹视图的坐标系迁移到窗口坐标系（绝对坐标系）
//    CGRect targetFrame_start = [self.folderImageView.superview convertRect:self.folderImageView.frame toView:nil];
//    
//    // 计算动画终点位置
//    CGFloat targetW = targetFrame_start.size.width * magnificateMultiple;
//    CGFloat targetH = targetFrame_start.size.height * magnificateMultiple;
//    CGFloat targetX = (self_VIEW_FRM_WIDTH - targetW) / 2.0;
//    CGFloat targetY = (self_VIEW_FRM_HEIGHT - targetH) / 2.0;
//    CGRect targetFrame_end = CGRectMake(targetX, targetY, targetW, targetH);
//    
//    // 添加做动画的元素
//    if (!self.animationImageView.superview) {
//        self.animationImageView.image = animationImage;
//        self.animationImageView.frame = targetFrame_start;
//        [self.view.window addSubview:self.animationImageView];
//    }
//    
//    if (self.isOpenOverView) {
//        // 预览动画
//        [UIView animateWithDuration:.5 delay:0. options:UIViewAnimationOptionCurveEaseIn animations:^{
//            self.animationImageView.frame = targetFrame_end;
//        } completion:^(BOOL finished) {
//            
//        }];
//    } else{
//        // 关闭预览动画
//        [UIView animateWithDuration:.5 delay:0. options:UIViewAnimationOptionCurveEaseOut animations:^{
//            self.animationImageView.frame = targetFrame_start;
//        } completion:^(BOOL finished) {
//            [self.animationImageView removeFromSuperview];
//        }];
//    }
//    
//    self.isOpenOverView = !self.isOpenOverView;
//}

@end
