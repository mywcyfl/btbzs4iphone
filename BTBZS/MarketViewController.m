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

#define MarketScrollViewTag 1000            // scrollView的tag
const unsigned int kCountDownTopValue = 5; // 刷新倒计时起始值

@interface MarketViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedController;
@property (weak, nonatomic) IBOutlet UIScrollView*  scrollView;
@property (strong, nonatomic) UITableView*          currentTableView;
@property (strong, nonatomic) NSTimer*              countdownTimer;
@property (assign, nonatomic) NSInteger             cntDownValue;               // 刷新倒计时数值
@property (strong, nonatomic) NSMutableDictionary*  tableViews;                 //
@end

@implementation MarketViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    __unused CGFloat w = self.view.frame.size.width;
    __unused CGFloat h = self.view.frame.size.height;
    
    _tableViews = [NSMutableDictionary dictionary];
    
    _scrollView.tag = MarketScrollViewTag;
    _scrollView.contentSize = CGSizeMake(kMarketPageIndex_MaxCnt * w, 0);
    _scrollView.showsHorizontalScrollIndicator  = NO;
    _scrollView.showsVerticalScrollIndicator    = YES;
    
    // 默认进入自选
    [self changeToTableViewByIndex:kMarketPageIndex_FavoritesMarkets];
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
    
    // 更换当前tableView
    [self changeToTableViewByIndex:pageIndex];
}

/*
 * Overrided
 * ScrollView（被拖动）停止滚动时调用（是当前这次拖动的最终态）
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (MarketScrollViewTag == scrollView.tag) {
        MarketPageIndexEnum pageIndex = scrollView.contentOffset.x / scrollView.frame.size.width;
        if (pageIndex != _segmentedController.selectedSegmentIndex) {
            [self changeToTableViewByIndex:pageIndex];
        }
    }
}

#pragma mark -
#pragma mark 功能性函数

/*
 * 刷新倒计时
 */
- (void)countdownStep {
    self.cntDownValue--;
    NSString* str = [NSString stringWithFormat:@"%ld", self.cntDownValue];
    if (self.cntDownValue > 0) {
        // 计时器减一
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:str
                                                                                  style:UIBarButtonItemStylePlain
                                                                                 target:nil action:nil];
        
        [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:12],
                                                                         NSForegroundColorAttributeName:[UIColor colorWithRed:0 green:0 blue:0 alpha:1.0]}
                                                              forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem.enabled = NO;
    } else {
        self.navigationItem.rightBarButtonItem = nil;
        // 刷新
        [self refreshTableView];
    }
}

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
- (void)changeToTableViewByIndex: (MarketPageIndexEnum) pageIndex {
    BOOL firstEnter     = NO;
    NSString* key       = [NSString stringWithFormat:@"%ld", (NSInteger)pageIndex];
    _currentTableView   = [_tableViews objectForKey:key];
    
    if (nil == _currentTableView) {
        firstEnter      = YES;
        CGFloat w       = self.view.frame.size.width;
        CGRect frame    = _scrollView.frame;
        
        _currentTableView = [[UITableView alloc] initWithFrame:CGRectMake(pageIndex*w, 0, frame.size.width, frame.size.height)];
        _currentTableView.delegate      = self;
        _currentTableView.dataSource    = self;
        _currentTableView.tag           = pageIndex;
        _currentTableView.showsHorizontalScrollIndicator    = NO;
        _currentTableView.showsVerticalScrollIndicator      = NO;
        [_currentTableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
        //[tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        // 添加长按手势
        UILongPressGestureRecognizer* longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognized:)];
        [_currentTableView addGestureRecognizer:longPress];
        // 接入第三方下拉刷新组件
        _currentTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self
                                                               refreshingAction:@selector(refreshTableView)];
        
        // 注册cell
        UINib* nib = [UINib nibWithNibName:[MarketTableViewCell reusedIdentifier] bundle:nil];
        [_currentTableView registerNib:nib forCellReuseIdentifier:[MarketTableViewCell reusedIdentifier]];
        _currentTableView.rowHeight = [MarketTableViewCell rowHeight];
        
        [_tableViews setObject:_currentTableView forKey:key];
        [_scrollView addSubview:_currentTableView];
        
        // 首次进入，下拉刷新
        [_currentTableView.mj_header beginRefreshing];
    }
    
    if (_segmentedController.selectedSegmentIndex != pageIndex) {
        // 切换segCtrl
        _segmentedController.selectedSegmentIndex = pageIndex;
    }
    
    // 滑动ScrollView
    CGFloat x = pageIndex * _scrollView.frame.size.width;
    [_scrollView setContentOffset: CGPointMake(x, _scrollView.contentOffset.y) animated:!firstEnter];
}

/*
 * 下拉刷新
 */
- (void)refreshTableView {
    [MarketDataService refreshPageData:(MarketPageIndexEnum)_currentTableView.tag
                          withCallback:^(NSError *error, NSDictionary *result) {
                              [_currentTableView.mj_header endRefreshing];
                              [_currentTableView reloadData];
                              // 刷新倒计时
                              [self restartCountDown];
    }];
}

- (void)restartCountDown {
    if ([self.countdownTimer isValid]) {
        [self.countdownTimer invalidate];
    }
    
    self.cntDownValue = kCountDownTopValue;
    self.countdownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                           target:self
                                                         selector:@selector(countdownStep)
                                                         userInfo:nil
                                                          repeats:YES];
}

@end
