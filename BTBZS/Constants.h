//
//  Constants.h
//  BTBZS
//
//  Created by wcyfl on 15/11/15.
//  Copyright © 2015年 btbzs. All rights reserved.
//

#pragma once

/*
 * 市场枚举
 */
typedef enum {
    kOKCoinMarket = 0,  // OKCoin
    kBTCCMarket = 1     // BTCChina
}MarketEnum;

/*
 * 币种枚举
 */
typedef enum {
    kCurrencyEnum_RMB = 1,  // 人民币
    kCurrencyEnum_USD = 2   // 美刀
}CurrencyEnum;


/*
 * 市场页面枚举
 */
typedef enum {
    kMarketPageIndex_FavoritesMarkets  = 0,   // 自选
    kMarketPageIndex_BitCoinMarkets    = 1,   // 比特币市场
    kMarketPageIndex_LiteCoinMarkets   = 2,   // 莱特币市场
    kMarketPageIndex_OtherCoinsMarkets = 3,   // 其它币市场
    kMarketPageIndex_MaxCnt            = 4
}MarketPageIndexEnum;