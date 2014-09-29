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
            paymentClass = [[PaymentClass alloc] init];
        }
        
    }
    return paymentClass;
}

-(void)beginBuyFlow:(NSString *)productID{
    NSLog(@"buy flow began");
    _currentProductID = productID;
     NSLog(@"%@", _viewC);
    [self displaySpinner];
   
    self.productResquest = nil;
    self.productResquest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithArray:@[POWER_TYPE_1, POWER_TYPE_2, POWER_TYPE_3, POWER_TYPE_4, POWER_TYPE_5, MORE_LIFES, KEEP_PLAYING]]];
    
    self.productResquest.delegate = self;
    [self.productResquest start];
    
}

-(void)displaySpinner{
    [DejalBezelActivityView activityViewForView:self.viewC.view];
    
}

-(void)displayErrorMessage:(NSString *)error{
    UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:nil
                                                     message:error
                                                    delegate:self
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles: nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
}


-(void)request:(SKRequest *)request didFailWithError:(NSError *)error{
    [self displayErrorMessage:@"Fail request"];
    [self.delegate buyTransctionFinished:NO];
    [DejalBezelActivityView removeView];
}

-(void)requestDidFinish:(SKRequest *)request{
    
}

-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    [DejalBezelActivityView removeView];
    NSLog(@"product request did receive");
    
    for (SKProduct *product in response.products) {
        if ([product.productIdentifier isEqualToString:self.currentProductID]) {
            SKMutablePayment *payment = [SKMutablePayment paymentWithProduct:product];
            payment.quantity = 1;
            //payment.applicationUsername = @"add developer payload";
            [[SKPaymentQueue defaultQueue] addPayment:payment];
            break;
        }
    }
    
    [DejalBezelActivityView activityViewForView:self.viewC.view];
    self.productResquest = nil;
}

-(void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray *)transactions{
    
}

-(void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error{
    
}

-(void)paymentQueue:(SKPaymentQueue *)queue updatedDownloads:(NSArray *)downloads{
    
}

-(void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions{
    [DejalBezelActivityView removeView];
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
                // Call the appropriate custom method.
            case SKPaymentTransactionStatePurchased:
                if (self.delegate != nil) {
                    [self.delegate buyTransctionFinished:YES];
                }
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                if (self.delegate != nil) {
                    
                    [self.delegate buyTransctionFinished:NO];
                }
                [self displayErrorMessage:@"Error"];
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                if (self.delegate != nil) {
                    [self.delegate buyTransctionFinished:NO];
                }
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            default:
                break;
        }
    }
    
}

-(void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue{
    
}


-(void)clearClass{
    if (self.productResquest != nil) {
        [self.productResquest cancel];
    }
    
}


@end
