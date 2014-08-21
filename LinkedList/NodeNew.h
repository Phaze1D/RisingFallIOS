//
//  NodeNew.h
//  Rising Fall
//
//  Created by David Villarreal on 8/2/14.
//  Copyright (c) 2014 David Villarreal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Ball.h"

@interface NodeNew : NSObject

@property NodeNew * next;
@property Ball * element;

-(id)initWithElement: (Ball *)ball;

@end
