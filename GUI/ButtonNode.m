//
//  ButtonNode.m
//  Rising Fall
//
//  Created by David Villarreal on 4/27/14.
//  Copyright (c) 2014 David Villarreal. All rights reserved.
//

#import "ButtonNode.h"


@implementation ButtonNode

-(void)setImages:(SKTexture *)defaultImage pressedImage:(SKTexture *)pressedImage{
    _defaultImage = defaultImage;
    _pressedImage = pressedImage;
}


-(void)setText: (NSString *)text{
    
    _label = [SKLabelNode labelNodeWithFontNamed:@"CooperBlack"];
    _label.text = text;
    _label.fontColor = [UIColor blackColor];
    _label.fontSize = 11;
    _label.zPosition = 2;
    _label.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    _label.position = CGPointMake(0, 0);
    [self addChild: _label];
    
    
}


-(void)setText:(NSString *)text Size: (int)fontSize{
    _label = [SKLabelNode labelNodeWithFontNamed:@"CooperBlack"];
    _label.text = text;
    _label.fontColor = [UIColor blackColor];
    _label.fontSize = fontSize;
    _label.zPosition = 2;
    _label.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    _label.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    _label.position = CGPointMake(2, 0);
    [self addChild: _label];
    
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    
    
   
    
    self.texture = _pressedImage;
    self.alpha = .5;
}


-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesMoved:touches withEvent:event];
    
    
   
    self.texture = _pressedImage;
    self.isMoved = YES;
}


-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    
   
    
    self.texture = _defaultImage;
    if (!_isMoved) {
        [self.delegate buttonPressed: _buttontype];
    }
    _isMoved = NO;
    self.alpha = 1;
    
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesCancelled:touches withEvent:event];
    
   
    self.texture = _defaultImage;
    
}

@end
