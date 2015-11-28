//
//  MarketModels.h
//  BTBZS
//
//  Created by wcyfl on 15/11/28.
//  Copyright © 2015年 btbzs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TradeInfo : NSObject

@property (strong, nonatomic) NSNumber* highest;    // 近24小时最高
@property (strong, nonatomic) NSNumber* lowest;     // 近24小时最低
@property (strong, nonatomic) NSNumber* firstBuy;   // 买一
@property (strong, nonatomic) NSNumber* firstSell;  // 卖一
@property (strong, nonatomic) NSNumber* lastPrice;  // 最新成交价
@property (strong, nonatomic) NSNumber* volume;     // 近24小时内成交量
@property (strong, nonatomic) NSNumber* updateTime; // 更新时间
@property (strong, nonatomic) NSNumber* averate;    // 近24小时平均价
@property (strong, nonatomic) NSNumber* preClose;   // 昨收
@property (strong, nonatomic) NSNumber* open;       // 今开

@end
