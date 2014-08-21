//
//  Node.h
//  Rising Fall
//
//  Created by David Villarreal on 6/4/14.
//  Copyright (c) 2014 David Villarreal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Ball.h"

@interface Node : NSObject

@property Ball * element;

@property Node * next;
@property (weak) Node * parent;

-(id)initWithElement: (Ball *)ball;

@end
