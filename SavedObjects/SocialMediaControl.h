//
//  SocialMediaControl.h
//  Rising Fall
//
//  Created by David Villarreal on 4/29/14.
//  Copyright (c) 2014 David Villarreal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>
#import <GooglePlus/GooglePlus.h>
#import <GoogleOpenSource/GoogleOpenSource.h>
#import <Social/Social.h>
#import <MessageUI/MessageUI.h>
#import "VKSdk.h"



@class ViewController;
@protocol SocialMediaControlDelegate <NSObject>

@required
-(void)sharedCallBack: (BOOL)didShare;
-(void)disableOther;
-(void)enableOther;

@end


@interface SocialMediaControl : NSObject <GPPShareDelegate, GPPSignInDelegate, VKSdkDelegate, VKShareDialogDelegate, MFMessageComposeViewControllerDelegate>

@property (nonatomic, weak) id<SocialMediaControlDelegate> delegate;

@property ViewController * viewC;



+(id)sharedSocialMediaControl;

-(void)facebookClicked;
-(void)contactsClicked;
-(void)googleClicked;
-(void)twitterClicked;
-(void)vkClicked;
-(void)weiboClicked;


@end
