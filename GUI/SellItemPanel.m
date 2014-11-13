//
//  SellItemPanel.m
//  Rising Fall
//
//  Created by David Villarreal on 7/23/14.
//  Copyright (c) 2014 David Villarreal. All rights reserved.
//

#import "SellItemPanel.h"
#import "StoreScene.h"

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
    
    float fontsize = [[FontChoicerClass shareFontChoicer] fontStoreInfo];
    
    NSString * key = [NSString stringWithFormat:@"P%dTitle", powerType];
    NSString * key2 = [NSString stringWithFormat:@"P%dInfo", powerType];
    NSString * info = NSLocalizedString(key, nil);
    NSString * info2 = NSLocalizedString(key2, nil);
    
    NSString * comp = [NSString stringWithFormat:@"%@\n%@", info, info2];
    
    CGRect frame = CGRectMake(self.position.x + self.size.width/2 - _textViewSize.width/2, self.position.y + self.size.height/2 - _textViewSize.height/2, _textViewSize.width, _textViewSize.height);

    _textView = [[UITextView alloc] initWithFrame:frame];
    _textView.textColor = [UIColor blackColor];
    _textView.font = [UIFont fontWithName:@"CooperBlack" size:fontsize];
    _textView.backgroundColor = [UIColor clearColor];
    _textView.text = comp;
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
    SKTexture * buyButtonText = [[[TextureLoader shareTextureLoader] buttonAtlas] textureNamed:@"buttonS1B"];
    float yOffset = (self.size.height - powerItemText.size.height/2 - buyButtonText.size.height/2)/4;
    
    SKSpriteNode * titleNode = [SKSpriteNode spriteNodeWithTexture:powerItemText];
    titleNode.size = CGSizeMake(titleNode.size.width/2, titleNode.size.height/2);
    titleNode.position = CGPointMake(self.size.width/2, self.size.height - yOffset);
    [self addChild:titleNode];
    
     _buyButton = [ButtonNode spriteNodeWithTexture:buyButtonText];
    _buyButton.size = CGSizeMake(_buyButton.size.width/2, _buyButton.size.height/2);
    _buyButton.position = CGPointMake(self.size.width/2, yOffset);
    [_buyButton setText:NSLocalizedString(@".99k", nil)];
    [_buyButton setImages:buyButtonText pressedImage:[[[TextureLoader shareTextureLoader] buttonAtlas] textureNamed:@"buttonS2B"]];
    _buyButton.delegate = self;
    _buyButton.userInteractionEnabled = YES;
    [self addChild:_buyButton];

}

//Creates error massage if product is invalid
-(void)createInvalidProductPanel{
    
}

-(void)buttonPressed:(ButtonType)type{
    [(StoreScene *) self.parent disableBack];
    _buyButton.userInteractionEnabled = NO;
    PaymentClass * paymentClass = [PaymentClass sharePaymentClass];
    paymentClass.delegate = self;
    [paymentClass beginBuyFlow:_powerID];
}


-(void)buyTransctionFinished:(BOOL)didBuy{
    if (didBuy) {
        GameData * info = [GameData sharedGameData];
        [info.player increasePower:_powerType];
    }
    
    [(StoreScene *) self.parent enableBack];
    _buyButton.userInteractionEnabled = YES;
    
}



@end
