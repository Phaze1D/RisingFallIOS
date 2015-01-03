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
    
    
    
    [FBSession openActiveSessionWithReadPermissions:@[@"public_profile", @"publish_actions"]
                                       allowLoginUI:YES
                                  completionHandler:
     ^(FBSession *session, FBSessionState state, NSError *error) {
        
         NSLog(@"%@  --- %u  ----- %@", session, state, error);
         
         
        
         [self sessionStateChanged:session state:state error:error];
         
         
     }];
    
    
}


- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error
{
    // If the session was opened successfully
    if (!error && state == FBSessionStateOpen){
        NSLog(@"Session opened");
        // Show the user the logged-in UI
        
        [self facebookCheckingPer];
        
        //[self userLoggedIn];
        return;
    }
    if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed){
        // If the session is closed
        NSLog(@"Session closed");
        // Show the user the logged-out UI
        
        //[self userLoggedOut];
    }
    
    // Handle errors
    if (error){
        NSLog(@"Error");
        NSString *alertText;
        NSString *alertTitle;
        // If the error requires people using an app to make an action outside of the app in order to recover
        if ([FBErrorUtility shouldNotifyUserForError:error] == YES){
            alertTitle = @"Something went wrong";
            alertText = [FBErrorUtility userMessageForError:error];
            
            //[self showMessage:alertText withTitle:alertTitle];
        } else {
            
            // If the user cancelled login, do nothing
            if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
                NSLog(@"User cancelled login");
                
                // Handle session closures that happen outside of the app
            } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession){
                alertTitle = @"Session Error";
                alertText = @"Your current session is no longer valid. Please log in again.";
               
                //[self showMessage:alertText withTitle:alertTitle];
                
                // Here we will handle all other errors with a generic error message.
                // We recommend you check our Handling Errors guide for more information
                // https://developers.facebook.com/docs/ios/errors/
            } else {
                //Get more error information from the error
                NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"];
                
                // Show the user an error message
                alertTitle = @"Something went wrong";
                alertText = [NSString stringWithFormat:@"Please retry. \n\n If the problem persists contact us and mention this error code: %@", [errorInformation objectForKey:@"message"]];
                
                //[self showMessage:alertText withTitle:alertTitle];
            }
        }
        // Clear this token
        [FBSession.activeSession closeAndClearTokenInformation];
        // Show the user the logged-out UI
        
        //[self userLoggedOut];
    }
}



-(void)facebookCheckingPer{
    
    [FBRequestConnection startWithGraphPath:@"/me/permissions"
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                              __block NSString *alertText;
                              __block NSString *alertTitle;
                              if (!error){
                                  // Walk the list of permissions looking to see if publish_actions has been granted
                                  NSArray *permissions = (NSArray *)[result data];
                                  BOOL publishActionsSet = FALSE;
                                  for (NSDictionary *perm in permissions) {
                                      if ([[perm objectForKey:@"permission"] isEqualToString:@"publish_actions"] &&
                                          [[perm objectForKey:@"status"] isEqualToString:@"granted"]) {
                                          publishActionsSet = TRUE;
                                          NSLog(@"publish_actions granted.");
                                          break;
                                      }
                                  }
                                  if (!publishActionsSet){
                                      // Publish permissions not found, ask for publish_actions
                                      [self requestPublishPermissions];
                                      
                                  } else {
                                      // Publish permissions found, publish the OG story
                                      [self publishStory];
                                  }
                                  
                              } else {
                                  // There was an error, handle it
                                  // See https://developers.facebook.com/docs/ios/errors/
                              }
                          }];
    
    
}

-(void)requestPublishPermissions{
    [FBSession.activeSession requestNewPublishPermissions:[NSArray arrayWithObject:@"publish_actions"]
                                          defaultAudience:FBSessionDefaultAudienceFriends
                                        completionHandler:^(FBSession *session, NSError *error) {
                                            __block NSString *alertText;
                                            __block NSString *alertTitle;
                                            if (!error) {
                                                if ([FBSession.activeSession.permissions
                                                     indexOfObject:@"publish_actions"] == NSNotFound){
                                                    // Permission not granted, tell the user we will not publish
                                                    alertTitle = @"Permission not granted";
                                                    alertText = @"Your action will not be published to Facebook.";
                                                    [[[UIAlertView alloc] initWithTitle:alertTitle
                                                                                message:alertText
                                                                               delegate:self
                                                                      cancelButtonTitle:@"OK!"
                                                                      otherButtonTitles:nil] show];
                                                } else {
                                                    // Permission granted, publish the OG story
                                                    [self publishStory];
                                                }
                                                
                                            } else {
                                                // There was an error, handle it
                                                // See https://developers.facebook.com/docs/ios/errors/
                                            }
                                        }];
}

