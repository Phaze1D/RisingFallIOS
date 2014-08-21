//
//  StoreBuyPanel.m
//  Rising Fall
//
//  Created by David Villarreal on 7/22/14.
//  Copyright (c) 2014 David Villarreal. All rights reserved.
//

#import "StoreBuyPanel.h"

@implementation StoreBuyPanel


-(void)createPanel{
    _powerItems = [[NSMutableArray alloc] initWithCapacity:5];
    [self createTitle];
    [self createItems];
    [self createPosition];
    
}

//Creates the position point
-(void)createPosition{
    
    float yOffset = (self.size.height - ((ButtonNode *)[_powerItems objectAtIndex:0]).size.height*5 - _title.frame.size.height)/7;
    _title.position = CGPointMake(self.size.width/2, self.size.height - yOffset);
    
    [self addChild:_title];
    
    for (int i = 0; i < 5; i++) {
        float yPosition = yOffset + (yOffset + ((ButtonNode *)[_powerItems objectAtIndex:0]).size.height)*i;
        ((ButtonNode *)[_powerItems objectAtIndex:i]).position = CGPointMake(self.size.width/2, yPosition);
        [self addChild:[_powerItems objectAtIndex:i]];
    }
    
}

//Creates the title
-(void)createTitle{
    _title = [SKLabelNode labelNodeWithFontNamed:@"CooperBlack"];
    _title.text = NSLocalizedString(@"ItemsK", nil);
    _title.fontSize = 15;
    _title.fontColor = [UIColor blackColor];
    _title.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
    
}

//Creates the titles
-(void)createItems{
    
    _iteamsAtlas = [[TextureLoader shareTextureLoader] itemsAtlas];
    
    for (int i = 0; i < 5; i++) {
        SKTexture * pText = [_iteamsAtlas textureNamed:[[_iteamsAtlas textureNames] objectAtIndex:i]];
        ButtonNode * pbutton = [ButtonNode spriteNodeWithTexture: pText];
        pbutton.buttontype = i+7;
        pbutton.delegate = self;
        pbutton.userInteractionEnabled = YES;
        pbutton.anchorPoint = CGPointMake(0.5, 0);
        [pbutton setImages:pText pressedImage:pText];
        [_powerItems addObject:pbutton];
    }
    
}

//Disables p buttons
-(void)disableButtons{
    for (ButtonNode * button in _powerItems) {
        button.userInteractionEnabled = NO;
    }
}

//Enables p buttons
-(void)enableButtons{
    for (ButtonNode * button in _powerItems) {
        button.userInteractionEnabled = YES;
    }
}


-(void)buttonPressed:(ButtonType)type{
    
    [self.delegate pButtonPressed:type - 6];
    
}


@end
