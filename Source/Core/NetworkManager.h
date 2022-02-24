//
//  NetworkManager.h
//  SmartPush Framework
//
//  Created by Dat Ng on 16/02/2022.
//  Copyright © 2022 Nguyen Mau Dat. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NetworkManager : NSObject
@property (nonatomic, strong, nullable) __attribute__((NSObject)) SecIdentityRef identity;

+ (NetworkManager*)sharedManager;
//https://developer.apple.com/documentation/usernotifications/setting_up_a_remote_notification_server/sending_notification_requests_to_apns?language=objc
- (void)postWithPayload:(NSString *)payload
                toToken:(NSString *)token
              withTopic:(nullable NSString *)topic
               priority:(NSUInteger)priority
             collapseID:(NSString *)collapseID
               pushType:(NSString *)pushType
              inSandbox:(BOOL)sandbox
             exeSuccess:(void(^)(BOOL result))exeSuccess
              exeFailed:(void(^)(NSString *error))exeFailed;
- (void)disconnect;

@end

NS_ASSUME_NONNULL_END

