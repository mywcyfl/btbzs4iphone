//
//  MarketTableViewCell.h
//  BTBZS
//
//  Created by wcyfl on 15/11/16.
//  Copyright © 2015年 btbzs. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 * 行情TableView的cell定义
 */
@interface MarketTableViewCell : UITableViewCell

@property (copy, nonatomic) NSString*       marketName;     // 市场名（如'OkCoin')
@property (copy, nonatomic) NSString*       currency;       // 币种（人民币/美元/欧元)
@property (strong, nonatomic) NSNumber*     curPriceRMB;    // 当前成交价（人民币)
@property (strong, nonatomic) NSNumber*     curPriceUSD;    // 当前成交价（美刀）
@property (assign, nonatomic) NSNumber*     volume;         // 成交量
@property (strong, nonatomic) NSNumber*     buyFirstPrice;  // 买一价格
@property (strong, nonatomic) NSNumber*     sellFirstPrice; // 买一价格
@property (strong, nonatomic) NSNumber*     highestPrice;   // 最高价
@property (strong, nonatomic) NSNumber*     lowestPrice;    // 最低价
@property (strong, nonatomic) NSNumber*     rate;           // 涨跌率
@property (assign, nonatomic) NSInteger     trend;          // 价格趋势（1:涨，0：平，-1：跌）

/*
 * 重用标志
 */
+ (NSString*)reusedIdentifier;

/*
 * 高度
 */
+ (NSUInteger)rowHeight;

@end
