//
//  MarketDataService.h
//  BTBZS
//
//  Created by wcyfl on 15/11/14.
//  Copyright © 2015年 btbzs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServiceProtocol.h"
#import "MarketTableViewCell.h"
#import "Constants.h"

/*
 * 行情数据源
 */
@interface MarketDataService : NSObject<ServiceProtocol>

/*
 * 获得市场数量
 */
+ (NSInteger)CountOfMarket:(MarketPageIndexEnum)pageIndex;


/*
 * 初始化cell
 */
+ (UITableViewCell*)initCellValue:(MarketTableViewCell*)cell
                    withPageIndex:(MarketPageIndexEnum)pageIndex
                    withCellIndex:(NSInteger)cellIndex;

/*
 * 刷新数据
 */
+ (void)refreshPageData:(MarketPageIndexEnum)pageIndex
           withCallback:(StandardCallback) cb;

/*
 * 交换两行
 */
+ (void)exchangeRow:(MarketPageIndexEnum)pageIndex
               aRow:(NSInteger)rowAIndex
           withBRow:(NSInteger)rowBIndex;

@end