-(void)publishStory{
   
    FBLinkShareParams *params = [[FBLinkShareParams alloc] init];
    params.link = [NSURL URLWithString:@"https://www.facebook.com/RisingFallApp"];
    params.picture = [NSURL URLWithString:@"http://i.imgur.com/rt0Z71e.png"];
    params.name = @"Rising Fall";
    params.caption = @"Playing Rising Fall";
    params.linkDescription = @"Small little game I made";
    
    
    if([FBDialogs canPresentShareDialogWithParams:params]){
        [self facebookNativeApp];
    }else{
        [self facebookWebDialog];
    }

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

//Facebook native app handler
-(void)facebookNativeApp{
    
    FBLinkShareParams *params = [[FBLinkShareParams alloc] init];
    params.link = [NSURL URLWithString:@"https://www.facebook.com/RisingFallApp"];
    params.picture = [NSURL URLWithString:@"http://i.imgur.com/rt0Z71e.png"];
    params.name = @"Rising Fall";
    params.caption = @"Playing Rising Fall";
    params.linkDescription = @"Small little game I made";
    
    [FBDialogs presentShareDialogWithParams:params clientState:nil
                                  handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                      if(error) {
                                          // An error occurred, we need to handle the error
                                          // See: https://developers.facebook.com/docs/ios/errors
                                          NSLog(@"Error publishing story: %@", error.description);
                                          [self.delegate sharedCallBack:NO];
                                          [self sharedErrorCallBack: @"Post Failed"];
                                          
                                      } else {
                                          // Success
                                          NSLog(@"result %@", results);
                                          
                                          if ([results[@"completionGesture"] isEqualToString:@"post"]) {
                                              [self.delegate sharedCallBack:YES];
                                          }else{
                                              [self.delegate sharedCallBack:NO];
                                              [self sharedErrorCallBack: @"Post Failed"];
                                          }
                                          
                                      }
                                      
                                      [[FBSession activeSession] closeAndClearTokenInformation];
                                  }];
    
}


//Facebook WebDialog
-(void)facebookWebDialog{
    
    // Put together the dialog parameters
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"Rising Fall", @"name",
                                   @"Playing Rising Fall", @"caption",
                                   @"Small little game I made", @"description",
                                   @"https://www.facebook.com/RisingFallApp", @"link",
                                   @"http://i.imgur.com/rt0Z71e.png", @"picture",
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
                                                      //NSLog(@"Error publishing story: %@", error.description);
                                                      [self.delegate sharedCallBack:NO];
                                                      [self sharedErrorCallBack: @"Post Failed"];
                                                      
                                                  } else {
                                                      if (result == FBWebDialogResultDialogNotCompleted) {
                                                          // User cancelled.
                                                          // NSLog(@"User cancelled.");
                                                          [self.delegate sharedCallBack:NO];
                                                          [self sharedErrorCallBack: @"Post Failed"];
                                                          
                                                      } else {
                                                          // Handle the publish feed callback
                                                          NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                                                          
                                                          if (![urlParams valueForKey:@"post_id"]) {
                                                              // User cancelled.
                                                              // NSLog(@"User cancelled.");
                                                              [self.delegate sharedCallBack:NO];
                                                              [self sharedErrorCallBack : @"Post Failed"];
                                                          } else {
                                                              
                                                              [self.delegate sharedCallBack:YES];
                                                          }
                                                      }
                                                  }
                                                  
                                                  [[FBSession activeSession] closeAndClearTokenInformation];
                                                  
                                                  //NSLog(@"Close session");
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




