//
//  ImageScrollView.m
//  iOSAppFrame
//
//  Created by chyrain on 2017/7/1.
//  Copyright © 2017年 Chyrain. All rights reserved.
//

#import "ImageScrollView.h"
#import "UIImageView+WebCache.h"

//宏定义scrollview的宽高
#define view_WIDTH self.frame.size.width
#define view_HEIGHT self.frame.size.height
#define pageControl_HEIGHT 30

@interface ImageScrollView () <UIScrollViewDelegate>
@end

@implementation ImageScrollView {
    //滚动的时间间隔
    NSTimeInterval _delayTime;
    //定时器
    NSTimer *_timer;
    //存放UIImage对象的数组
    NSArray *_imageArray;
    //存放3个UIImageView的数组
    NSMutableArray *_imageViews;
}

#pragma mark - get & set

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.scrollView.frame) - pageControl_HEIGHT, self.frame.size.width, pageControl_HEIGHT)];
        _pageControl.numberOfPages = _imageArray.count;
        _pageControl.currentPage = 0;
        _pageControl.pageIndicatorTintColor = [UIColor colorWithRed:82.0/255.0 green:157.0/255.0 blue:219.0/255.0 alpha:1.0];
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    }
    return _pageControl;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
         _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _scrollView.contentSize = CGSizeMake(self.frame.size.width * 3, self.frame.size.height);
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
        //设置scrollview一开始的偏移量为一个宽度,因为里面有3个UIImageView,所以scrollview默认显示的就是(0,1,2)里面的第一个imageview
        _scrollView.contentOffset = CGPointMake(self.frame.size.width, 0);
        _scrollView.delegate = self;
    }
    return _scrollView;
}

#pragma mark - init & life

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.bounds = frame;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame imageArray:(NSArray *)imageArray {
    if (self = [self initWithFrame:frame]) {
        _delayTime = 5.0f;
        _imageArray = imageArray;
        [self creatUI];
        [self startTimer];
    }
    return self;
}

//控制器销毁的时候移除定时器
- (void)dealloc
{
    [self stopTimer];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    //更新frame（更改frame后view_WIDTH和view_HEIGHT变化）
    //NSLog(@"layoutSubviews frame: %@", NSStringFromCGRect(self.frame));//////
    self.scrollView.frame = self.bounds;
    self.pageControl.frame = CGRectMake(0, CGRectGetMaxY(self.scrollView.frame) - pageControl_HEIGHT, view_WIDTH, pageControl_HEIGHT);
    if (_imageViews) {
        for (NSInteger i = 0; i < _imageViews.count; i++) {
            UIImageView *iv = [_imageViews objectAtIndex:i];
            if (iv) {
                //变换frame拉伸头部效果
                iv.frame = CGRectMake(view_WIDTH * i, 0, view_WIDTH, view_HEIGHT);
            }
        }
    }
    //更新当前中心ImageView偏移值
    self.scrollView.contentOffset = CGPointMake(view_WIDTH, 0);
}

#pragma mark - 初始化scrollview/分页控件/imageview
- (void)creatUI
{
    //初始化scrollview
    [self addSubview:self.scrollView];
    
    //初始化imageview
    _imageViews = [NSMutableArray array];
    //创建三个imageView作为循环复用的载体，图片将循环加载在这三个imageView上面
    for (NSInteger i = 0; i < 3; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(view_WIDTH * i, 0, view_WIDTH, view_HEIGHT);
        //(self.dataArray.count - 1 + i)%self.dataArray.count也可以达到让一开始3个imageview分别显示最后一张<-->第一张<-->第二张图片,但是让大家理解起来会有一定难度,所以采用下面最简单的方法直接设置
        //imageView.tag = (self.dataArray.count - 1 + i)%self.dataArray.count;
        
        //3个imageview一开始需要的图片分别对应图片数组的图片索引应该是imageview[0].index-->images.count-1,imageview[1].index-->0,imageview[2].index-->1
        NSInteger index = 0;
        if (i == 0) index = _imageArray.count - 1;
        if (i == 1) index = 0;
        if (i == 2) index = 1;
        
        imageView.tag = index;
        imageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewClicked:)];
        [imageView addGestureRecognizer:tap];
        
        //设置imageView上的image图片
        [self setImageView:imageView atIndex:index];
        //将imageView加入数组中，方便随后取用
        [_imageViews addObject:imageView];
        [self.scrollView addSubview:imageView];
    }
    //初始化pageControl,最后添加,这样它会显示在最前面,不会被遮挡
    [self addSubview:self.pageControl];
}

// 图片轻敲手势事件
- (void)imageViewClicked:(UITapGestureRecognizer *)tap
{
    int index = (int)tap.view.tag;
    if (_clickBlcok) _clickBlcok(index);
}

