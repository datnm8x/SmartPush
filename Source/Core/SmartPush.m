//
//  SmartPush.m
//  SmartPush Framework
//
//  Created by Dat Ng on 16/02/2022.
//  Copyright © 2022 Nguyen Mau Dat. All rights reserved.
//

#import "SmartPush.h"
#import "ioSock.h"
#import "SecManager.h"
#import "NetworkManager.h"

#define Push_Developer  "api.sandbox.push.apple.com"
#define Push_Production  "api.push.apple.com"

@interface APNSClient() {
  
  otSocket socket;
  OSStatus _connectResult;
  OSStatus _closeResult;
  
  SSLContextRef _context;
  Sec *_currentSec;
  SecIdentityRef _identity;
}

@end

@implementation APNSClient

+ (instancetype) shared {
  static dispatch_once_t pred = 0;
  static id _sharedObject = nil;
  dispatch_once(&pred, ^{
    _sharedObject = [[self alloc] init];
  });
  return _sharedObject;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    _connectResult = -50;
    _closeResult = -50;
  }
  return self;
}

- (BOOL)connectCertificate:(NSString*)cerPath pass:(NSString*)pass {
  if (_connectResult != -50 && [_currentSec.path isEqualToString:cerPath]) { return true; }
  
  // Load identity.
  _identity = (__bridge SecIdentityRef)([SecManager identityWithFile:cerPath password:pass error:NULL]);
  if (_identity == NULL) {
    return NO;
  }
  
  SecCertificateRef secRef =  (__bridge SecCertificateRef)([SecManager certificateWithIdentity:(__bridge LHSecIdentityRef)(_identity) error:NULL]);
  if ([SecManager isPushCertificate:secRef]) {
    if (secRef) {
      
      _currentSec = [SecManager secModelWithRef:secRef];
      _currentSec.path = cerPath;
      [self resetConnect];
      // Set client certificate.
      CFArrayRef certificates = CFArrayCreate(NULL, (const void **)&_identity, 1, NULL);
      _connectResult = SSLSetCertificate(_context, certificates);
      // NSLog(@"SSLSetCertificate(): %d", result);
      CFRelease(certificates);
      
      [[NetworkManager sharedManager] setIdentity:_identity];
      return YES;
    }
    return NO;
  }else{
    return NO;
  }
}

- (void)resetConnect{
  _connectResult = -50;
  [self disconnect];
}

- (void)disconnect {
  NSLog(@"disconnect");
  // OSStatus result;
  
  // NSLog(@"SSLClose(): %d", _closeResult);
  if (_closeResult != 0) {
    return;
  }
  // 关闭SSL会话
  _closeResult = SSLClose(_context);
  //NSLog(@"SSLClose(): %d", _closeResult);
  
  // Release identity.
  if (_identity != NULL)
    CFRelease(_identity);
  
  //    // Release certificate.
  //    if (_currentSec.certificateRef != NULL)
  //        CFRelease(_currentSec.certificateRef);
  
  // Close connection to server.
  close((int)socket);
  
  // Delete SSL context.
  CFRelease(_context);
  // NSLog(@"SSLDisposeContext(): %d", result);
  
}

+ (void)sendPush:(NSString *)payload
         toToken:(NSString *)token
           topic:(nullable NSString *)topic
        priority:(NSUInteger)priority
      collapseID:(NSString *)collapseID
        pushType:(NSString*)pushType
       inSandbox:(BOOL)sandbox
      exeSuccess:(void(^)(BOOL result))exeSuccess
       exeFailed:(void(^)(NSString *error))exeFailed {
  [[NetworkManager sharedManager] postWithPayload: payload
                                          toToken: token
                                        withTopic: topic
                                         priority: priority
                                       collapseID: collapseID
                                         pushType: pushType
                                        inSandbox: sandbox
                                       exeSuccess: exeSuccess
                                        exeFailed: exeFailed
  ];
}

@end

