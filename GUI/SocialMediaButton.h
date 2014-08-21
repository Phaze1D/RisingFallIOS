//
//  SocialMediaButton.h
//  Rising Fall
//
//  Created by David Villarreal on 4/28/14.
//  Copyright (c) 2014 David Villarreal. All rights reserved.
//

#import "ButtonNode.h"
#import "TextureLoader.h"
#import "SocialMediaControl.h"
#import "GameData.h"

typedef enum {
    FACEBOOK,
    CONTACTS,
    GOOGLE,
    PIN,
    REDDIT,
    TUMBLR,
    TWITTER,
    VK,
    MIXI,
    WEIBO,
    SOCIAL_BUTTON
} SocialType;

@protocol SocialMediaDelegate <NSObject>

@required
-(void)socialButtonPressed;
-(void)subSocialButtonPressed:(BOOL)didShare;
-(void)disableChild;
-(void)enbableChild;

@end

@interface SocialMediaButton : ButtonNode<SocialMediaControlDelegate>

@property (nonatomic, weak) id<SocialMediaDelegate> socialDelegate;

@property int indexInSubArray;

@property SocialType type;

@property BOOL isOpen;
@property BOOL didShare;


-(void)beginAnimation;


@end
