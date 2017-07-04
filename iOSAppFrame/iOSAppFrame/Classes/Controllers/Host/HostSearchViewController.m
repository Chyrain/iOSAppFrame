//
//  HostSearchViewController.m
//  iOSAppFrame
//
//  Created by chyrain on 2017/7/4.
//  Copyright © 2017年 Chyrain. All rights reserved.
//

#import "HostSearchViewController.h"
#import "UITools.h"
#import "HostSearchWordsTableViewCell.h"

#define view_WIDTH self.view.frame.size.width
#define view_HEIGHT self.view.frame.size.height
// MARK: 定义线条的粗细和角度
#define LineColor ([UIColor colorWithRed:221.0f/255.0 green:222.0f/255.0 blue:223.0f/255.0 alpha:1.0])
#define LineWidth .41f
#define LineCorner 4.0f
#define LineBorder 1.f
#define TextColor RGBACOLOR(93, 95, 106, 1.0)

#define ViewBGColor RGBACOLOR(255, 255, 255, .9)

static NSString *collectCellId = @"collectionViewCellId";
static NSString *collectHeadCellId = @"collectionHeadViewCellId";
static NSString *searchListCacheKey = @"SixHostSearchListArray";

@interface HostSearchViewController () <UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource>{
    NSString *_viewControllerName;
    UILabel *hotSearchLab; //热搜
    
    NSMutableArray *hotSearchdataSourceArray;
    NSMutableArray *historyDataSourceArray;
    
    CGFloat historyCellHeight; //搜索历史cell高度
    
    BOOL isSecondIn;
    
    CGFloat dataSourceNum;
}
@property (strong, nonatomic) UIView *hotWordView;
@end

@implementation HostSearchViewController

#pragma mark - init & life

- (instancetype)initWithViewControllerName:(NSString *)viewControllerName {
    self = [super init];
    if (self) {
        _viewControllerName = viewControllerName;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = ViewBGColor;
    // 热词获取
    hotSearchdataSourceArray = [[NSMutableArray alloc] initWithObjects:@"YJV", @"电热管", @"吸顶灯", @"感应开关", @"吸顶灯", @"热缩中间接头", @"套管", @"橡套电缆",
                                @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", nil];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, view_WIDTH, LineWidth)];
    lineView.backgroundColor = LineColor;
    [self.view addSubview:lineView];
    
    historyCellHeight = 37.f*ScreenScaleX;
    
    isSecondIn = YES;
    [self.view addSubview:self.historyWordTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = ViewBGColor;
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationController.navigationBar.translucent = YES;
    [UIView animateWithDuration:0.35 animations:^{
        [self.navigationController.navigationBar setValue:@(0.8) forKeyPath:@"backgroundView.alpha"];
    }];
    //[self.navigationController.navigationBar setValue:@(1.0) forKeyPath:@"backgroundView.alpha"];
    
    if(![[NSUserDefaults standardUserDefaults] objectForKey:searchListCacheKey]) {
        historyDataSourceArray = [[NSMutableArray alloc] init];
    } else {
        historyDataSourceArray = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:searchListCacheKey]];
    }
    
    if (historyDataSourceArray.count == 0) {
        dataSourceNum = 1;
    } else {
        dataSourceNum = 2;
    }
    
    if (isSecondIn) {
        [self.historyWordTableView reloadData];
    }
    [self.view layoutIfNeeded];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onFirstLayoutSubviews {
    NSLog(@"[onFirstLayoutSubviews]");
    self.historyWordTableView.frame = CGRectMake(0, 0, view_WIDTH, view_HEIGHT - 64 - 49);
}

#pragma mark - get & set

- (UITableView *)historyWordTableView
{
    if (!_historyWordTableView) {
        _historyWordTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, view_WIDTH, view_HEIGHT - 64) style:UITableViewStylePlain]; // CGRectGetMaxY(self.searchBar.frame)
        _historyWordTableView.delegate = self;
        _historyWordTableView.dataSource = self;
        _historyWordTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine; //分割线
        _historyWordTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _historyWordTableView.showsVerticalScrollIndicator = NO;
        _historyWordTableView.showsHorizontalScrollIndicator = NO;
        _historyWordTableView.backgroundColor = ViewBGColor;
    }
    return _historyWordTableView;
}