//Contacts sharing handler
-(void)contactsClicked{
    
    if ([MFMessageComposeViewController canSendText] && [MFMessageComposeViewController canSendAttachments]) {
        _viewC.mainView.paused = YES;
        MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
        messageController.messageComposeDelegate = self;
        [messageController setBody:@"Playing Rising Fall https://www.facebook.com/RisingFallApp"];
        [_viewC presentViewController:messageController animated:YES completion:nil];
        
    }else{
        [self sharedErrorCallBack:@"Post Failed"];
    }
    
    
}

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    
    switch (result) {
        case MessageComposeResultCancelled:
            
           // NSLog(@"cancel");
            [_viewC dismissViewControllerAnimated:YES completion:nil];
            [self sharedErrorCallBack:@"Post Failed"];
            break;
            
        case MessageComposeResultFailed:
            //NSLog(@"faild");
            [_viewC dismissViewControllerAnimated:YES completion:nil];
            [self sharedErrorCallBack:@"Post Failed"];
            break;
            
            
        case MessageComposeResultSent:
           // NSLog(@"sent");
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
    
    if (error) {
        [self.delegate enableOther];
        [self resumeGame];
        [self sharedErrorCallBack:@"Post Failed"];
    }else{
        [self.delegate disableOther];
        _viewC.mainView.paused = YES;
        [GPPShare sharedInstance].delegate = self;
        id<GPPNativeShareBuilder> shareBuilder = [[GPPShare sharedInstance] nativeShareDialog];
        [shareBuilder setTitle:@"Rising Fall" description:@"Small fun game I made" thumbnailURL:[NSURL URLWithString:@"http://i.imgur.com/rt0Z71e.png"]];
        [shareBuilder setPrefillText:@"Playing Rising Fall"];
        
        [shareBuilder setURLToShare:[NSURL URLWithString:@"https://www.facebook.com/RisingFallApp"]];
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
        [self sharedErrorCallBack:@"Post Failed"];
    } else {
        text = [NSString stringWithFormat:@"Error (%@)", [error localizedDescription]];
        [self.delegate sharedCallBack:NO];
        [self sharedErrorCallBack:@"Post Failed"];
    }
    
    
    
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
        [tweetSheet setInitialText:@"Playing Rising Fall"];
        [_viewC presentViewController:tweetSheet animated:YES completion:nil];
        
        [tweetSheet addURL:[NSURL URLWithString:@"https://www.facebook.com/RisingFallApp"]];
        [tweetSheet addImage:[UIImage imageNamed:@"RF120.png"]];
        
        tweetSheet.completionHandler = ^(SLComposeViewControllerResult result) {
            
                switch(result) {
                        //  This means the user cancelled without sending the Tweet
                    case SLComposeViewControllerResultCancelled:
                        
                        [self.delegate sharedCallBack:NO];
                        [self sharedErrorCallBack: @"Post Failed"];
                        [self resumeGame];
                        break;
                        //  This means the user hit 'Send'
                    case SLComposeViewControllerResultDone:
                        
                        [self.delegate sharedCallBack:YES];
                        [self resumeGame];
                        break;
                        
                        
                }
            
            
        };
        
        
        
        
    }else{
        
        [self sharedErrorCallBack: @"Twitter Error"];
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
            shareDialog.text = @"Playing Rising Fall"; //2
            shareDialog.uploadImages = @[[VKUploadImage uploadImageWithImage:[UIImage imageNamed:@"RF120.png"] andParams:[VKImageParameters jpegImageWithQuality:0.9]]]; //3
            shareDialog.otherAttachmentsStrings = @[@"https://www.facebook.com/RisingFallApp"]; //4
            shareDialog.delegate = self;
            [shareDialog presentIn:_viewC]; //5
        
        
    } ];
    
}

-(void)vkuserCanceled{
    NSLog(@"vkcanceled");
    [self sharedErrorCallBack:@"Post Failed"];
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
        [tweetSheet setInitialText:@"Playing Rising Fall"];
        [_viewC presentViewController:tweetSheet animated:YES completion:nil];
        
        [tweetSheet addURL:[NSURL URLWithString:@"https://www.facebook.com/RisingFallApp"]];
        [tweetSheet addImage:[UIImage imageNamed:@"RF120.png"]];
        
        tweetSheet.completionHandler = ^(SLComposeViewControllerResult result) {
            
                switch(result) {
                        //  This means the user cancelled without sending the Tweet
                    case SLComposeViewControllerResultCancelled:
                        
                        [self.delegate sharedCallBack:NO];
                        [self sharedErrorCallBack:@"Post Failed"];
                        [self resumeGame];
                        break;
                        //  This means the user hit 'Send'
                    case SLComposeViewControllerResultDone:
                       
                        [self.delegate sharedCallBack:YES];
                        [self resumeGame];
                        break;
                }
        };
        
        
        
        
    }else{
        [self sharedErrorCallBack:@"Weibo Error"];
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

-(void)sharedErrorCallBack: (NSString *) key{
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:NSLocalizedString(@"Error", nil)
                              message:NSLocalizedString(key, nil)
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