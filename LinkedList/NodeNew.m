//
//  NodeNew.m
//  Rising Fall
//
//  Created by David Villarreal on 8/2/14.
//  Copyright (c) 2014 David Villarreal. All rights reserved.
//

#import "NodeNew.h"

@implementation NodeNew

-(id)initWithElement:(Ball *)ball{
    
    if (self = [super init]) {
        _element = ball;
    }
    
    return self;
    
}


@end