- (UICollectionView *)hotWordCollectionView {
    if (!_hotWordCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal]; // 水平滑动
        // flowLayout.minimumInteritemSpacing = 0.f; //如果水平滑动，就是垂直间距
        flowLayout.minimumLineSpacing = 0.f; //如果是水平滑动，就是水平间距
        //sectionHeader的大小,如果是竖向滚动，只需设置Y值。如果是横向，只需设置X值。
        flowLayout.headerReferenceSize = CGSizeMake(50*ScreenScaleX,0);
        
        _hotWordCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, view_WIDTH, 50*ScreenScaleX) collectionViewLayout:flowLayout];
        _hotWordCollectionView.showsHorizontalScrollIndicator = NO;
        _hotWordCollectionView.delegate = self;
        _hotWordCollectionView.dataSource = self;
        
        //_hotWordCollectionView.backgroundColor = [UIColor whiteColor];
        _hotWordCollectionView.backgroundColor = ViewBGColor;
        
        //注册cell
        [_hotWordCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:collectCellId];
        //注册header
        [_hotWordCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:collectHeadCellId];
    }
    return _hotWordCollectionView;
}

#pragma mark - UICollectionViewDataSource 热搜collectionview

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return hotSearchdataSourceArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectCellId forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];//ViewBGColor;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.userInteractionEnabled = NO;
    if (cell.isSelected) {
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.backgroundColor = TEXT_HIGHLIGHT_COLOR;
    } else {
        [button setTitleColor:TextColor forState:UIControlStateNormal];
        button.backgroundColor = [UITools colorWithHexString:@"#e5e5e5" alpha:1.0];
    }
    //[button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    //[button setBackgroundImage:[UITools imageWithColor:TEXT_HIGHLIGHT_COLOR] forState:UIControlStateHighlighted];
    button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    button.layer.cornerRadius = 2.f;
    button.layer.masksToBounds = YES;
    
    NSString *hotWordsData = hotSearchdataSourceArray[indexPath.item];
    
    CGSize adSize = [UITools adjustWithFont:[UIFont systemFontOfSize:13] WithText:hotWordsData WithSize:CGSizeMake(MAXFLOAT, 36)];
    CGSize adjustSize = CGSizeMake(adSize.width + 20*ScreenScaleX, 36);
    button.frame = CGRectMake(2, 10/2.f, adjustSize.width - 4, adjustSize.height - 10);//上下各5边距
    [button setTitle:hotWordsData forState:UIControlStateNormal];
    
    //移除UICollectionViewCell其他View
    for (id subView in cell.contentView.subviews) {
        [subView removeFromSuperview];
    }
    
    [cell.contentView addSubview:button];
    return cell;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    //kind有两种 一种时header 一种事footer
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView * header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:collectHeadCellId forIndexPath:indexPath];
        header.backgroundColor = [UIColor clearColor];
        if (!hotSearchLab) {
            hotSearchLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50*ScreenScaleX, header.bounds.size.height)];
            hotSearchLab.backgroundColor = [UIColor clearColor];//ViewBGColor;
            hotSearchLab.textColor = [UIColor darkTextColor];
            hotSearchLab.font = [UIFont systemFontOfSize:12];
            hotSearchLab.text = @"热搜  ";
            hotSearchLab.textAlignment = NSTextAlignmentCenter;
            [header addSubview:hotSearchLab];
        }
        return header;
    }
    return nil;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell* cell = [collectionView cellForItemAtIndexPath:indexPath];
    //set color with animation
    [UIView animateWithDuration:0.1
                          delay:0
                        options:(UIViewAnimationOptionAllowUserInteraction)
                     animations:^{
                         for (NSObject *obj in cell.contentView.subviews) {
                             if ([obj isMemberOfClass:[UIButton class]]) {
                                 UIButton *button = (UIButton *)obj;
                                 [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                                 button.backgroundColor = TEXT_HIGHLIGHT_COLOR;
                             }
                         }
                     }
                     completion:nil];
}

