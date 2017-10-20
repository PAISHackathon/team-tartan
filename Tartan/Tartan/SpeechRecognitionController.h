//
//  SpeechRecognitionController.h
//  Tartan
//
//  Created by Smith, Donnie on 2017/10/20.
//  Copyright © 2017 Rakuten. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SpeechRecognitionController : NSObject

- (instancetype)initSpeechRecognition;
- (void)recordWithCompletionHandler:(void (^)(NSString *, NSError *))completionHandler;

@end
