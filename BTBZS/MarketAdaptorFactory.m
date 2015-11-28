//
//  MarketAdaptorFactory.m
//  BTBZS
//
//  Created by wcyfl on 15/11/15.
//  Copyright © 2015年 btbzs. All rights reserved.
//

#import "MarketAdaptorFactory.h"
#import "OKCoinMarketAdaptor.h"
#import "BTCChinaMarketAdaptor.h"

@interface MarketAdaptorFactory()
@property(strong, nonatomic)NSDictionary* adaptors;
@end


@implementation MarketAdaptorFactory

+(instancetype)sharedInstance {
    static MarketAdaptorFactory* instance = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        instance = [[MarketAdaptorFactory alloc] init];
        instance.adaptors = @{
                              @([OKCoinMarketAdaptor MarketIdentify])   : [OKCoinMarketAdaptor class],
                              @([BTCChinaMarketAdaptor MarketIdentify]) : [BTCChinaMarketAdaptor class]
                              };
    });
    
    return instance;
}

+(BOOL)initlize {
    return nil != [MarketAdaptorFactory sharedInstance];
}

+(NSDictionary*)GetAllMarketAdaptor {
    return [MarketAdaptorFactory sharedInstance].adaptors;
}

+(id<BaseAdaptorProtocol>)GetAdaptorById:(MarketEnum)marketId {
    NSDictionary* adaptors = [MarketAdaptorFactory sharedInstance].adaptors;
    return [adaptors objectForKey:@(marketId)];
}

@end
