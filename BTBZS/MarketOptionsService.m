//
//  MarketOptionsService.m
//  BTBZS
//
//  Created by wcyfl on 15/12/8.
//  Copyright © 2015年 btbzs. All rights reserved.
//

#import "MarketOptionsService.h"

#define MOS_OPTION_NAME @"name"
#define MOS_OPTION_TYPE @"type"

@interface MarketOptionsService ()
@property (strong, nonatomic) NSDictionary* runtimeContext;
@end

@implementation MarketOptionsService

+(instancetype)sharedInstance {
    static MarketOptionsService* instance = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        instance = [[MarketOptionsService alloc] init];
        
    });
    
    return instance;
}

+ (BOOL)initlize {
    return YES;
}

@end