- (void)collectionView:(UICollectionView *)collectionView  didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell* cell = [collectionView cellForItemAtIndexPath:indexPath];
    //set color with animation
    [UIView animateWithDuration:0.1
                          delay:0
                        options:(UIViewAnimationOptionAllowUserInteraction)
                     animations:^{
                         for (NSObject *obj in cell.contentView.subviews) {
                             if ([obj isMemberOfClass:[UIButton class]]) {
                                 UIButton *button = (UIButton *)obj;
                                 [button setTitleColor:TextColor forState:UIControlStateNormal];
                                 button.backgroundColor = [UITools colorWithHexString:@"#e5e5e5" alpha:1.0];
                                 //[button setBackgroundImage:[UITools imageWithColor:[UITools colorWithHexString:@"#e5e5e5" alpha:1.0]] forState:UIControlStateNormal];
                             }
                         }
                     }
                     completion:nil ];
}

/**
 *  选中collectionView的某行cell
 */
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *hotWordsData = hotSearchdataSourceArray[indexPath.item];
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    for (NSObject *obj in cell.contentView.subviews) {
        if ([obj isMemberOfClass:[UIButton class]]) {
//            UIButton *button = (UIButton *)obj;
//            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            button.backgroundColor = TEXT_HIGHLIGHT_COLOR;
            //[button setBackgroundImage:[UITools imageWithColor:TEXT_HIGHLIGHT_COLOR] forState:UIControlStateNormal];
            //[button setTitleColor:TEXT_HIGHLIGHT_COLOR forState:UIControlStateNormal];
            
            //缓存最近搜索词
            if(historyDataSourceArray) {
                NSString *title = [NSString stringWithFormat:@"%@", hotWordsData];
                [historyDataSourceArray addObject:title];
                
                NSOrderedSet *orderSet = [NSOrderedSet orderedSetWithArray:historyDataSourceArray];
                [[NSUserDefaults standardUserDefaults] setObject:orderSet.array forKey:@"SixHostSearchListArray"];
                
                if ([self.delegate respondsToSelector:@selector(hotWordSearchSelect:)]) {
                    [self.delegate hotWordSearchSelect:title];
                }
            }
        }
    }
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

///**
// * 取消选中
// */
//- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSLog(@"didDeselectItemAtIndexPath: %ld", (long)indexPath.row);
//    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
//    for (NSObject *obj in cell.contentView.subviews) {
//        if ([obj isMemberOfClass:[UIButton class]]) {
//            UIButton *button = (UIButton *)obj;
//            [button setTitleColor:TextColor forState:UIControlStateNormal];
//            button.backgroundColor = [UITools colorWithHexString:@"#e5e5e5" alpha:1.0];
//            //[button setBackgroundImage:[UITools imageWithColor:[UITools colorWithHexString:@"#e5e5e5" alpha:1.0]] forState:UIControlStateNormal];
//        }
//    }
//}

/**
 *  item之间的间距
 */
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5.0f;
}

#pragma mark - UICollectionViewDelegateFlowLayout
// 定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //建议：可缓存计算好的size
    NSString *hotWordsData = hotSearchdataSourceArray[indexPath.item];
    CGSize adSize = [UITools adjustWithFont:[UIFont systemFontOfSize:13] WithText:hotWordsData WithSize:CGSizeMake(MAXFLOAT, 36)];
    
    CGSize adjustSize = CGSizeMake(adSize.width + 20*ScreenScaleX, 36);
    //NSLog(@"adjustSize %f", adjustSize.width);
    
    return adjustSize;
}


#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return dataSourceNum;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return 30*ScreenScaleX;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return nil;
    } else {
        UIView *viewBackGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, view_WIDTH, 30*ScreenScaleX)];
        viewBackGroundView.backgroundColor = ViewBGColor;
        
        UILabel *headLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, view_WIDTH, 30*ScreenScaleX - 1)];
        headLab.backgroundColor = ViewBGColor;
        headLab.font = [UIFont systemFontOfSize:12];;
        headLab.textColor = [UIColor darkTextColor];
        headLab.text = @"历史搜索";
        UIView *viewLine = [[UIView alloc] initWithFrame:CGRectMake(0, headLab.frame.size.height, view_WIDTH, LineWidth)];
        
        viewLine.backgroundColor = LineColor;
        [viewBackGroundView addSubview:headLab];
        [viewBackGroundView addSubview:viewLine];
        
        return viewBackGroundView;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return nil;
    } else {
        UIView *backGrView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, view_WIDTH, 50*ScreenScaleX)];
