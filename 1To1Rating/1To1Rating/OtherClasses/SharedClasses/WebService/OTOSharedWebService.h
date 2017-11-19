//
//  OTOSharedWebService.h
//  1To1Rating
//
//  Created by Saurabh Vaza on 21/08/17.
//  Copyright © 2017 Saurabh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OTOSharedWebService : NSObject<NSURLSessionDelegate>
{
    
}

@property (nonatomic, strong) NSMutableDictionary * _Nullable mutDictTodayQuestion, * _Nullable mutDictTodayHistory, * _Nullable mutDictAllQuestionHistory;

@property (nonatomic, strong) NSMutableArray * _Nullable mutArrQuestionList;


+(OTOSharedWebService*_Nullable)sharedManager;

- (void)apiCallWithUrl:(NSString * _Nonnull)aStrUrl method:(NSString * _Nonnull)aStrMethod parameter:( NSMutableDictionary * _Nullable )aMutDictParam
     completionHandler:(void (^_Nullable)(NSURLResponse * _Nullable response, id _Nullable responseObject, NSError * _Nullable error))completionHandler;

@end
