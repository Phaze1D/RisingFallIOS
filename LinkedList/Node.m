//
//  Node.m
//  Rising Fall
//
//  Created by David Villarreal on 6/4/14.
//  Copyright (c) 2014 David Villarreal. All rights reserved.
//

#import "Node.h"

@implementation Node

-(id)initWithElement:(Ball *)ball{
    
    if (self = [super init]) {
        _element = ball;
    }
    
    return self;
    
}


@end