//        backGrView.backgroundColor = [UIColor whiteColor];
        backGrView.backgroundColor = ViewBGColor;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"清空历史记录" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        [button setTitleColor:TextColor forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [button setBackgroundImage:[UITools imageWithColor:TEXT_HIGHLIGHT_COLOR] forState:UIControlStateHighlighted];
        [button setBackgroundImage:[UITools imageWithColor:RGBCOLOR(233, 233, 233)] forState:UIControlStateNormal];
        button.frame = CGRectMake(30, (backGrView.bounds.size.height - 33)/2.f, view_WIDTH - 60, 40);
        //button.layer.borderColor = [UIColor grayColor].CGColor;
        //button.layer.borderWidth = LineWidth;
        button.layer.cornerRadius = 2.f;
        button.layer.masksToBounds = YES;
        [button addTarget:self action:@selector(clearHistorySearchBtnAction) forControlEvents:UIControlEventTouchUpInside];
        
        [button.imageView setContentMode:UIViewContentModeScaleAspectFit];
        [button setImage:ImageWithName(@"delete.png") forState:UIControlStateNormal];
        [button setImage:ImageWithName(@"delete_select.png") forState:UIControlStateHighlighted];
        [button setImageEdgeInsets:UIEdgeInsetsMake((40 - 16)/2.f, 0, (40 - 16)/2.f, 5)]; // top left bottom right
        [button setTitleEdgeInsets:UIEdgeInsetsMake(10, -(button.imageView.frame.size.width - button.imageView.frame.size.height)/2 + 5, 10, 0)]; //4个参数是上边界，左边界，下边界，右边界。
        
        [backGrView addSubview:button];
        return backGrView;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 10;
    } else {
        return 55*ScreenScaleX;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return historyDataSourceArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 50*ScreenScaleX;
    }
    return historyCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *reuseIdentifier = @"historySearchID";
    HostSearchWordsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[HostSearchWordsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        //cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        cell.backgroundColor = ViewBGColor;
    }
    
    while ([[cell.contentView subviews] lastObject])
    {
        [[[cell.contentView subviews] lastObject] removeFromSuperview];
    }
    
    if (indexPath.section == 0) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.contentView addSubview:self.hotWordCollectionView];
        [self.hotWordCollectionView reloadData];
    } else {
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, view_WIDTH, historyCellHeight - 1)];
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = TextColor;
        label.text = historyDataSourceArray[historyDataSourceArray.count - indexPath.row - 1];
        [cell.contentView addSubview:label];
//        UIView *viewLine = [[UIView alloc] initWithFrame:CGRectMake(0, label.frame.size.height, view_WIDTH, 0.5)];
//        viewLine.backgroundColor = LineColor;
//        [cell.contentView addSubview:viewLine];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(hotWordSearchSelect:)]) {
        [self.delegate hotWordSearchSelect:historyDataSourceArray[historyDataSourceArray.count - indexPath.row - 1]];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCellEditingStyle )tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0)  {
        return UITableViewCellEditingStyleNone; // 热搜行不可以删除
    }
    return UITableViewCellEditingStyleDelete;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (historyDataSourceArray.count == 1) {
            [self clearHistorySearchBtnAction];
        } else {
            [historyDataSourceArray removeObjectAtIndex:indexPath.row];
            [[NSUserDefaults standardUserDefaults] setObject:historyDataSourceArray forKey:@"SixHostSearchListArray"];
            [tableView reloadData]; // 重新加载数据的时候记得修改TableView的高度
        }
    }
}

- (void)clearHistorySearchBtnAction
{
    if(historyDataSourceArray) {
        NSArray *array = [[NSArray alloc] init];
        [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"SixHostSearchListArray"];
        [historyDataSourceArray removeAllObjects];
    }
    
    if (historyDataSourceArray.count == 0) {
        dataSourceNum = 1;
    } else {
        dataSourceNum = 2;
    }
    [self.historyWordTableView reloadData];
}

@end
