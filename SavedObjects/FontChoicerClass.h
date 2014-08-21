//
//  FontChoicerClass.h
//  Rising Fall
//
//  Created by David Villarreal on 7/22/14.
//  Copyright (c) 2014 David Villarreal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FontChoicerClass : NSObject

@property int screenID;


+(id)shareFontChoicer;
-(int)choiceFontSize: (int)idSize;

@end
