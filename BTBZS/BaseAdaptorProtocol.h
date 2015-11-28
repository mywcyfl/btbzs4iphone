//
//  BaseAdaptorProtocol.h
//  BTBZS
//
//  Created by wcyfl on 15/11/14.
//  Copyright © 2015年 btbzs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "MarketModels.h"

@protocol BaseAdaptorProtocol <NSObject>

// 市场枚举值
@required
+ (MarketAdaptorEnum)MarketIdentify;

// 市场名
@required
- (NSString*)marketName;

// 市场主页地址
@required
- (NSString*)marketMainPageUri;

// 查询交易信息
@required
- (void)queryTradeInfo:(VitualCoinEnum)coinType
                saveOn:(TradeInfo*)tradeInfo
          withCallback:(StandardCallback)cb;

@end
