//
//  SellItemPanel.m
//  Rising Fall
//
//  Created by David Villarreal on 7/23/14.
//  Copyright (c) 2014 David Villarreal. All rights reserved.
//

#import "SellItemPanel.h"

@implementation SellItemPanel


-(void)createPanel: (int)powerType Validate: (BOOL)isValidProduct{
    
    
    _powerType = powerType;
    
    if (isValidProduct) {
        [self createValidProductPanel];
    }else{
        [self createInvalidProductPanel];
    }
    
    
}

-(void)createTextView:(int)powerType{
    
    float fontsize = 17;
    
    NSString * key = [NSString stringWithFormat:@"PowerInfoK%d", powerType];
    NSString * info = NSLocalizedString(key, nil);
    
    CGRect frame = CGRectMake(self.position.x + self.size.width/2 - _textViewSize.width/2, self.position.y + self.size.height/2 - _textViewSize.height/2, _textViewSize.width, _textViewSize.height);

    _textView = [[UITextView alloc] initWithFrame:frame];
    _textView.textColor = [UIColor blackColor];
    _textView.font = [UIFont fontWithName:@"CooperBlack" size:fontsize];
    _textView.backgroundColor = [UIColor clearColor];
    _textView.text = info;
    _textView.textAlignment = NSTextAlignmentCenter;
    _textView.clipsToBounds = YES;
    _textView.layer.cornerRadius = 10.0f;
    _textView.editable = NO;
    _textView.userInteractionEnabled = NO;
    
    SKScene * parent = (SKScene *)self.parent;
    
    [parent.view addSubview:_textView];
    
}

//Creats buy panel if product is valid
-(void)createValidProductPanel{
    _textViewSize = CGSizeMake(self.size.width/1.5, self.size.height/2);
    
    NSString * textureName = [NSString stringWithFormat:@"st%d",_powerType];
    
    SKTexture * powerItemText = [[[TextureLoader shareTextureLoader] itemsAtlas] textureNamed: textureName];
    SKTexture * buyButtonText = [[[TextureLoader shareTextureLoader] buttonAtlas] textureNamed:@"buttonS1"];
    float yOffset = (self.size.height - powerItemText.size.height - buyButtonText.size.height)/4;
    
    SKSpriteNode * titleNode = [SKSpriteNode spriteNodeWithTexture:powerItemText];
    titleNode.position = CGPointMake(self.size.width/2, self.size.height - yOffset + powerItemText.size.height/2);
    [self addChild:titleNode];
    
    ButtonNode * buyButton = [ButtonNode spriteNodeWithTexture:buyButtonText];
    buyButton.position = CGPointMake(self.size.width/2, yOffset - buyButtonText.size.height/2);
    [buyButton setText:NSLocalizedString(@".99k", nil)];
    [buyButton setImages:buyButtonText pressedImage:buyButtonText];
    buyButton.delegate = self;
    buyButton.userInteractionEnabled = YES;
    [self addChild:buyButton];

}

//Creates error massage if product is invalid
-(void)createInvalidProductPanel{
    
}

-(void)buttonPressed:(ButtonType)type{
    
    if ([self payButtonPressed]) {
        //Display paid succes
        GameData * info = [GameData sharedGameData];
        [info.player increasePower:_powerType];
    }else{
        //Display paid fail
    }
    
}

//Called when the pay button is pressed
-(BOOL)payButtonPressed{
    PaymentClass * payment = [[PaymentClass alloc] init];
    return [payment payDollar];
}

@end
