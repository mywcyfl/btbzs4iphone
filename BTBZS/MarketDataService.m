//
//  MarketDataService.m
//  BTBZS
//
//  Created by wcyfl on 15/11/14.
//  Copyright © 2015年 btbzs. All rights reserved.
//

#import "MarketDataService.h"
#import "BaseAdaptorProtocol.h"
#import "MarketAdaptorFactory.h"

#define MDS_FAVORITES           @"favorites"
#define MDS_BITCOINMARKETS      @"BitcoinMarkets"
#define MDS_LITECOINMARKETS     @"LiteCoinMarkets"
#define MDS_OTHERCOINMARKETS    @"OthersCoinMarkets"

#define MDS_MARKET_NAME         @"name"         // 名字
#define MDS_MARKET_CURRENCY     @"currency"     // 现实币种
#define MDS_MARKET_ADAPTOR      @"adaptor"      // 适配器
#define MDS_MARKET_COIN_TYPE    @"coinType"     // 虚拟币币种

@interface MarketDataService ()
@property(strong, nonatomic) NSDictionary* runtimeContext;
@end

@implementation MarketDataService

+(instancetype)sharedInstance {
    static MarketDataService* instance = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        instance = [[MarketDataService alloc] init];
        instance.runtimeContext = @{MDS_FAVORITES       :@[],
                                    MDS_BITCOINMARKETS  :@[@{MDS_MARKET_NAME        :@"OKCoin国际",
                                                             MDS_MARKET_CURRENCY    :@(2),
                                                             MDS_MARKET_ADAPTOR     :[MarketAdaptorFactory GetAdaptorById:kOKCoinMarketAdaptor],
                                                             MDS_MARKET_COIN_TYPE   :@(kVitualCoinEnum_BitCoin)
                                                             },
                                                           @{MDS_MARKET_NAME        :@"OKCoin中国",
                                                             MDS_MARKET_CURRENCY    :@(1),
                                                             MDS_MARKET_ADAPTOR     :[MarketAdaptorFactory GetAdaptorById:kOKCoinMarketAdaptor],
                                                             MDS_MARKET_COIN_TYPE   :@(kVitualCoinEnum_BitCoin)
                                                             },
                                                           @{MDS_MARKET_NAME        :@"OKCoin期货-本周",
                                                             MDS_MARKET_CURRENCY    :@(2),
                                                             MDS_MARKET_ADAPTOR     :[MarketAdaptorFactory GetAdaptorById:kOKCoinMarketAdaptor],
                                                             MDS_MARKET_COIN_TYPE   :@(kVitualCoinEnum_BitCoin)
                                                             },
                                                           @{MDS_MARKET_NAME:@"BTCTrade",
                                                             MDS_MARKET_CURRENCY:@(1)
                                                             },
                                                           @{MDS_MARKET_NAME:@"火币网",
                                                             MDS_MARKET_CURRENCY:@(1)
                                                             },
                                                           @{MDS_MARKET_NAME:@"796期货",
                                                             MDS_MARKET_CURRENCY:@(2)
                                                             },
                                                           @{MDS_MARKET_NAME:@"比特时代",
                                                             MDS_MARKET_CURRENCY:@(1)
                                                             },
                                                           @{MDS_MARKET_NAME        :@"BTCC（比特币中国）",
                                                             MDS_MARKET_CURRENCY    :@(1),
                                                             MDS_MARKET_ADAPTOR     :[MarketAdaptorFactory GetAdaptorById:kBTCCMarketAdaptor],
                                                             MDS_MARKET_COIN_TYPE   :@(kVitualCoinEnum_BitCoin)
                                                             }
                                                           ],
                                    
                                    MDS_LITECOINMARKETS :@[@{MDS_MARKET_NAME        :@"OKCoin国际",
                                                             MDS_MARKET_CURRENCY    :@(2),
                                                             MDS_MARKET_ADAPTOR     :[MarketAdaptorFactory GetAdaptorById:kOKCoinMarketAdaptor],
                                                             MDS_MARKET_COIN_TYPE   :@(kVitualCoinEnum_LiteCoin)
                                                             },
                                                           @{MDS_MARKET_NAME        :@"OKCoin中国",
                                                             MDS_MARKET_CURRENCY    :@(1),
                                                             MDS_MARKET_ADAPTOR     :[MarketAdaptorFactory GetAdaptorById:kOKCoinMarketAdaptor],
                                                             MDS_MARKET_COIN_TYPE   :@(kVitualCoinEnum_LiteCoin)
                                                             },
                                                           @{MDS_MARKET_NAME        :@"OKCoin期货-本周",
                                                             MDS_MARKET_CURRENCY    :@(2),
                                                             MDS_MARKET_ADAPTOR     :[MarketAdaptorFactory GetAdaptorById:kOKCoinMarketAdaptor],
                                                             MDS_MARKET_COIN_TYPE   :@(kVitualCoinEnum_LiteCoin)
                                                             },
                                                           @{MDS_MARKET_NAME:@"BTCTrade",
                                                             MDS_MARKET_CURRENCY:@(1)
                                                             },
                                                           @{MDS_MARKET_NAME:@"聚币网",
                                                             MDS_MARKET_CURRENCY:@(1)
                                                             },
                                                           @{MDS_MARKET_NAME:@"火币网",
                                                             MDS_MARKET_CURRENCY:@(1)
                                                             },
                                                           @{MDS_MARKET_NAME:@"796期货",
                                                             MDS_MARKET_CURRENCY:@(2)
                                                             },
                                                           @{MDS_MARKET_NAME:@"比特时代",
                                                             MDS_MARKET_CURRENCY:@(1)
                                                             },
                                                           @{MDS_MARKET_NAME        :@"BTCC（比特币中国）",
                                                             MDS_MARKET_CURRENCY    :@(2),
                                                             MDS_MARKET_ADAPTOR     :[MarketAdaptorFactory GetAdaptorById:kBTCCMarketAdaptor],
                                                             MDS_MARKET_COIN_TYPE   :@(kVitualCoinEnum_LiteCoin)
                                                             },
                                                           @{MDS_MARKET_NAME:@"中国比特币",
                                                             MDS_MARKET_CURRENCY:@(1)
                                                             }],
                                    MDS_OTHERCOINMARKETS:@[]};
    });
    
    return instance;
}

