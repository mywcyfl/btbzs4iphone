//
//  OKCoinMarkAdaptor.m
//  BTBZS
//
//  Created by wcyfl on 15/11/14.
//  Copyright © 2015年 btbzs. All rights reserved.
//

#import "OKCoinCNMarketAdaptor.h"
#import "AFNetworking.h"

static NSString* mainPageUri = @"https://www.okcoin.cn/";
static NSString* s_queryBtc  = @"https://www.okcoin.cn/api/v1/ticker.do?symbol=btc_cny";
static NSString* s_queryLtc  = @"https://www.okcoin.cn/api/v1/ticker.do?symbol=ltc_cny";

@implementation OKCoinCNMarketAdaptor

/*
 * Override
 */
+ (MarketAdaptorEnum)MarketIdentify {
    return kOKCoinCNMarketAdaptor;
}

/*
 * Override
 */
- (NSString*)marketName {
    return @"OKCoin";
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
- (void)queryTradeInfo:(VitualCoinEnum)coinType saveOn:(TradeInfo*)tradeInfo withCallback:(StandardCallback)cb {
    static AFHTTPRequestOperationManager* manager = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
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
        NSDictionary* responseDic = nil;
        if ([responseObject isKindOfClass:[NSData class]]) {
            responseDic = [NSJSONSerialization JSONObjectWithData:(NSData*)responseObject
                                                          options:NSJSONReadingMutableContainers
                                                            error:nil];
        }
        
        NSLog(@"get tradeInfo from %@\n: %@", uri, responseDic);
        if ([responseDic isKindOfClass:[NSDictionary class]]) {
            NSDictionary* dic = [responseDic objectForKey:@"ticker"];
            if ([dic isKindOfClass:[NSDictionary class]]) {
                tradeInfo.highest    = [NSNumber numberWithFloat:[[dic objectForKey:@"high"] floatValue]];
                tradeInfo.lowest     = [NSNumber numberWithFloat:[[dic objectForKey:@"low"] floatValue]];
                tradeInfo.firstBuy   = [NSNumber numberWithFloat:[[dic objectForKey:@"buy"] floatValue]];
                tradeInfo.firstSell  = [NSNumber numberWithFloat:[[dic objectForKey:@"sell"] floatValue]];
                tradeInfo.lastPrice  = [NSNumber numberWithFloat:[[dic objectForKey:@"last"] floatValue]];
                tradeInfo.volume     = [NSNumber numberWithFloat:[[dic objectForKey:@"vol"] floatValue]];
                tradeInfo.updateTime = [NSNumber numberWithLong:[[responseDic objectForKey:@"date"] longLongValue]];
            }
        }
        
        CALL_STANDARD_CB(cb, nil, tradeInfo);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"get error from %@\n: %@", uri, error);
        CALL_STANDARD_CB(cb, error, nil);
    }];
}

@end
