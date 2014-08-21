//
//  FontChoicerClass.m
//  Rising Fall
//
//  Created by David Villarreal on 7/22/14.
//  Copyright (c) 2014 David Villarreal. All rights reserved.
//

#import "FontChoicerClass.h"

@implementation FontChoicerClass


//Share class throughtout the app
+(id)shareFontChoicer{
    
    static FontChoicerClass * fontC = nil;
    @synchronized(self) {
        if (fontC == nil){
            fontC= [[self alloc] init];
        }
    }
    return fontC;
    
}


//Choices the correct font size corresponding to the correct screen size
-(int)choiceFontSize:(int)idSize{
    
    return  0;
    
}

@end
