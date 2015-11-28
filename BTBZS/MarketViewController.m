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
    }];
}

@end
