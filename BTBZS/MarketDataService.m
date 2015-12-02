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
#import "MarketModels.h"

#define MDS_FAVORITES           @"favorites"
#define MDS_BITCOINMARKETS      @"BitcoinMarkets"
#define MDS_LITECOINMARKETS     @"LiteCoinMarkets"
#define MDS_OTHERCOINMARKETS    @"OthersCoinMarkets"

#define MDS_MARKET_NAME         @"name"         // 名字
#define MDS_MARKET_CURRENCY     @"currency"     // 现实币种
#define MDS_MARKET_ADAPTOR      @"adaptor"      // 适配器
#define MDS_MARKET_COIN_TYPE    @"coinType"     // 虚拟币币种
#define MDS_MARKET_TRADE_INFO   @"tradeInfo"    // 行情
#define MDS_MARKET_EXTENSION    @"extension"    // 扩展字段

@interface MarketDataService ()
@property(strong, nonatomic) NSDictionary* runtimeContext;
@end

@implementation MarketDataService

+(instancetype)sharedInstance {
    static MarketDataService* instance = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        instance = [[MarketDataService alloc] init];
        instance.runtimeContext = [NSMutableDictionary dictionary];
        
        // 自选
        NSMutableDictionary* favorites = [NSMutableDictionary dictionary];
        [instance.runtimeContext setValue:favorites forKey:MDS_FAVORITES];
        
        // 比特币行情
        NSMutableDictionary* bitcoinMarkets = [NSMutableDictionary dictionary];
        [bitcoinMarkets setValue:@{MDS_MARKET_NAME        :@"OKCoin国际",
                                   MDS_MARKET_CURRENCY    :@(2),
                                   MDS_MARKET_ADAPTOR     :[MarketAdaptorFactory GetAdaptorById:kOKCoinCNMarketAdaptor],
                                   MDS_MARKET_COIN_TYPE   :@(kVitualCoinEnum_BitCoin),
                                   MDS_MARKET_EXTENSION   :OKCOIN_COM_GUOJI,
                                   MDS_MARKET_TRADE_INFO  :[[TradeInfo alloc] init]
                                   }
                          forKey:@"0"];
        
        
        [bitcoinMarkets setValue:@{MDS_MARKET_NAME        :@"OKCoin中国",
                                   MDS_MARKET_CURRENCY    :@(1),
                                   MDS_MARKET_ADAPTOR     :[MarketAdaptorFactory GetAdaptorById:kOKCoinCNMarketAdaptor],
                                   MDS_MARKET_COIN_TYPE   :@(kVitualCoinEnum_BitCoin),
                                   MDS_MARKET_TRADE_INFO  :[[TradeInfo alloc] init]
                                   }
                          forKey:@"1"];
        
        [bitcoinMarkets setValue:@{MDS_MARKET_NAME        :@"OKCoin期货-本周",
                                   MDS_MARKET_CURRENCY    :@(2),
                                   MDS_MARKET_ADAPTOR     :[MarketAdaptorFactory GetAdaptorById:kOKCoinCNMarketAdaptor],
                                   MDS_MARKET_COIN_TYPE   :@(kVitualCoinEnum_BitCoin),
                                   MDS_MARKET_EXTENSION   :OKCOIN_COM_HEYUE,
                                   MDS_MARKET_TRADE_INFO  :[[TradeInfo alloc] init]
                                   }
                          forKey:@"2"];
        
        [bitcoinMarkets setValue:@{MDS_MARKET_NAME        :@"BTCC（比特币中国）",
                                   MDS_MARKET_CURRENCY    :@(1),
                                   MDS_MARKET_ADAPTOR     :[MarketAdaptorFactory GetAdaptorById:kBTCCMarketAdaptor],
                                   MDS_MARKET_COIN_TYPE   :@(kVitualCoinEnum_BitCoin),
                                   MDS_MARKET_TRADE_INFO  :[[TradeInfo alloc] init]
                                   }
                          forKey:@"3"];
        [instance.runtimeContext setValue:bitcoinMarkets forKey:MDS_BITCOINMARKETS];
        
        // 莱特币行情
        NSMutableDictionary* litecoinMarkets = [NSMutableDictionary dictionary];
        [litecoinMarkets setValue:@{MDS_MARKET_NAME        :@"OKCoin国际",
                                    MDS_MARKET_CURRENCY    :@(2),
                                    MDS_MARKET_ADAPTOR     :[MarketAdaptorFactory GetAdaptorById:kOKCoinCNMarketAdaptor],
                                    MDS_MARKET_COIN_TYPE   :@(kVitualCoinEnum_LiteCoin),
                                    MDS_MARKET_EXTENSION   :OKCOIN_COM_GUOJI,
                                    MDS_MARKET_TRADE_INFO  :[[TradeInfo alloc] init]
                                    }
                          forKey:@"0"];
        
        [litecoinMarkets setValue:@{MDS_MARKET_NAME        :@"OKCoin中国",
                                    MDS_MARKET_CURRENCY    :@(1),
                                    MDS_MARKET_ADAPTOR     :[MarketAdaptorFactory GetAdaptorById:kOKCoinCNMarketAdaptor],
                                    MDS_MARKET_COIN_TYPE   :@(kVitualCoinEnum_LiteCoin),
                                    MDS_MARKET_TRADE_INFO  :[[TradeInfo alloc] init]
                                    }
                           forKey:@"1"];
        
        [litecoinMarkets setValue:@{MDS_MARKET_NAME        :@"OKCoin期货-本周",
                                    MDS_MARKET_CURRENCY    :@(2),
                                    MDS_MARKET_ADAPTOR     :[MarketAdaptorFactory GetAdaptorById:kOKCoinCNMarketAdaptor],
                                    MDS_MARKET_COIN_TYPE   :@(kVitualCoinEnum_LiteCoin),
                                    MDS_MARKET_EXTENSION   :OKCOIN_COM_HEYUE,
                                    MDS_MARKET_TRADE_INFO  :[[TradeInfo alloc] init]
                                    }
                           forKey:@"2"];
        
        [litecoinMarkets setValue:@{MDS_MARKET_NAME        :@"BTCC（比特币中国）",
                                    MDS_MARKET_CURRENCY    :@(2),
                                    MDS_MARKET_ADAPTOR     :[MarketAdaptorFactory GetAdaptorById:kBTCCMarketAdaptor],
                                    MDS_MARKET_COIN_TYPE   :@(kVitualCoinEnum_LiteCoin),
                                    MDS_MARKET_TRADE_INFO  :[[TradeInfo alloc] init]
                                    }
                           forKey:@"3"];
        [instance.runtimeContext setValue:litecoinMarkets forKey:MDS_LITECOINMARKETS];
        
        // 其它币
        NSMutableDictionary* others= [NSMutableDictionary dictionary];
        [instance.runtimeContext setValue:others forKey:MDS_OTHERCOINMARKETS];
        
        NSLog(@"market config:\n%@", instance.runtimeContext);
    });
    
    return instance;
}

