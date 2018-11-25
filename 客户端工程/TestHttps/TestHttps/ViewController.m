//
//  ViewController.m
//  TestHttps
//
//  Created by wanghongyu on 25/11/2018.
//  Copyright © 2018 TestHttps. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self test];
}

-(void) test{
    //服务端自签名证书代码
   AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"https://127.0.0.1:3000"]];
   AFSecurityPolicy *policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
   policy.validatesDomainName = NO;
   policy.allowInvalidCertificates = YES;
   policy.pinnedCertificates = [AFSecurityPolicy certificatesInBundle:[NSBundle mainBundle]];
    
    //服务端CA正式证书代码
    // AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    // AFSecurityPolicy *policy = [AFSecurityPolicy defaultPolicy];
    // policy.validatesDomainName = NO;
    
    manager.securityPolicy = policy;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:@"https://127.0.0.1:3000/" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"succ and response = [%@]", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"fail for error %@", error);
    }];
}


@end
