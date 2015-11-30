//
//  BTChinaMarketAdaptor.m
//  BTBZS
//
//  Created by wcyfl on 15/11/14.
//  Copyright © 2015年 btbzs. All rights reserved.
//

#import "BTCChinaMarketAdaptor.h"
#import "AFNetworking.h"
#import "MarketModels.h"

static NSString* mainPageUri    = @"https://www.btcc.com/";
static NSString* s_queryBtc     = @"https://data.btcchina.com/data/ticker?market=btccny";
static NSString* s_queryLtc     = @"https://data.btcchina.com/data/ticker?market=ltccny";

@implementation BTCChinaMarketAdaptor

/*
 * Override
 */
+ (MarketAdaptorEnum)MarketIdentify {
    return kBTCCMarketAdaptor;
}

/*
 * Override
 */
- (NSString*)marketName {
    return @"BTCC(比特币中国)";
}

/*
 * Override
 */
- (NSString*)marketMainPageUri {
    return mainPageUri;
}

/*
 * Override
 */
- (void)queryTradeInfo:(VitualCoinEnum)coinType
             extension:(NSString*) extension
                saveOn:(TradeInfo*)tradeInfo
          withCallback:(StandardCallback)cb {
    static AFHTTPRequestOperationManager* manager = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        manager = [AFHTTPRequestOperationManager manager];
    });
    
    NSString* uri = nil;
    if (kVitualCoinEnum_BitCoin == coinType) {
        // 请求比特币行情
        uri = s_queryBtc;
    } else {
        // 请求莱特币行情
        uri = s_queryLtc;
    }
    
    [manager GET:uri parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"get tradeInfo from %@\n: %@", uri, responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary* dic = [responseObject objectForKey:@"ticker"];
            if ([dic isKindOfClass:[NSDictionary class]]) {
                tradeInfo.highest    = [NSNumber numberWithFloat:[[dic objectForKey:@"high"] floatValue]];
                tradeInfo.lowest     = [NSNumber numberWithFloat:[[dic objectForKey:@"low"] floatValue]];
                tradeInfo.firstBuy   = [NSNumber numberWithFloat:[[dic objectForKey:@"buy"] floatValue]];
                tradeInfo.firstSell  = [NSNumber numberWithFloat:[[dic objectForKey:@"sell"] floatValue]];
                tradeInfo.lastPrice  = [NSNumber numberWithFloat:[[dic objectForKey:@"last"] floatValue]];
                tradeInfo.volume     = [NSNumber numberWithFloat:[[dic objectForKey:@"vol"] floatValue]];
                tradeInfo.updateTime = [dic objectForKey:@"date"];
                tradeInfo.averate    = [NSNumber numberWithFloat:[[dic objectForKey:@"vwap"] floatValue]];
                tradeInfo.preClose   = [NSNumber numberWithFloat:[[dic objectForKey:@"prev_close"] floatValue]];
                tradeInfo.open       = [NSNumber numberWithFloat:[[dic objectForKey:@"open"] floatValue]];
            }
        }
        
        CALL_STANDARD_CB(cb, nil, tradeInfo);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"get error from %@\n: %@", uri, error);
        CALL_STANDARD_CB(cb, error, nil);
    }];
}

@end
