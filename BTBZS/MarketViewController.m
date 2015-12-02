//
//  MarketViewController.m
//  BTBZS
//
//  Created by wcyfl on 15/11/18.
//  Copyright © 2015年 btbzs. All rights reserved.
//

#import "MarketViewController.h"
#import "MarketTableViewCell.h"
#import "UIImageView+ScrollViewIndicator.h"
#import "MarketDataService.h"
#import "Constants.h"
#import "MJRefresh.h"

#define MarketScrollViewTag 1000      // scrollView的tag

@interface MarketViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedController;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UITableView* currentTableView;
@end

@implementation MarketViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    __unused CGFloat w = self.view.frame.size.width;
    __unused CGFloat h = self.view.frame.size.height;
    
    // [Step 1] 初始化scrollView
    CGRect frame = _scrollView.frame;
    for (NSInteger i = 0; i < kMarketPageIndex_MaxCnt; i++) {
        UITableView* tableView = [[UITableView alloc] initWithFrame:CGRectMake(i*w, 0, frame.size.width, frame.size.height)];
        tableView.delegate      = self;
        tableView.dataSource    = self;
        tableView.tag           = i;
        tableView.showsHorizontalScrollIndicator    = NO;
        tableView.showsVerticalScrollIndicator      = NO;
        // 添加长按手势
        UILongPressGestureRecognizer* longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognized:)];
        [tableView addGestureRecognizer:longPress];
        // 接入第三方下拉刷新组件
        tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self
                                                               refreshingAction:@selector(refreshTableView)];
        
        // 注册cell
        UINib* nib = [UINib nibWithNibName:[MarketTableViewCell reusedIdentifier] bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:[MarketTableViewCell reusedIdentifier]];
        tableView.rowHeight = [MarketTableViewCell rowHeight];
        [_scrollView addSubview:tableView];
        
        if (0 == i) {
            _currentTableView = tableView;
        }
    }
    
    _scrollView.tag = MarketScrollViewTag;
    _scrollView.contentSize = CGSizeMake(kMarketPageIndex_MaxCnt * w, 0);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = YES;
    
    // [Step 2] 初始化segment
    _segmentedController.selectedSegmentIndex = kMarketPageIndex_FavoritesMarkets;
    
    // finally
    [self changeToCurrentTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Delegate/Datasource methods
/*
 * Override
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // 市场页面section数量永远为1
    return 1;
}

/*
 * Override
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [MarketDataService CountOfMarket:(MarketPageIndexEnum)tableView.tag];
}

/*
 * Override
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MarketTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:[MarketTableViewCell reusedIdentifier]
                                                                forIndexPath:indexPath];
    
    [MarketDataService initCellValue:cell withPageIndex:(MarketPageIndexEnum)tableView.tag withCellIndex:indexPath.row];
    
    return cell;
}

/*
 * SegmentedController切换时（因用户点击而发生切换）
 * 如果只是点击，没有发生切换，本函数不会被调用
 */
- (IBAction)onSegmentValueChanged:(UISegmentedControl *)sender {
    MarketPageIndexEnum pageIndex = (int)sender.selectedSegmentIndex;
    
    // 滑动ScrollView
    CGFloat x = pageIndex * _scrollView.frame.size.width;
    [_scrollView setContentOffset: CGPointMake(x, _scrollView.contentOffset.y) animated:YES];
    
    // 更换当前tableView
    _currentTableView = [_scrollView viewWithTag:pageIndex];
    [self changeToCurrentTableView];
}

/*
 * Overrided
 * ScrollView（被拖动）停止滚动时调用（是当前这次拖动的最终态）
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (MarketScrollViewTag == scrollView.tag) {
        MarketPageIndexEnum pageIndex = scrollView.contentOffset.x / scrollView.frame.size.width;
        
        if (pageIndex != _segmentedController.selectedSegmentIndex) {
            // 设置页码
            _segmentedController.selectedSegmentIndex = pageIndex;
            _currentTableView = [_scrollView viewWithTag:pageIndex];
            [self changeToCurrentTableView];
        }
    }
}

#pragma mark -
#pragma mark 功能性函数

/*
 * 拖动排序逻辑实现
 */
- (IBAction)longPressGestureRecognized:(UILongPressGestureRecognizer*)longPress {
    UIGestureRecognizerState state  = longPress.state;
    UITableView* targetView         = (UITableView*)longPress.view;
    CGPoint location                = [longPress locationInView:targetView];
    NSIndexPath* indexPath          = [targetView indexPathForRowAtPoint:location];
    
    static UIView       *snapshot           = nil;  //< A snapshot of the row user is moving.
    static NSIndexPath  *sourceIndexPath    = nil;  //< Initial index path, where gesture begins.
    
    switch (state) {
        case UIGestureRecognizerStateBegan: {
            if (indexPath) {
                sourceIndexPath = indexPath;
                
                UITableViewCell *cell = [targetView cellForRowAtIndexPath:indexPath];
                // Take a snapshot of the selected row using helper method.
                snapshot        = [self customSnapshotFromView:cell];
                CGPoint center  = cell.center;
                snapshot.center = center;
                snapshot.alpha  = 0.95;
                [targetView addSubview:snapshot];
                // 将原cell隐藏
                cell.hidden = YES;
                
                [UIView animateWithDuration:0.25 animations:^{
                    snapshot.transform = CGAffineTransformMakeScale(1.0, 1.05);
                } completion:nil];
            }
            break; 
        }
            
        case UIGestureRecognizerStateChanged: {
            CGPoint center  = snapshot.center;
            center.y        = location.y;
            snapshot.center = center;
            
            // 判断是否拖拽目标到了新的一行
            if (indexPath && ![indexPath isEqual:sourceIndexPath]) {
                // 数据中两行顺序交换
                [MarketDataService exchangeRow:(MarketPageIndexEnum)targetView.tag
                                          aRow:sourceIndexPath.row
                                      withBRow:indexPath.row];
                // 界面中，两个cell交换
                [targetView moveRowAtIndexPath:sourceIndexPath toIndexPath:indexPath];
                
                // and update source so it is in sync with UI changes.
                sourceIndexPath = indexPath; 
            } 
            break; 
        }
            
        default: {
            // Clean up.
            UITableViewCell *cell = [targetView cellForRowAtIndexPath:sourceIndexPath];
            [UIView animateWithDuration:0.25 animations:^{
                snapshot.center = cell.center;
                snapshot.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                [snapshot removeFromSuperview]; 
                snapshot    = nil;
                cell.hidden = NO;
            }]; 
            sourceIndexPath = nil; 
            break; 
        }
    }
}

- (UIView *)customSnapshotFromView:(UIView *)inputView {

    UIView *snapshot = [inputView snapshotViewAfterScreenUpdates:YES];
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.4;
    
    return snapshot;
}

/*
 * 转换到当前被选中的tableView
 */
- (void)changeToCurrentTableView {
    
    // 暂时直接reload
    [_currentTableView reloadData];
}

/*
 * 下拉刷新
 */
- (void)refreshTableView {
    [MarketDataService refreshPageData:(MarketPageIndexEnum)_currentTableView.tag
                          withCallback:^(NSError *error, NSDictionary *result) {
                              [_currentTableView.mj_header endRefreshing];
                              [_currentTableView reloadData];
    }];
}

@end