+ (BOOL)initlize {
    return YES;
}

+ (NSInteger)CountOfMarket:(MarketPageIndexEnum)pageIndex {
    NSString* pageStr = [self pageIndexToStr:pageIndex];
    NSDictionary* dic = [[MarketDataService sharedInstance].runtimeContext objectForKey:pageStr];
    return [dic count];
}

+ (UITableViewCell*)initCellValue:(MarketTableViewCell*)cell
        withPageIndex:(MarketPageIndexEnum)pageIndex
        withCellIndex:(NSInteger)cellIndex {
    NSString* pageStr   = [self pageIndexToStr:pageIndex];
    NSDictionary* dic   = [[MarketDataService sharedInstance].runtimeContext objectForKey:pageStr];
    NSDictionary* market = [dic objectForKey:[NSString stringWithFormat:@"%ld", (long)cellIndex]];
    
    cell.marketName     = [market objectForKey:MDS_MARKET_NAME];
    cell.currency       = [self CurrencyEnumToStr:(CurrencyEnum)[[market objectForKey:MDS_MARKET_CURRENCY] intValue]];
    
    TradeInfo* tradeInfo = [market objectForKey:MDS_MARKET_TRADE_INFO];
    if ([tradeInfo isKindOfClass:[TradeInfo class]]) {
        cell.curPriceRMB    = tradeInfo.lastPrice;
        cell.curPriceUSD    = tradeInfo.lastPrice;
        cell.volume         = tradeInfo.volume;
        cell.buyFirstPrice  = tradeInfo.firstBuy;
        cell.sellFirstPrice = tradeInfo.firstSell;
        cell.highestPrice   = tradeInfo.highest;
        cell.lowestPrice    = tradeInfo.lowest;
        cell.trend          = 1;
    }
    
    return cell;
}

+ (void)refreshPageData:(MarketPageIndexEnum)pageIndex
           withCallback:(StandardCallback) cb {
    NSString* pageStr   = [self pageIndexToStr:pageIndex];
    NSDictionary* dics   = [[MarketDataService sharedInstance].runtimeContext objectForKey:pageStr];
    
    __block int refrestCnt = 0;
    for (NSString* key in dics) {
        NSDictionary* dic = [dics objectForKey:key];
        id<BaseAdaptorProtocol> adaptor = [dic objectForKey:MDS_MARKET_ADAPTOR];
        if (![adaptor conformsToProtocol:@protocol(BaseAdaptorProtocol)]) {
            continue;
        }
        
        TradeInfo* tradeInfo = [dic objectForKey:MDS_MARKET_TRADE_INFO];
        if (![tradeInfo isKindOfClass:[TradeInfo class]]) {
            continue;
        }
        
        refrestCnt++;
        VitualCoinEnum coinType = (VitualCoinEnum)[[dic objectForKey:MDS_MARKET_COIN_TYPE] intValue];
        NSString* extension     = [dic objectForKey:MDS_MARKET_EXTENSION];
        if ([adaptor respondsToSelector:@selector(queryTradeInfo:extension:saveOn:withCallback:)]) {
            [adaptor queryTradeInfo:coinType extension:extension saveOn:tradeInfo withCallback:^(NSError *error, id result) {
                refrestCnt--;
                if (refrestCnt <= 0) {
                    CALL_STANDARD_CB(cb, nil, nil);
                    return;
                }
            }];
        }
    }
    
    if (refrestCnt <= 0) {
        CALL_STANDARD_CB(cb, nil, nil);
    }
}

+ (void)exchangeRow:(MarketPageIndexEnum)pageIndex
               aRow:(NSInteger)rowAIndex
           withBRow:(NSInteger)rowBIndex {
    if (rowAIndex == rowBIndex) {
        return;
    }
    
    NSString* pageStr   = [self pageIndexToStr:pageIndex];
    NSDictionary* dics   = [[MarketDataService sharedInstance].runtimeContext objectForKey:pageStr];
    
    NSString* rowAKey = [NSString stringWithFormat:@"%ld", rowAIndex];
    NSString* rowBKey = [NSString stringWithFormat:@"%ld", rowBIndex];
    
    NSDictionary* rowADic = [dics objectForKey:rowAKey];
    NSDictionary* rowBDic = [dics objectForKey:rowBKey];
    
    if (nil != rowADic && nil != rowBDic) {
        [dics setValue:rowADic forKey:rowBKey];
        [dics setValue:rowBDic forKey:rowAKey];
    }
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
