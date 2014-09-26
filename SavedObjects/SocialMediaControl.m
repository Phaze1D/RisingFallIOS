//
//  SocialMediaControl.m
//  Rising Fall
//
//  Created by David Villarreal on 4/29/14.
//  Copyright (c) 2014 David Villarreal. All rights reserved.
//

#import "SocialMediaControl.h"
#import "ViewController.h"

static NSString * const kClientId = @"115719295372-v67pr17teh0rfbfae713cg4jgk2a3qm4.apps.googleusercontent.com";

@implementation SocialMediaControl


//Singleton Class Player
+(id)sharedSocialMediaControl{
    
    static SocialMediaControl *control = nil;
    @synchronized(self) {
        if (control == nil){
            control= [[self alloc] init];
        }
    }
    return control;
    
}

//Facebook sharing handler
-(void)facebookClicked{
    
    [self.delegate disableOther];
    _viewC.mainView.paused = YES;
    // Put together the dialog parameters
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"Sharing Tutorial", @"name",
                                   @"Build great social apps and get more installs.", @"caption",
                                   @"Allow your users to share stories on Facebook from your app using the iOS SDK.", @"description",
                                   @"https://developers.facebook.com/docs/ios/share/", @"link",
                                   @"http://i.imgur.com/g3Qc1HN.png", @"picture",
                                   nil];
    
    // Show the feed dialog
    
    [FBWebDialogs presentFeedDialogModallyWithSession:nil
                                           parameters:params
                                              handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                  [self.delegate enableOther];
                                                  [self resumeGame];
                                                  if (error) {
                                                      // An error occurred, we need to handle the error
                                                      // See: https://developers.facebook.com/docs/ios/errors
                                                      NSLog(@"Error publishing story: %@", error.description);
                                                      [self.delegate sharedCallBack:NO];
                                                      [self sharedErrorCallBack];
                                                      
                                                  } else {
                                                      if (result == FBWebDialogResultDialogNotCompleted) {
                                                          // User cancelled.
                                                          NSLog(@"User cancelled.");
                                                          [self.delegate sharedCallBack:NO];
                                                          [self sharedErrorCallBack];
                                                          
                                                      } else {
                                                          // Handle the publish feed callback
                                                          NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                                                          
                                                          if (![urlParams valueForKey:@"post_id"]) {
                                                              // User cancelled.
                                                              NSLog(@"User cancelled.");
                                                              [self.delegate sharedCallBack:NO];
                                                              [self sharedErrorCallBack];
                                                          } else {
                                                              // User clicked the Share button
                                                              //NSString *result = [NSString stringWithFormat: @"Posted story, id: %@", [urlParams valueForKey:@"post_id"]];
                                                              //NSLog(@"result %@", result);
                                                              [self.delegate sharedCallBack:YES];
                                                          }
                                                      }
                                                  }
                                                  
                                                  NSLog(@"Close session");
                                                  NSHTTPCookie *cookie;
                                                  NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
                                                  for (cookie in [storage cookies])
                                                  {
                                                      NSString* domainName = [cookie domain];
                                                      NSRange domainRange = [domainName rangeOfString:@"facebook"];
                                                      if(domainRange.length > 0)
                                                      {
                                                          [storage deleteCookie:cookie];
                                                      }
                                                  }
                                              }];
    
}

// A function for parsing URL parameters returned by the Feed Dialog.
- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}




//Contacts sharing handler
-(void)contactsClicked{
    
    if ([MFMessageComposeViewController canSendText] && [MFMessageComposeViewController canSendAttachments]) {
        _viewC.mainView.paused = YES;
        MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
        messageController.messageComposeDelegate = self;
        [messageController setBody:@"This is just a test"];
        [_viewC presentViewController:messageController animated:YES completion:nil];
        
    }else{
        [self sharedErrorCallBack];
    }
    
    
}

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    
    switch (result) {
        case MessageComposeResultCancelled:
            
            NSLog(@"cancel");
            [_viewC dismissViewControllerAnimated:YES completion:nil];
            [self sharedErrorCallBack];
            break;
            
        case MessageComposeResultFailed:
            NSLog(@"faild");
            [_viewC dismissViewControllerAnimated:YES completion:nil];
            [self sharedErrorCallBack];
            break;
            
            
        case MessageComposeResultSent:
            NSLog(@"sent");
            [_viewC dismissViewControllerAnimated:YES completion:nil];
            [self.delegate sharedCallBack:YES];
            break;
            
    }
    
    [self resumeGame];
    
}


