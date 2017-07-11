//
//  HostHeaderCollectionReusableView.m
//  iOSAppFrame
//
//  Created by chyrain on 2017/7/1.
//  Copyright © 2017年 Chyrain. All rights reserved.
//

#import "HostHeaderCollectionReusableView.h"
#import "HostHeaderCollectionViewCell.h"
#import "ImageScrollView.h"
//#import "HYCollectionCarouselView.h"

//宏定义scrollview的宽高
#define view_WIDTH self.bounds.size.width
#define view_HEIGHT self.bounds.size.height
#define collection_Cell_Height 70 //(view_WIDTH / 4)
#define collection_Cell_Image_WH 40

static NSString *hostHeaderCellId = @"hostHeaderCollectionViewCell";

@interface HostHeaderCollectionReusableView()<UICollectionViewDelegate, UICollectionViewDataSource> {
    UICollectionView *_collectionView;
    ImageScrollView *_loopView;
    
    CGFloat initialH;
    CGFloat initialW;
}

@property (nonatomic, strong) NSMutableArray *buttonIconMutableArray;

@end
@implementation HostHeaderCollectionReusableView


#pragma mark - get & set

- (NSArray *)imageArray {
//    NSArray *imageArray = @[ImageWithName(@"pic.png"),
//                            ImageWithName(@"lunbo2.png"),
//                            ImageWithName(@"lunbo3.png"),
//                            ImageWithName(@"pic.png"),
//                            ImageWithName(@"lunbo2.png")];
    NSArray *imageArray = @[@"http://img4.duitang.com/uploads/item/201204/11/20120411162656_eJJiZ.jpeg",
                            @"http://img.ycwb.com/news/attachement/jpg/site2/20110226/90fba60155890ed3082500.jpg",
                            @"http://imgsrc.baidu.com/forum/pic/item/b03533fa828ba61e78ab1c894134970a314e59cb.jpg",
                            @"http://pic27.nipic.com/20130227/7224820_020411089000_2.jpg"];
    return imageArray;
}

- (NSMutableArray *)buttonIconMutableArray {
    if (!_buttonIconMutableArray) {
        _buttonIconMutableArray = [[NSMutableArray alloc] init];
        for (int i = 1; i < 7; i ++) { // 横向滑动菜单按钮图片名字
            NSString *name = [NSString stringWithFormat:@"hostModel%d",i];
            [_buttonIconMutableArray addObject:name];
        }
    }
    return _buttonIconMutableArray;
}

#pragma mark - init & life

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        initialH = view_HEIGHT;
        initialW = view_WIDTH;
        
        // 添加图片轮播器
        CGFloat loopViewH = HOST_COLLECTION_HERDER_H - collection_Cell_Height * 2;
        _loopView = [[ImageScrollView alloc] initWithFrame:CGRectMake(0, 0, view_WIDTH, loopViewH)
                                                imageArray:[self imageArray]];
        __weak typeof(self) weakSelf = self;
        _loopView.clickBlcok = ^(NSInteger index) {
            if ([weakSelf.delegate respondsToSelector:@selector(hostHeaderScrollViewEventDidSelectIndex:)]) {
                [weakSelf.delegate hostHeaderScrollViewEventDidSelectIndex:index];
            }
        };
        [self addSubview:_loopView];
        
        CGFloat collectionViewY = loopViewH;            // 添加横向滑动的UICollectionView
        CGFloat collectionViewH = view_WIDTH/2;
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat itemW = view_WIDTH / 5;
        CGFloat itemH = collection_Cell_Height;//collectionViewH / 2;
        flowLayout.itemSize = CGSizeMake(itemW, itemH);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal; // 设置滚动方向
        flowLayout.collectionView.pagingEnabled = YES;    // 设置分页
        flowLayout.minimumLineSpacing = 0;                // 设置最小行间距
        flowLayout.minimumInteritemSpacing = 0;           // 设置最小item间距
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, collectionViewY, view_WIDTH, collectionViewH) collectionViewLayout:flowLayout];
        [_collectionView registerClass:[HostHeaderCollectionViewCell class] forCellWithReuseIdentifier:hostHeaderCellId];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.pagingEnabled = YES;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_collectionView];
        
//        self.backgroundColor = [UIColor yellowColor];//////
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    //更新frame
    //NSLog(@"layoutSubviews frame: %@", NSStringFromCGRect(self.frame));//////
    CGFloat loopViewH = view_HEIGHT - collection_Cell_Height * 2;
    CGFloat collectionViewY = loopViewH;
    CGFloat collectionViewH = collection_Cell_Height * 2;
    _loopView.frame = CGRectMake(0, 0, view_WIDTH, loopViewH);
    
    CGFloat deltaY = view_HEIGHT - initialH;
    _collectionView.frame = CGRectMake(0 + deltaY/2, collectionViewY, initialW, collectionViewH);
    
    if (deltaY > 0) {
        [_loopView stopTimer];
    } else {
        [_loopView startTimer];
    }
}

#pragma mark UICollectionViewDataSource 数据源方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 30;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HostHeaderCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:hostHeaderCellId forIndexPath:indexPath];
    cell.imageName = self.buttonIconMutableArray[indexPath.item % (self.buttonIconMutableArray.count - 1)];
    switch (indexPath.item % 8) {
        case 0:
            cell.title = @"在线客服";
            break;
        case 1:
            cell.title = @"场合选择";
            break;
        case 2:
            cell.title = @"家装线专卖";
            break;
        case 3:
            cell.title = @"快速查询";
            break;
        case 4:
            cell.title = @"热门分类";
            break;
        case 5:
            cell.title = @"热门型号";
            break;
        case 6:
            cell.title = @"电缆选购";
            break;
        case 7:
            cell.title = @"电话服务";
            break;
        default:
            break;
    }
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(hostHeaderCollectionEventDidSelectIndex:)]) {
        [self.delegate hostHeaderCollectionEventDidSelectIndex:indexPath.item];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    //NSLog(@"Header collectionView didHighlightItemAtIndexPath section:%ld row:%ld", (long)indexPath.section, (long)indexPath.row);
    UICollectionViewCell* cell = [collectionView cellForItemAtIndexPath:indexPath];
    //set color with animation
    [UIView animateWithDuration:0.1
                          delay:0
                        options:(UIViewAnimationOptionAllowUserInteraction)
                     animations:^{
                         [cell setBackgroundColor:[UIColor colorWithRed:242/255.0f green:242/255.0f blue:242/255.0f alpha:1]];
                     }
                     completion:nil];
}

- (void)collectionView:(UICollectionView *)collectionView  didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    //NSLog(@"Header collectionView didUnhighlightItemAtIndexPath section:%ld row:%ld", (long)indexPath.section, (long)indexPath.row);
    UICollectionViewCell* cell = [collectionView cellForItemAtIndexPath:indexPath];
    //set color with animation
    [UIView animateWithDuration:0.1
                          delay:0
                        options:(UIViewAnimationOptionAllowUserInteraction)
                     animations:^{
                         [cell setBackgroundColor:[UIColor clearColor]];
                     }
                     completion:nil ];
}

@end
