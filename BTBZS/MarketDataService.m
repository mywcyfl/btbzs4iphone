//
//  MarketDataService.m
//  BTBZS
//
//  Created by wcyfl on 15/11/14.
//  Copyright © 2015年 btbzs. All rights reserved.
//

#import "MarketDataService.h"

#define MDS_FAVORITES           @"favorites"
#define MDS_BITCOINMARKETS      @"BitcoinMarkets"
#define MDS_LITECOINMARKETS     @"LiteCoinMarkets"
#define MDS_OTHERCOINMARKETS    @"OthersCoinMarkets"

#define MDS_MARKET_NAME         @"name"
#define MDS_MARKET_CURRENCY     @"currency"

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
                                    MDS_BITCOINMARKETS  :@[@{MDS_MARKET_NAME:@"OKCoin国际",
                                                             MDS_MARKET_CURRENCY:@(2)},
                                                           @{MDS_MARKET_NAME:@"OKCoin中国",
                                                             MDS_MARKET_CURRENCY:@(1)},
                                                           @{MDS_MARKET_NAME:@"OKCoin期货-本周",
                                                             MDS_MARKET_CURRENCY:@(2)},
                                                           @{MDS_MARKET_NAME:@"BTCTrade",
                                                             MDS_MARKET_CURRENCY:@(1)},
                                                           @{MDS_MARKET_NAME:@"火币网",
                                                             MDS_MARKET_CURRENCY:@(1)},
                                                           @{MDS_MARKET_NAME:@"796期货",
                                                             MDS_MARKET_CURRENCY:@(2)},
                                                           @{MDS_MARKET_NAME:@"比特时代",
                                                             MDS_MARKET_CURRENCY:@(1)},
                                                           @{MDS_MARKET_NAME:@"BTCC（比特币中国）",
                                                             MDS_MARKET_CURRENCY:@(1)}],
                                    
                                    MDS_LITECOINMARKETS :@[@{MDS_MARKET_NAME:@"OKCoin国际",
                                                             MDS_MARKET_CURRENCY:@(2)},
                                                           @{MDS_MARKET_NAME:@"OKCoin中国",
                                                             MDS_MARKET_CURRENCY:@(1)},
                                                           @{MDS_MARKET_NAME:@"OKCoin期货-本周",
                                                             MDS_MARKET_CURRENCY:@(2)},
                                                           @{MDS_MARKET_NAME:@"BTCTrade",
                                                             MDS_MARKET_CURRENCY:@(1)},
                                                           @{MDS_MARKET_NAME:@"聚币网",
                                                             MDS_MARKET_CURRENCY:@(1)},
                                                           @{MDS_MARKET_NAME:@"火币网",
                                                             MDS_MARKET_CURRENCY:@(1)},
                                                           @{MDS_MARKET_NAME:@"796期货",
                                                             MDS_MARKET_CURRENCY:@(2)},
                                                           @{MDS_MARKET_NAME:@"比特时代",
                                                             MDS_MARKET_CURRENCY:@(1)},
                                                           @{MDS_MARKET_NAME:@"BTCC（比特币中国）",
                                                             MDS_MARKET_CURRENCY:@(2)},
                                                           @{MDS_MARKET_NAME:@"中国比特币",
                                                             MDS_MARKET_CURRENCY:@(1)}],
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
