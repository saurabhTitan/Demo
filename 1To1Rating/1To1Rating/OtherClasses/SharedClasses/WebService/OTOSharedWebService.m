//
//  OTOSharedWebService.m
//  1To1Rating
//
//  Created by Saurabh Vaza on 21/08/17.
//  Copyright © 2017 Saurabh. All rights reserved.
//

#import "OTOSharedWebService.h"
#import "AFNetworking.h"

#import <Foundation/Foundation.h>

@implementation OTOSharedWebService

@synthesize mutArrQuestionList,mutDictAllQuestionHistory,mutDictTodayHistory,mutDictTodayQuestion;

static OTOSharedWebService* sharedMyWS = nil;

+(OTOSharedWebService*_Nullable)sharedManager
{
    @synchronized([OTOSharedWebService class])
    {
        if (!sharedMyWS)
            sharedMyWS = [[self alloc] init];
        
        return sharedMyWS;
    }
    
    return nil;
}

#pragma mark -----------
#pragma mark

- (void)apiCallWithUrl:(NSString * _Nonnull)aStrUrl method:(NSString * _Nonnull)aStrMethod parameter:( NSMutableDictionary * _Nullable )aMutDictParam completionHandler:(void (^_Nullable)(NSURLResponse * _Nullable response, id _Nullable responseObject, NSError * _Nullable error))completionHandler{
//    NSError *aerror;
    
    @try {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
        NSURL *url = [NSURL URLWithString:aStrUrl];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                           timeoutInterval:600.0];
        
        [request addValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        //    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
        
        [request setHTTPMethod:aStrMethod];
        
        NSLog(@"Request : %@",aMutDictParam);
        
        NSString *aStrParam = [[OTOGeneralSharedManager sharedManager] getStringFromDict:aMutDictParam];
        
        NSData *postData = [aStrParam dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:postData];
        
        
        NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            NSError *aEr;
            
            NSMutableDictionary *aMutDict = [NSMutableDictionary dictionary];
            
            if (data) {
                aMutDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&aEr];
            }
            
            if (error) {
                NSLog(@"Error: %@", error);
            } else {
                NSLog(@"%@", aMutDict);
            }
            
            completionHandler(nil,aMutDict,error);
            
            
        }];
        
        [postDataTask resume];
    } @catch (NSException *exception) {
        NSLog(@"Class:: %s Exception :: %@",__func__,exception.description);
    } @finally {
        
    }
}


@end