+ (BOOL)initlize {
    return YES;
}

+ (NSInteger)CountOfMarket:(MarketPageIndexEnum)pageIndex {
    NSString* pageStr = [self pageIndexToStr:pageIndex];
    NSArray* arr = [[MarketDataService sharedInstance].runtimeContext objectForKey:pageStr];
    return [arr count];
}

+ (UITableViewCell*)initCellValue:(MarketTableViewCell*)cell
        withPageIndex:(MarketPageIndexEnum)pageIndex
        withCellIndex:(NSInteger)cellIndex {
    NSString* pageStr   = [self pageIndexToStr:pageIndex];
    NSArray* arr        = [[MarketDataService sharedInstance].runtimeContext objectForKey:pageStr];
    NSDictionary* market = arr[cellIndex];
    
    cell.marketName     = [market objectForKey:MDS_MARKET_NAME];
    cell.currency       = [self CurrencyEnumToStr:(CurrencyEnum)[[market objectForKey:MDS_MARKET_CURRENCY] intValue]];
    cell.curPriceRMB    = @2000;
    cell.curPriceUSD    = @310;
    cell.volume         = @10000;
    cell.buyFirstPrice  = @20001;
    cell.sellFirstPrice = @2002;
    cell.highestPrice   = @3000;
    cell.lowestPrice    = @1800;
    cell.trend          = 1;
    
    return cell;
}

+ (void)refreshPageData:(MarketPageIndexEnum)pageIndex
           withCallback:(StandardCallback) cb {
    NSString* pageStr   = [self pageIndexToStr:pageIndex];
    NSArray* arr        = [[MarketDataService sharedInstance].runtimeContext objectForKey:pageStr];
    
    for (NSDictionary* dic in arr) {
        id<BaseAdaptorProtocol> adaptor = [dic objectForKey:MDS_MARKET_ADAPTOR];
        if (![adaptor conformsToProtocol:@protocol(BaseAdaptorProtocol)]) {
            continue;
        }
        
        VitualCoinEnum coinType = (VitualCoinEnum)[[dic objectForKey:MDS_MARKET_COIN_TYPE] intValue];
        if ([adaptor respondsToSelector:@selector(queryTradeInfo:)]) {
            [adaptor queryTradeInfo:coinType];
        }
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CALL_STANDARD_CB(cb, nil, nil);
    });
}


#pragma -
#pragma mark 内部辅助函数
+ (NSString*)CurrencyEnumToStr:(CurrencyEnum)e {
    if (kCurrencyEnum_RMB == e) {
        return @"RMB";
    } else if (kCurrencyEnum_USD == e) {
        return @"USD";
    }
    
    return @"";
}

+ (NSString*)pageIndexToStr:(MarketPageIndexEnum)pageIndex {
    if (kMarketPageIndex_FavoritesMarkets == pageIndex) {
        return MDS_FAVORITES;
    } else if (kMarketPageIndex_BitCoinMarkets == pageIndex) {
        return MDS_BITCOINMARKETS;
    } else if (kMarketPageIndex_LiteCoinMarkets == pageIndex) {
        return MDS_LITECOINMARKETS;
    } else {
        return MDS_OTHERCOINMARKETS;
    }
}

@end
