//
//  PaymentClass.h
//  Rising Fall
//
//  Created by David Villarreal on 7/21/14.
//  Copyright (c) 2014 David Villarreal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@protocol PaymentClassDelegate <NSObject>

@required
-(void)buyTransctionFinished:(BOOL)didBuy;

@end

@interface PaymentClass : NSObject <SKProductsRequestDelegate, SKRequestDelegate, SKPaymentTransactionObserver>

@property(nonatomic, weak) id<PaymentClassDelegate> delegate;

@property (readonly) NSArray * productIdentifiers;
@property  NSArray * products;

@property SKProductsRequest * productsRequest;

@property NSString * currentItemID;

@property BOOL didFinishRequest;
@property BOOL wantToBuy;

+(id)sharePaymentClass;

-(void)clearClass;
-(void)buyProduct:(NSString * )productID;

@end


static NSString * POWER_TYPE_1 = @"com.Phaze1D.RisingFall.Power1";
static NSString * POWER_TYPE_2 = @"com.Phaze1D.RisingFall.Power2";
static NSString * POWER_TYPE_3 = @"com.Phaze1D.RisingFall.Power3";
static NSString * POWER_TYPE_4 = @"com.Phaze1D.RisingFall.Power4";
static NSString * POWER_TYPE_5 = @"com.Phaze1D.RisingFall.Power5";
static NSString * MORE_LIFES = @"com.Phaze1D.RisingFall.Lifes";
static NSString * KEEP_PLAYING = @"com.Phaze1D.RisingFall.KeepPlaying";