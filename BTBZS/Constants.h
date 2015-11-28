//
//  Constants.h
//  BTBZS
//
//  Created by wcyfl on 15/11/15.
//  Copyright © 2015年 btbzs. All rights reserved.
//

#import <Foundation/Foundation.h>

// 错误Domain
#define BTBZS_ERROR_DOMAIN          @"BTBZS Error"

// 标准错误封装
#define BTBZS_ERROR(C, M)           [NSError errorWithDomain:BTBZS_ERROR_DOMAIN \
                                                        code:C \
                                                    userInfo:@{@"errorMessage":M}]

// 安全调用回调
#define CALL_STANDARD_CB(c,e,r)     do{ if(c){c(e,r);} } while(NO)

// 标准回调定义
typedef void (^StandardCallback) (NSError* error, id result);

/*
 * 市场枚举
 */
typedef enum {
    kNoneMarketAdaptor      = 0,
    kOKCoinMarketAdaptor    = 1,    // OKCoin
    kBTCCMarketAdaptor      = 2     // BTCChina
}MarketAdaptorEnum;

/*
 * 现实货币币种枚举
 */
typedef enum {
    kCurrencyEnum_RMB = 1,  // 人民币
    kCurrencyEnum_USD = 2   // 美刀
}CurrencyEnum;


/*
 * 现实货币币种枚举
 */
typedef enum {
    kVitualCoinEnum_BitCoin         = 1,    // 比特币
    kVitualCoinEnum_LiteCoin        = 2,    // 莱特币
    kVitualCoinEnum_InfinityCoin    = 3     // 无限币
}VitualCoinEnum;


/*
 * 行情页TableView枚举
 */
typedef enum {
    kMarketPageIndex_FavoritesMarkets  = 0,   // 自选
    kMarketPageIndex_BitCoinMarkets    = 1,   // 比特币市场
    kMarketPageIndex_LiteCoinMarkets   = 2,   // 莱特币市场
    kMarketPageIndex_OtherCoinsMarkets = 3,   // 其它币市场
    kMarketPageIndex_MaxCnt            = 4
}MarketPageIndexEnum;
