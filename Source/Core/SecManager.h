//
//  SecManager.h
//  SmartPush Framework
//
//  Created by Dat Ng on 16/02/2022.
//  Copyright © 2022 Nguyen Mau Dat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Sec : NSObject
@property (nonatomic) SecCertificateRef certificateRef;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *key;
@property (nonatomic,copy) NSString *topicName;

@property (nonatomic,strong) NSDate *date;
@property (nonatomic,copy)   NSString *expire;
@property (nonatomic,assign)  BOOL fromFile;
@property (nonatomic,copy) NSString *path;
@end


/** An ARC-friendly replacement of SecIdentityRef. */
typedef id LHSecIdentityRef;

/** An ARC-friendly replacement of SecCertificateRef. */
typedef id LHCertificateRef;

/** An ARC-friendly replacement of SecKeyRef. */
typedef id LHSecKeyRef;

@interface SecManager : NSObject
+ (NSArray *)allPushCertificatesWithEnvironment:(BOOL)isDevelop;
+ (SecCertificateRef)certificatesWithPath:(NSString*)path;
+ (BOOL)isPushCertificate:(SecCertificateRef)sec;
+ (NSString *)subjectSummaryWithCertificate:(SecCertificateRef)certificate;
#if !TARGET_OS_IPHONE
+ (NSDate *)expirationWithCertificate:(SecCertificateRef)certificate;
#endif
+ (NSArray *)allKeychainCertificatesWithError:(NSError *__autoreleasing *)error;
+ (Sec*)secModelWithRef:(SecCertificateRef)sec;

+ (LHSecIdentityRef)identityWithFile:(NSString *)filePath password:(NSString *)password error:(NSError *__autoreleasing *)error;
+ (LHSecIdentityRef)identityWithPKCS12Data:(NSData *)pkcs12 password:(NSString *)password error:(NSError *__autoreleasing *)error;
+ (NSArray *)identitiesWithPKCS12Data:(NSData *)pkcs12 password:(NSString *)password error:(NSError *__autoreleasing *)error;
+ (NSArray *)allIdentitiesWithPKCS12Data:(NSData *)data password:(NSString *)password error:(NSError *__autoreleasing *)error;
+ (LHCertificateRef)certificateWithIdentity:(LHSecIdentityRef)identity error:(NSError *__autoreleasing *)error;
+ (LHSecKeyRef)keyWithIdentity:(LHSecIdentityRef)identity error:(NSError *__autoreleasing *)error;

@end