//Google plus sharing handler
-(void)googleClicked{
    [self.delegate disableOther];
    _viewC.mainView.paused = YES;
    GPPSignIn *signIn = [GPPSignIn sharedInstance];
    signIn.shouldFetchGooglePlusUser = YES;
    //signIn.shouldFetchGoogleUserEmail = YES;  // Uncomment to get the user's email
    
    // You previously set kClientId in the "Initialize the Google+ client" step
    signIn.clientID = kClientId;
    
    // Uncomment one of these two statements for the scope you chose in the previous step
    signIn.scopes = @[ kGTLAuthScopePlusLogin ];  // "https://www.googleapis.com/auth/plus.login" scope
    //signIn.scopes = @[ @"profile" ];            // "profile" scope
    
    // Optional: declare signIn.actions, see "app activities"
    signIn.delegate = self ;
    
    [signIn authenticate];
    
}

//Google delegate
-(void)finishedWithAuth:(GTMOAuth2Authentication *)auth error:(NSError *)error{
    NSLog(@"Received error %@ and auth object %@",error, auth);
    
    if (error) {
        [self.delegate enableOther];
        [self resumeGame];
        [self sharedErrorCallBack];
    }else{
        [self.delegate disableOther];
        _viewC.mainView.paused = YES;
        [GPPShare sharedInstance].delegate = self;
        id<GPPNativeShareBuilder> shareBuilder = [[GPPShare sharedInstance] nativeShareDialog];
        [shareBuilder setURLToShare:[NSURL URLWithString:@"https://www.facebook.com/footdavid"]];
        [shareBuilder open];
        
    }
}


//Called when google finishing sharing
- (void)finishedSharingWithError:(NSError *)error {
    NSString *text;
    
    NSLog(@"finish with erro");
    
    if (!error) {
        text = @"Success";
        [self.delegate sharedCallBack:YES];
    } else if (error.code == kGPPErrorShareboxCanceled) {
        text = @"Canceled";
        [self.delegate sharedCallBack:NO];
        [self sharedErrorCallBack];
    } else {
        text = [NSString stringWithFormat:@"Error (%@)", [error localizedDescription]];
        [self.delegate sharedCallBack:NO];
        [self sharedErrorCallBack];
    }
    
    NSLog(@"Status: %@", text);
    
    GPPSignIn *signIn = [GPPSignIn sharedInstance];
    [signIn signOut];
    [signIn disconnect];
    [self.delegate enableOther];
    [self resumeGame];
    
}

-(void)twitterClicked{
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]){
        _viewC.mainView.paused = YES;
        SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:NSLocalizedString(@"ShareMessageK", nil)];
        [_viewC presentViewController:tweetSheet animated:YES completion:nil];
        
        [tweetSheet addURL:[NSURL URLWithString:@"https://www.facebook.com/RisingFallApp"]];
        [tweetSheet addImage:[UIImage imageNamed:@"http://i.imgur.com/g3Qc1HN.png"]];
        
        tweetSheet.completionHandler = ^(SLComposeViewControllerResult result) {
            
                switch(result) {
                        //  This means the user cancelled without sending the Tweet
                    case SLComposeViewControllerResultCancelled:
                        NSLog(@"canecle");
                        [self.delegate sharedCallBack:NO];
                        [self sharedErrorCallBack];
                        [self resumeGame];
                        break;
                        //  This means the user hit 'Send'
                    case SLComposeViewControllerResultDone:
                        NSLog(@"posted");
                        [self.delegate sharedCallBack:YES];
                        [self resumeGame];
                        break;
                        
                        
                }
            
            
        };
        
        
        
        
    }else{
        
        [self sharedErrorCallBack];
        [self resumeGame];
        [self.delegate sharedCallBack:NO];
    }
}

