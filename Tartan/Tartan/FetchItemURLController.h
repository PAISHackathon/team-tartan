//
//  FetchItemURLController.h
//  Tartan Today
//
//  Created by Smith, Donnie on 2017/10/20.
//  Copyright © 2017 Rakuten. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FetchItemURLController : NSObject

+ (void)fetchItemURLForItemString:(NSString *)item completionHandler:(void (^)(NSURL *, NSError *))completionHandler;

@end
