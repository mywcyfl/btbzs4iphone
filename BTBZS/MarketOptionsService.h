//
//  MarketOptionsService.h
//  BTBZS
//
//  Created by wcyfl on 15/12/8.
//  Copyright © 2015年 btbzs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ServiceProtocol.h"
#import "Constants.h"

@interface MarketOptionsService : NSObject

/*
 * 获得市场数量
 */
+ (NSInteger)CountOfMarket:(MarketPageIndexEnum)pageIndex;


/*
 * 初始化cell
 */
+ (UITableViewCell*)initCellValue:(UITableViewCell*)cell
                    withPageIndex:(MarketPageIndexEnum)pageIndex
                    withCellIndex:(NSInteger)cellIndex;

@end