-(void)vkClicked{
    _viewC.mainView.paused = YES;
    [self.delegate disableOther];
    
    [VKSdk initializeWithDelegate:self andAppId:@"4486348"];
    
    
    [VKSdk authorize:@[VK_PER_WALL] revokeAccess:YES forceOAuth:NO inApp:YES];
    
}

-(void)vkSdkNeedCaptchaEnter:(VKError *)captchaError{
    
}

-(void)vkSdkTokenHasExpired:(VKAccessToken *)expiredToken{
    
}

-(void)vkSdkUserDeniedAccess:(VKError *)authorizationError{
    [self.delegate enableOther];
    [self resumeGame];
    
}

-(void)vkSdkShouldPresentViewController:(UIViewController *)controller{
    
    [_viewC presentViewController:controller animated:NO completion:nil];
}

-(void)vkSdkReceivedNewToken:(VKAccessToken *)newToken{
    
    NSLog(@"newtoken");
    [_viewC.presentedViewController dismissViewControllerAnimated:YES completion:^{
        
       
            VKShareDialogController * shareDialog = [VKShareDialogController new]; //1
            shareDialog.text = @"Your share text here"; //2
            //shareDialog.uploadImages = @[[VKUploadImage uploadImageWithImage:[UIImage imageNamed:@"Title.png"] andParams:[VKImageParameters jpegImageWithQuality:0.9]]]; //3
            shareDialog.otherAttachmentsStrings = @[@"https://vk.com/dev/ios_sdk"]; //4
            shareDialog.delegate = self;
            [shareDialog presentIn:_viewC]; //5
        
        
    } ];
    
}

-(void)vkuserCanceled{
    NSLog(@"vkcanceled");
    [self sharedErrorCallBack];
    [self.delegate enableOther];
    [self resumeGame];
    [VKSdk forceLogout];
}

-(void)vkuserPosted{
    NSLog(@"vkposted");
    [self.delegate enableOther];
    [self.delegate sharedCallBack:YES];
    [self resumeGame];
    [VKSdk forceLogout];
}


-(BOOL)mixiClicked{
    
    return YES;
}

-(void)weiboClicked{
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeSinaWeibo] ){
        _viewC.mainView.paused = YES;
        SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeSinaWeibo];
        [tweetSheet setInitialText:NSLocalizedString(@"ShareMessageK", nil)];
        [_viewC presentViewController:tweetSheet animated:YES completion:nil];
        
        [tweetSheet addURL:[NSURL URLWithString:@"https://www.facebook.com/RisingFallApp"]];
        [tweetSheet addImage:[UIImage imageNamed:@"http://i.imgur.com/g3Qc1HN.png"]];
        
        tweetSheet.completionHandler = ^(SLComposeViewControllerResult result) {
            
                switch(result) {
                        //  This means the user cancelled without sending the Tweet
                    case SLComposeViewControllerResultCancelled:
                        NSLog(@"canecle");
                        [self.delegate sharedCallBack:NO];
                        [self sharedErrorCallBack];
                        [self resumeGame];
                        break;
                        //  This means the user hit 'Send'
                    case SLComposeViewControllerResultDone:
                        NSLog(@"posted");
                        [self.delegate sharedCallBack:YES];
                        [self resumeGame];
                        break;
                }
        };
        
        
        
        
    }else{
        [self sharedErrorCallBack];
        [self.delegate sharedCallBack:NO];
        [self resumeGame];
    }
    
}

-(void)resumeGame{
    if ([_viewC.mainView.scene isKindOfClass: [StartScene class]]) {
        StartScene * sScene = (StartScene *)_viewC.mainView.scene;
        sScene.deltaTime = 1;
        _viewC.mainView.paused = NO;
    }else{
        _viewC.mainView.paused = NO;
    }
    
}

-(void)sharedErrorCallBack{
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:NSLocalizedString(@"TweetWaringTitleK", nil)
                              message:NSLocalizedString(@"TweetWaringK", nil)
                              delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
    [alertView show];
}


@end


//FACEBOOK,
//BLOGGER,
//CONTACTS,
//GOOGLE,
//PIN,
//REDDIT,
//TUMBLR,
//TWITTER,
//VK,
//MIXI,
//WEIBO,
//SOCIAL_BUTTON