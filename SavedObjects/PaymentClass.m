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
    
    _currentProductID = productID;
    [self displaySpinner];
   
    self.productResquest = nil;
    self.productResquest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithArray:@[POWER_TYPE_1, POWER_TYPE_2, POWER_TYPE_3, POWER_TYPE_4, POWER_TYPE_5, MORE_LIFES, KEEP_PLAYING]]];
    
    self.productResquest.delegate = self;
    [self.productResquest start];
    
}

-(void)displaySpinner{
    [DejalBezelActivityView activityViewForView:self.viewC.view].delegate = self;
}

-(void)closedButtonPressed{
    if (self.productResquest != nil) {
        [self.productResquest cancel];
        [DejalActivityView removeView];
        [self displayErrorMessage:NSLocalizedString(@"Payment Failed", nil)];
        [self.delegate buyTransctionFinished:NO];
    }
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
    [self displayErrorMessage:NSLocalizedString(@"Payment Failed", nil)];
    [self.delegate buyTransctionFinished:NO];
    [DejalBezelActivityView removeView];
}

-(void)requestDidFinish:(SKRequest *)request{
    
}

-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    [DejalBezelActivityView removeView];
    
    for (SKProduct *product in response.products) {
        if ([product.productIdentifier isEqualToString:self.currentProductID]) {
            SKMutablePayment *payment = [SKMutablePayment paymentWithProduct:product];
            payment.quantity = 1;
            payment.applicationUsername = ((GameData *)[GameData sharedGameData]).player.playerRandomString;
            [[SKPaymentQueue defaultQueue] addPayment:payment];
            break;
        }
    }
    
    [self displaySpinner];
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
                 [self displayErrorMessage:NSLocalizedString(@"Payment Failed", nil)];
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
