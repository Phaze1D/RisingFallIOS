//
//  SellItemPanel.h
//  Rising Fall
//
//  Created by David Villarreal on 7/23/14.
//  Copyright (c) 2014 David Villarreal. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "TextureLoader.h"
#import "ButtonNode.h"
#import "PaymentClass.h"
#import "GameData.h"


@interface SellItemPanel : SKSpriteNode <ButtonDelegate>

@property CGSize textViewSize;
@property UITextView * textView;
@property int powerType;

-(void)createPanel: (int)powerType Validate: (BOOL)isValidProduct;
-(void)createTextView: (int)powerType;

@end
