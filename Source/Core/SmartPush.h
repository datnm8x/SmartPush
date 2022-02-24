//
//  SmartPush.h
//  SmartPush Framework
//
//  Created by Dat Ng on 16/02/2022.
//  Copyright © 2022 Nguyen Mau Dat. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface APNSClient : NSObject

+ (instancetype) shared;

- (BOOL)connectCertificate:(NSString*)cerPath pass:(NSString*)pass;
- (void)disconnect;

+ (void)sendPush:(NSString *)payload toToken:(NSString *)token topic:(nullable NSString *)topic priority:(NSUInteger)priority collapseID:(NSString *)collapseID pushType:(NSString*)pushType inSandbox:(BOOL)sandbox exeSuccess:(void(^)(BOOL result))exeSuccess exeFailed:(void(^)(NSString *error))exeFailed;

@end

NS_ASSUME_NONNULL_END

