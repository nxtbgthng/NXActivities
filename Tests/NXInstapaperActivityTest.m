//
//  NXInstapaperActivityTest.m
//  NXActivities
//
//  Created by Thomas Kollbach on 12.10.12.
//  Copyright (c) 2012 nxtbgthng. All rights reserved.
//

#import "NXInstapaperActivity.h"
#import "NXInstapaperActivityTest.h"

@implementation NXInstapaperActivityTest

- (void)testSavingCredentials;
{
    BOOL result = [NXInstapaperActivity storeAccountWithUsername:@"user" password:@"pass"];
    STAssertTrue(result, nil);
    
    STAssertEqualObjects([NXInstapaperActivity username], @"user", nil);
    STAssertEqualObjects([NXInstapaperActivity password], @"pass", nil);
}

- (void)testAccountRemova;
{
    BOOL result = [NXInstapaperActivity storeAccountWithUsername:@"user" password:@"pass"];
    STAssertTrue(result, nil);
    
    STAssertTrue([NXInstapaperActivity removeAccount], nil);
    STAssertNil([NXInstapaperActivity username], nil);
    STAssertNil([NXInstapaperActivity password], nil);
    
}

@end
