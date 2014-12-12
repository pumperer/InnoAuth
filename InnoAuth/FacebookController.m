//
//  FacebookController.m
//  TestProj
//
//  Created by hsshin on 2014. 11. 12..
//  Copyright (c) 2014년 Innospark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FacebookController.h"
//#import "InnoAuthLib.h"

// /me/friends
// /me

@interface FacebookController ()

@end

static NSArray* permissions = nil;

@implementation FacebookController

- (id) initWithReflector:(id<SocialReflector>)socialReflector {
    self = [super init];
    if(self != nil) {
        reflector = socialReflector;
        fbSession = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            permissions = @[@"public_profile"];
        });
    }
    
    return (self);
}

- (void) Login {
    [FBSession openActiveSessionWithReadPermissions:permissions
                                       allowLoginUI:YES
                                  completionHandler:
     ^(FBSession *session, FBSessionState state, NSError *error) {
         
         // Retrieve the app delegate
         //AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
         // Call the app delegate's sessionStateChanged:state:error method to handle session state changes
         [self sessionStateChanged:session state:state error:error];
     }];
}

- (void) Logout {
    if (FBSession.activeSession.state == FBSessionStateOpen
        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        [FBSession.activeSession closeAndClearTokenInformation];
    }
}

- (BOOL) AutoLogin {
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        NSLog(@"Found a cached SESSION!");
        [FBSession openActiveSessionWithReadPermissions:nil allowLoginUI:NO completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
            NSLog(@"InnoAuth-Facebook : AutoLogin Handler");
            [self sessionStateChanged:session state:status error:error];
        }];
        return YES;
    }
    
    return NO;
}

- (void) userLoggedIn {
    NSLog(@"InnoAuth-Facebook : Login OK!!!!");
    [reflector SocialLogInComplete:InnoAuthTypeFaceBook];
}

- (void) userLoggedOut {
    NSLog(@"InnoAuth-Facebook : Logout OK!!!!");
    [reflector SocialLogOutComplete:InnoAuthTypeFaceBook];
}

- (void) requestAccounts {
    [FBRequestConnection startWithGraphPath:@"/me?locale=ko_KR" parameters:nil HTTPMethod:@"GET" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (error) {
            NSLog(@"InnoAuth-Facebook : Get Accounts Error!!!!");
            [reflector requestAccountsComplete:InnoAuthTypeFaceBook result:nil];
        } else {
            NSError *err;
            NSData* jsonData = [NSJSONSerialization dataWithJSONObject:result options:NSJSONWritingPrettyPrinted error:&err];
            NSString* fullStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSLog(@"InnoAuth-Facebook : Get Accounts OK!!!!");
            [reflector requestAccountsComplete:InnoAuthTypeFaceBook result:fullStr];
        }
    }];
}

- (void) requestFriendsUseThisApp {
    [FBRequestConnection startWithGraphPath:@"/me/friends?limit=1000&locale=ko_KR" parameters:nil HTTPMethod:@"GET" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (error) {
            NSLog(@"InnoAuth-Facebook : Get Friends Use This App Error!!!!");
            [reflector requestFriendsdUseThisAppComplete:InnoAuthTypeFaceBook result:nil];
        } else {
            NSError *err;
            NSData* jsonData = [NSJSONSerialization dataWithJSONObject:result options:NSJSONWritingPrettyPrinted error:&err];
            NSString* fullStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSLog(@"InnoAuth-Facebook : Get Friends Use This App OK!!!!");
            [reflector requestFriendsdUseThisAppComplete:InnoAuthTypeFaceBook result:fullStr];
        }
    }];
}

- (void) testRequest {
    [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error && result) {
            NSDictionary<FBGraphUser>* dic = result;
            NSString* firstName = [[NSString alloc] initWithString:dic.first_name];
            NSString* userID = dic.objectID;
            NSString* logStr = [[NSString alloc] initWithFormat:@"requestForMe result\nUser ID : %@\nName : %@", userID, firstName];
            [self showMessage:logStr withTitle:@"ALERT!"];
        }
    }];
}

- (void) testRequest2 {
    [FBRequestConnection startForMyFriendsWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error && result) {
            NSArray* fetchedFriendData = [[NSArray alloc] initWithArray:[result objectForKey:@"data"]];
            NSLog(@"My Friends count is %d", (unsigned int)fetchedFriendData.count);
            for (int i = 0; i < fetchedFriendData.count; i++) {
                NSDictionary* friendData = [fetchedFriendData objectAtIndex:i];
                NSString* friendID = [friendData objectForKey:@"id"];
                NSString* friendName = [friendData objectForKey:@"first_name"];
                NSLog(@"index %i : ID[%@] Name[%@]", i, friendID, friendName);
            }
        }
    }];
}

