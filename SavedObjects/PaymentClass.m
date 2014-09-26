//
//  PaymentClass.m
//  Rising Fall
//
//  Created by David Villarreal on 7/21/14.
//  Copyright (c) 2014 David Villarreal. All rights reserved.
//

#import "PaymentClass.h"

@implementation PaymentClass




+(id)sharePaymentClass{
    static PaymentClass *paymentClass = nil;
    @synchronized(self) {
        if (paymentClass == nil){
            paymentClass = [[self alloc] init];
            [paymentClass setupProductInfo];
        }
        
    }
    return paymentClass;
}


-(void)setupProductInfo{
    _productIdentifiers = @[@"com.Phaze1D.RisingFall.Power1",@"com.Phaze1D.RisingFall.Power2",@"com.Phaze1D.RisingFall.Power3",@"com.Phaze1D.RisingFall.Power4",@"com.Phaze1D.RisingFall.Power5", @"com.Phaze1D.RisingFall.Lifes", @"com.Phaze1D.RisingFall.KeepPlaying"];
    
    
    _productsRequest = [[SKProductsRequest alloc]
                        initWithProductIdentifiers:[NSSet setWithArray:_productIdentifiers]];
    _productsRequest.delegate = self;
    [_productsRequest start];
    
    NSLog(@"Started product request for info");
    
}


-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    
    NSLog(@"Finish product request ");
    self.products = response.products;
    
    _didFinishRequest = YES;
    if (_didFinishRequest && _wantToBuy) {
        for (SKProduct * product in _products) {
            if ([product.productIdentifier isEqualToString:_currentItemID]) {
                [self beginProductBuyFlow:product];
                break;
            }
        }
    }


}

-(void)request:(SKRequest *)request didFailWithError:(NSError *)error{
    NSLog(@"failed ");
    _didFinishRequest = NO;
    if (_wantToBuy) {
        //Display error box
        _wantToBuy = NO;
    }
}

-(void)requestDidFinish:(SKRequest *)request{
    NSLog(@"finished");
    _didFinishRequest = YES;
}

-(void)buyProduct:(NSString *)productID{
    _currentItemID = productID;
    _wantToBuy = YES;
    if (_didFinishRequest) {
        for (SKProduct * product in _products) {
            if ([product.productIdentifier isEqualToString:_currentItemID]) {
                [self beginProductBuyFlow:product];
                break;
            }
        }
    }else{
        [_productsRequest start];
    }
}

-(void)beginProductBuyFlow:(SKProduct *)product{
    SKMutablePayment * payment = [SKMutablePayment paymentWithProduct:product];
    payment.quantity = 1;
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

-(void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue{
    
    
}

-(void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions{
        
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
                // Call the appropriate custom method.
            case SKPaymentTransactionStatePurchased:
                [self.delegate buyTransctionFinished:YES];
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self.delegate buyTransctionFinished:NO];
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self.delegate buyTransctionFinished:NO];
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            default:
                break;
        }
        
        
    }
    
    
}

-(void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray *)transactions{
   
    
}

-(void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error{
    
    
}

-(void)paymentQueue:(SKPaymentQueue *)queue updatedDownloads:(NSArray *)downloads{
    
    
}

-(void)didFinishBuying{
    _wantToBuy = NO;
    _currentItemID = nil;
}

-(void)clearClass{
    NSLog(@"did clear");
    [_productsRequest cancel];
    _productsRequest.delegate = nil;
    _productsRequest = nil;
}

@end
