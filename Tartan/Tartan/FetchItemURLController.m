//
//  FetchItemURLController.m
//  Tartan Today
//
//  Created by Smith, Donnie on 2017/10/20.
//  Copyright © 2017 Rakuten. All rights reserved.
//

#import "FetchItemURLController.h"

@implementation FetchItemURLController

+ (void)fetchItemURLForItemString:(NSString *)item completionHandler:(void (^)(NSURL *, NSError *))completionHandler
{
    static NSCharacterSet *RFC3986UnreservedCharacters = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // See https://www.ietf.org/rfc/rfc3986.txt section 2.2 and 3.4
        NSString *RFC3986ReservedCharacters = @":#[]@!$&'()*+,;=";
        
        NSMutableCharacterSet *unreservedCharacters = [[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
        [unreservedCharacters removeCharactersInString:RFC3986ReservedCharacters];
        
        RFC3986UnreservedCharacters = [unreservedCharacters copy];
    });
    
    NSString *prefix = @"https://24x7.app.rakuten.co.jp/engine/api/IchibaItem/Search/20170706?applicationId=1009991226632350742&keyword=";
    NSString *escapedItemString = [item stringByAddingPercentEncodingWithAllowedCharacters:RFC3986UnreservedCharacters];
    NSString *itemURLString = [prefix stringByAppendingString:escapedItemString];
    
    NSURLSession *session = NSURLSession.sharedSession;
    [[session dataTaskWithURL:[NSURL URLWithString:itemURLString] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error)
        {
            completionHandler(nil, error);
            return;
        }
        
        NSURL *itemURL = nil;
        if (data && [response isKindOfClass:NSHTTPURLResponse.class])
        {
            itemURL = [self itemURLFromData:data];
        }
        completionHandler(itemURL, error);
    }] resume];
}

+ (NSURL *)itemURLFromData:(NSData *)data
{
    do
    {
        /*
         * Parsing starts here.
         */
        if (![data isKindOfClass:NSData.class] || !data.length) break;
        
        NSDictionary *values = [NSJSONSerialization JSONObjectWithData:data options:0 error:0];
        if (![values isKindOfClass:NSDictionary.class]) break;
        
        NSString *itemCode = nil;
        
        NSDictionary *item = [values[@"Items"] firstObject];
        if (!item) break;
        
        itemCode = item[@"Item"][@"itemCode"];
        if (!itemCode) break;

        NSString *itemURLString = [NSBundle.mainBundle objectForInfoDictionaryKey:@"IchibaShoppingPrefixURL"];
        if (!itemURLString.length) break;
        
        return [NSURL URLWithString:itemURLString];
    } while(0);
    
    return nil; // invalid object
}

@end