- (void) testRequest3 {
    [FBRequestConnection startWithGraphPath:@"/me/invitable_friends?locale=ko_KR" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error && result) {
            NSArray* fetchedFriendData = [[NSArray alloc] initWithArray:[result objectForKey:@"data"]];
            NSLog(@"My Invitable Friends count is %d", (unsigned int)fetchedFriendData.count);
            for (int i = 0; i < fetchedFriendData.count; i++) {
                NSDictionary* friendData = [fetchedFriendData objectAtIndex:i];
                NSString* friendID = [friendData objectForKey:@"id"];
                NSString* friendName = [friendData objectForKey:@"first_name"];
                NSLog(@"index %i : ID[%@] Name[%@]", i, friendID, friendName);
            }
        } else {
            [self showMessage:[error description] withTitle:@"ALERT!"];
        }
    }];
}

- (void) shareWithLink:(NSString*)linkUrl title:(NSString*)title caption:(NSString*)caption desc:(NSString*)desc picture:(NSString*) picUrl {
    FBLinkShareParams* params = [[FBLinkShareParams alloc] init];
    if (linkUrl != nil) {
        params.link = [NSURL URLWithString:linkUrl];
    }
    if (title != nil) {
        params.name = title;
    }
    if (caption != nil) {
        params.caption = caption;
    }
    if (desc != nil) {
        params.linkDescription = desc;
    }
    if (picUrl != nil) {
        params.picture = [NSURL URLWithString:picUrl];
    }
    
    if ([FBDialogs canPresentShareDialogWithParams:params]) {
        [FBDialogs presentShareDialogWithLink:params.link handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
            if (error) {
                [self showMessage:[[NSString alloc] initWithFormat:@"Error publishing story : %@", error.description] withTitle:@"ERROR!"];
            } else {
                NSLog(@"Success publishing story : %@", results);
            }
        }];
    } else {
        NSMutableDictionary *testParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                           title == nil ? @"" : title, @"name",
                                           caption == nil ? @"" : caption, @"caption",
                                           desc == nil ? @"" : desc, @"description",
                                           linkUrl == nil ? @"" : linkUrl, @"link",
                                           picUrl == nil ? @"" : picUrl, @"picture",
                                           nil];
        
        [FBWebDialogs presentFeedDialogModallyWithSession:nil parameters:testParams handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
            if (error) {
                [self showMessage:[[NSString alloc] initWithFormat:@"Error publishing story : %@", error.description] withTitle:@"ERROR!"];
            } else {
                if (result == FBWebDialogResultDialogNotCompleted) {
                    NSLog(@"User cancelled. - 1");
                } else {
                    NSDictionary* urlParams = [self parseURLParams:[resultURL query]];
                    
                    if (![urlParams valueForKey:@"post_id"]) {
                        NSLog(@"User cancelled. - 2");
                    } else {
                        NSString* logStr = [NSString stringWithFormat: @"Posted story, id: %@", [urlParams valueForKey:@"post_id"]];
                        NSLog(@"Result : %@", logStr);
                    }
                }
            }
        }];
    }
    
}

- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error
{
    // If the session was opened successfully
    if (!error && state == FBSessionStateOpen){
        NSLog(@"Session opened");
        // Show the user the logged-in UI
        fbSession = session;
        [self userLoggedIn];
        return;
    }
    if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed){
        // If the session is closed
        NSLog(@"Session closed");
        // Show the user the logged-out UI
        fbSession = nil;
        [self userLoggedOut];
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
            [self showMessage:alertText withTitle:alertTitle];
        } else {
            
            // If the user cancelled login, do nothing
            if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
                NSLog(@"User cancelled login");
                
                // Handle session closures that happen outside of the app
            } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession){
                alertTitle = @"Session Error";
                alertText = @"Your current session is no longer valid. Please log in again.";
                [self showMessage:alertText withTitle:alertTitle];
                
                // For simplicity, here we just show a generic message for all other errors
                // You can learn how to handle other errors using our guide: https://developers.facebook.com/docs/ios/errors
            } else {
                //Get more error information from the error
                NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"];
                
                // Show the user an error message
                alertTitle = @"Something went wrong";
                alertText = [NSString stringWithFormat:@"Please retry. \n\n If the problem persists contact us and mention this error code: %@", [errorInformation objectForKey:@"message"]];
                [self showMessage:alertText withTitle:alertTitle];
            }
        }
        // Clear this token
        [FBSession.activeSession closeAndClearTokenInformation];
        // Show the user the logged-out UI
        [self userLoggedOut];
    }
}

- (void)showMessage:(NSString *)text withTitle:(NSString *)title
{
    [[[UIAlertView alloc] initWithTitle:title
                                message:text
                               delegate:self
                      cancelButtonTitle:@"OK!"
                      otherButtonTitles:nil] show];
}

- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val = [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}


@end
