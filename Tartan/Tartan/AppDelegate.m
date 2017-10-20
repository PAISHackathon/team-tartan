//
//  AppDelegate.m
//  Tartan
//
//  Created by Ta, Viet | Vito | GHRD on 10/20/17.
//  Copyright © 2017 Rakuten. All rights reserved.
//

#import "AppDelegate.h"
#import "SpeechRecognitionController.h"
#import "FetchItemURLController.h"

@interface AppDelegate ()
@property (nonatomic) UIAlertController *alert;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    NSLog(@"UIApplicationLaunchOptionsURLKey %@",[launchOptions objectForKey:UIApplicationLaunchOptionsURLKey]);
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
{
    NSLog(@"url: %@", url);
    
    if ([url.absoluteString isEqualToString:@"tartanapp://speech-search"])
    {
        [self _speechSearch];
    }
    else if ([url.absoluteString isEqualToString:@"tartanapp://speech-search"])
    {
    }
    else if ([url.absoluteString isEqualToString:@"tartanapp://photo-search"])
    {
    }

    return YES;
}

- (void)_speechSearch
{
    _alert = [UIAlertController alertControllerWithTitle:@"Shopping search" message:@"Feeling lucky punk?\n\nSay what item you want to buy..." preferredStyle:UIAlertControllerStyleAlert];
    [self.window.rootViewController presentViewController:_alert animated:NO completion:nil];
    
    SpeechRecognitionController *speechRecog = [SpeechRecognitionController.alloc initSpeechRecognition];
    [speechRecog recordWithCompletionHandler:^(NSString *speechString, NSError *error) {
        
        [self.window.rootViewController dismissViewControllerAnimated:NO completion:nil];
        
        if (error)
        {
            NSLog(@"Error %@", error);
        }
        else
        {
            [self _openItemURLForItem:speechString];
        }
    }];
}

- (void)_openItemURLForItem:(NSString *)item
{
    [FetchItemURLController fetchItemURLForItemString:item completionHandler:^(NSURL *itemURL, NSError *error) {

        if (error)
        {
            NSLog(@"Error %@", error);
        }
        else
        {
            Class UIApplicationClass = NSClassFromString(@"UIApplication");
            UIApplication *sharedApp = [UIApplicationClass sharedApplication];

            if (sharedApp)
            {
                [sharedApp performSelectorOnMainThread:NSSelectorFromString(@"openURL:") withObject:itemURL waitUntilDone:NO];
            }
        }
    }];
}
@end
