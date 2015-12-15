//
//  MarketDataService.m
//  BTBZS
//
//  Created by wcyfl on 15/11/14.
//  Copyright © 2015年 btbzs. All rights reserved.
//

#import "MarketDataService.h"
#import "BaseAdaptorProtocol.h"
#import "MarketModels.h"
#import "AFNetworking.h"

#define MDS_FAVORITES           @"favorites"
#define MDS_BITCOINMARKETS      @"btc"
#define MDS_LITECOINMARKETS     @"ltc"
#define MDS_OTHERCOINMARKETS    @"others"

#define MDS_MARKET_NAME         @"name"         // 名字
#define MDS_MARKET_CURRENCY     @"currency"     // 现实币种
#define MDS_MARKET_ADAPTOR      @"adaptor"      // 适配器
#define MDS_MARKET_COIN_TYPE    @"coinType"     // 虚拟币币种
#define MDS_MARKET_TRADE_INFO   @"tradeInfo"    // 行情
#define MDS_MARKET_EXTENSION    @"extension"    // 扩展字段

#define AskAllTradeinfoUri      @"http://localhost:3000/market/tradeInfo?coinType=all"
#define AskBtcTradeinfoUri      @"http://localhost:3000/market/tradeInfo?coinType=btc"
#define AskLtcTradeinfoUri      @"http://localhost:3000/market/tradeInfo?coinType=ltc"
#define AskOthersTradeinfoUri   @"http://localhost:3000/market/tradeInfo?coinType=others"


@interface MarketDataService ()
@property(strong, nonatomic) NSMutableDictionary* runtimeContext;
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
    NSString* pageStr       = [self pageIndexToStr:pageIndex];
    TradeInfo* tradeInfo    = [self tradeInfoForIndex:cellIndex inPage:pageStr];
    
    if (nil == tradeInfo) {
        return cell;
    }
    
    cell.marketName     = tradeInfo.name;
    cell.currency       = @"RMB";
    cell.curPriceRMB    = tradeInfo.lastPrice;
    cell.curPriceUSD    = tradeInfo.lastPrice;
    cell.volume         = tradeInfo.volume;
    cell.buyFirstPrice  = tradeInfo.firstBuy;
    cell.sellFirstPrice = tradeInfo.firstSell;
    cell.highestPrice   = tradeInfo.highest;
    cell.lowestPrice    = tradeInfo.lowest;
    cell.trend          = 1;
    
    return cell;
}

+ (void)refreshPageData:(MarketPageIndexEnum)pageIndex
           withCallback:(StandardCallback) cb {
    static AFHTTPRequestOperationManager* manager = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        manager = [AFHTTPRequestOperationManager manager];
    });
    
    NSString* uri = AskAllTradeinfoUri;
    
    [manager GET:uri parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"get tradeInfo from %@\n: %@", uri, responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            // 上锁防并发
            NSMutableDictionary* rootTradeInfos = [MarketDataService sharedInstance].runtimeContext;
            for (NSString* tradeInfosKey in responseObject) {
                NSMutableDictionary* tradeInfos = [rootTradeInfos objectForKey:tradeInfosKey];
                if (nil == tradeInfos) {
                    tradeInfos = [NSMutableDictionary dictionary];
                    [rootTradeInfos setObject:tradeInfos forKey:tradeInfosKey];
                }
                
                NSDictionary* netTradeInfos = [responseObject objectForKey:tradeInfosKey];
                NSArray* keys = [netTradeInfos allKeys];
                for (NSInteger i = 0; i < keys.count; i++) {
                    NSString* netTradeInfoKey  = [keys objectAtIndex:i];
                    NSDictionary* netTradeInfo = [netTradeInfos objectForKey:netTradeInfoKey];
                    
                    TradeInfo* tradeInfo = [tradeInfos objectForKey:netTradeInfoKey];
                    if (nil == tradeInfo) {
                        // 本地还没有这个数据则插入
                        tradeInfo       = [TradeInfo fromNetJson:netTradeInfo];
                        tradeInfo.index = i;
                        [tradeInfos setObject:tradeInfo forKey:netTradeInfoKey];
                    } else {
                        TradeInfo* newTradeInfo = [TradeInfo fromNetJson:netTradeInfo];
                        newTradeInfo.index      = tradeInfo.index;
                        if (newTradeInfo.updateTime > tradeInfo.updateTime) {
                            // 替换
                            [tradeInfos setObject:newTradeInfo forKey:netTradeInfoKey];
                        }
                    }
                }
            }
        }
        
        CALL_STANDARD_CB(cb, nil, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"get error from %@\n: %@", uri, error);
        CALL_STANDARD_CB(cb, error, nil);
    }];
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

+ (TradeInfo*)tradeInfoForIndex:(NSInteger) index inPage:(NSString*)pageStr {
    NSDictionary* dic           = [[MarketDataService sharedInstance].runtimeContext objectForKey:pageStr];
    if (![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    for (NSString* key in dic) {
        TradeInfo* tradeInfo = [dic objectForKey:key];
        if (tradeInfo.index == index) {
            return tradeInfo;
        }
    }
    
    return nil;
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
