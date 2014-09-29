//
//  PaymentClass.h
//  Rising Fall
//
//  Created by David Villarreal on 7/21/14.
//  Copyright (c) 2014 David Villarreal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import "DejalActivityView.h"

@protocol PaymentClassDelegate <NSObject>

@required
-(void)buyTransctionFinished:(BOOL)didBuy;

@end

@interface PaymentClass : NSObject <SKProductsRequestDelegate, SKRequestDelegate, SKPaymentTransactionObserver, UIAlertViewDelegate>

@property(nonatomic, weak) id<PaymentClassDelegate> delegate;

@property (weak)UIViewController * viewC;

@property SKProductsRequest * productResquest;


@property NSString * currentProductID;

+(id)sharePaymentClass;

-(void)beginBuyFlow:(NSString *)productID;
-(void)clearClass;
@end


static NSString * POWER_TYPE_1 = @"com.Phaze1D.RisingFall.Power1";
static NSString * POWER_TYPE_2 = @"com.Phaze1D.RisingFall.Power2";
static NSString * POWER_TYPE_3 = @"com.Phaze1D.RisingFall.Power3";
static NSString * POWER_TYPE_4 = @"com.Phaze1D.RisingFall.Power4";
static NSString * POWER_TYPE_5 = @"com.Phaze1D.RisingFall.Power5";
static NSString * MORE_LIFES = @"com.Phaze1D.RisingFall.Lifes";
static NSString * KEEP_PLAYING = @"com.Phaze1D.RisingFall.KeepPlaying";