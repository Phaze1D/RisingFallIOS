//
//  OptionPanel.m
//  Rising Fall
//
//  Created by David Villarreal on 5/25/14.
//  Copyright (c) 2014 David Villarreal. All rights reserved.
//

#import "OptionPanel.h"

@implementation OptionPanel



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    
}


-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesCancelled:touches withEvent:event];
}


-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesMoved:touches withEvent:event];
}


-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
        [self.delegate optionButtonPressed];

}

-(void)clearAll{
    [self removeAllActions];
    [self removeAllChildren];
    _delegate = nil;
}


@end