// 给Image设置图片
- (void)setImageView:(UIImageView *)imageView atIndex:(NSInteger)index
{
    id item = _imageArray[index];
    if ([item isKindOfClass:[UIImage class]]) {
        //image图片
        imageView.image = item;
    } else if ([item isKindOfClass:[NSString class]]){
        //网络图片
        [imageView sd_setImageWithURL:[NSURL URLWithString:item] placeholderImage:[UIImage imageNamed:@"PlaceHolder"]];
    }
}


//定时器调用的方法
- (void)nextPage
{
    //NSLog(@"定时器的%f",_scrollView.contentOffset.x);
    //定时器方法都是相当于向左滑动,偏移量是增大的,原本偏移量是一倍的宽度,定时器方法执行一次,偏移量就要增大一个宽度,这样也就是setContentOffset:CGPointMake(VIEW_WIDTH * 2, 0),相当于设置偏移量是2倍宽度
    //执行了setContentOffset:方法,系统会自动调用scrollViewDidEndScrollingAnimation:方法,在这个方法里面再设置回偏移量等于一倍的宽度,同时更换各个imageview的图片,那么还是相当于中间的那个imageview显示在屏幕上
    [self.scrollView setContentOffset:CGPointMake(view_WIDTH * 2, 0) animated:YES];
}

#pragma mark - 更新图片和分页控件的当前页
- (void)updateImageViewsAndPageControl
{
    //先判断出scrollview的操作行为是向左向右还是不动
    //定义一个flag,目前是让scrollview向左向右滑动的时候索引对应的+1或者-1
    int flag = 0;
    if (self.scrollView.contentOffset.x > view_WIDTH)
    {//手指向左滑动
        flag = 1;
    }
    else if (self.scrollView.contentOffset.x == 0)//原本偏移量是一个宽度,现在==0了,那么就是手指向右滑动了
    {//手指向右滑动
        flag = -1;
    }
    else
    {//除了向左向右之外就是没有移动,那么不需要任何操作，直接返回
        return;
    }
    
    //    NSInteger index = 0;
    //修改imageViews中的imageView的tag值，从而修改imageView上显示的image，pageControl的页码
    for (UIImageView *imageView in _imageViews) {
        /*
         （1）当屏幕中间那个imageview显示最后一张图片时，右边的ImageView,也即下一张图片应该是显示最开始的那一张图片(第0张)；
         （2）当屏幕中间显示最开始的那一张图片(第0张)时，左边的ImageView,也即上一张图片应该是最后一张图片。
         */
        NSInteger index = imageView.tag + flag ;
        
        if (index < 0) {
            index = self.pageControl.numberOfPages - 1;
        } else if (index >= self.pageControl.numberOfPages) {
            index = 0;
        }
        
        imageView.tag = index;
        //更新每一页上的image
        [self setImageView:imageView atIndex:index];
    }
    //更新pageControl显示的页码,也就是中间那个imageview的tag值
    self.pageControl.currentPage = [_imageViews[1] tag];
    
    //使用无动画的效果快速切换,也就是把scrollview的偏移量还设置成一个imageview的宽度
    //这里是通过设置scrollview的偏移量让其来回滑动,时刻更换imageview的图片,每换一次,就立即让scrollview以无动画的方式再回到偏移量为一个imageview宽度的偏移量位置,即还是显示的中间那个imageview,以此给用户产生一种来回切换的错觉,实质一直是在显示中间那个imageview
    self.scrollView.contentOffset = CGPointMake(view_WIDTH, 0);
}

#pragma mark - Timer

//停止定时器
- (void)stopTimer {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}
//开启定时器
- (void)startTimer
{
    if (!_timer) {
        NSTimer *timer = [NSTimer timerWithTimeInterval:_delayTime target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
        //加入NSRunLoopCommonModes运行模式,这样可以让定时器无论是在默认还是拖拽模式下都可以正常运作
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        _timer = timer;
    }
}

#pragma mark - <UIScrollViewDelegate>

//用户开始拖拽,停止定时器
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self stopTimer];
}

//用户停止拖拽,开启定时器
- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self startTimer];
}

//人为拖拽停止并且减速完全停止时会调用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //在已经减速结束的时候进行图片更新，pagecontrol的更新
    [self updateImageViewsAndPageControl];
}

//在调用setContentOffset方法的时候，会触发此代理方法
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    //在调用setContentOffset方法的时候，会触发此代理方法（避免在定时器控制偏移量的时候不刷新UI）
    [self updateImageViewsAndPageControl];
    // NSLog(@"滚动后的%f",_scrollView.contentOffset.x);
}

@end
