//
//  CardKitCoreTests.m
//  CardKitCoreTests
//
//  Created by Alex Korotkov on 11/12/20.
//  Copyright © 2020 AnjLab. All rights reserved.
//
#import <XCTest/XCTest.h>
#import "CKCToken.h"
#import "CKCTokenResult.h"
#import "CKCBindingParams.h"
#import "CKCCardParams.h"
#import "CKCPubKey.h"

@interface CardKitCoreTests : XCTestCase

@end

@implementation CardKitCoreTests {
    CKCCardParams *cardParams;
    CKCBindingParams *bindingParams;
}

- (void)setUp {
    cardParams = [[CKCCardParams alloc] init];
    cardParams.cardholder=@"Korotkov Alex";
    cardParams.expiryMMYY=@"1222";
    cardParams.pan=@"5536913776755304";
    cardParams.cvc = @"123";
    cardParams.mdOrder = @"mdorder";
    cardParams.pubKey = @"-----BEGIN PUBLIC KEY-----MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAp04PhwMu5k3fRMRmAb1ZRxbD3brU4a7oKa4NDlGXKQJiCEuw6e8SYcYW2i4rt0WsieeRRrrX7VnUZ2pH20lMtUnrTUtw2MaH5Ta9c3begST7sFkqU3t22BYedtamLGR5y55C5GWwI0Ie9ozecSckqcLW7KVITNT4GXME+Q1lFWYMGwr66vhu1fIV1pfVNWvMX3lEzVLwmwPkt0gf2ODR+AfO8rg17P4z4BHN/jSL0maOFsJlriCEf11jqtVbJKz5EDghyFO9Iw+gzorwlioc133li1OG0NbKzK/Nq5z29udoEWneisp3ub5M53jWvxDNiVl8uvPUfxyz+86mwNQ87QIDAQAB-----END PUBLIC KEY-----";
    
    
    bindingParams = [[CKCBindingParams alloc] init];
    bindingParams.bindingID = @"das";
    bindingParams.cvc = @"123";
    bindingParams.mdOrder = @"mdOrder";
    bindingParams.pubKey = @"-----BEGIN PUBLIC KEY-----MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAp04PhwMu5k3fRMRmAb1ZRxbD3brU4a7oKa4NDlGXKQJiCEuw6e8SYcYW2i4rt0WsieeRRrrX7VnUZ2pH20lMtUnrTUtw2MaH5Ta9c3begST7sFkqU3t22BYedtamLGR5y55C5GWwI0Ie9ozecSckqcLW7KVITNT4GXME+Q1lFWYMGwr66vhu1fIV1pfVNWvMX3lEzVLwmwPkt0gf2ODR+AfO8rg17P4z4BHN/jSL0maOFsJlriCEf11jqtVbJKz5EDghyFO9Iw+gzorwlioc133li1OG0NbKzK/Nq5z29udoEWneisp3ub5M53jWvxDNiVl8uvPUfxyz+86mwNQ87QIDAQAB-----END PUBLIC KEY-----";
}

- (void)tearDown {
}

- (void)testGenerateTokenWithBinding {
    CKCTokenResult *res = [CKCToken generateWithBinding:(bindingParams)];

    XCTAssertNotNil(res.token, @"pointer:%p", res.token);
}

- (void)testGenerateTokenWithoutBindingID {
    bindingParams.bindingID=@"";
    NSDictionary *expectedResponse = @{@"field": CKCFieldBindingID, @"error": CKCErrorRequired};
    CKCTokenResult *res = [CKCToken generateWithBinding:(bindingParams)];
    
    XCTAssertEqualObjects(res.errors[0], expectedResponse);
}

- (void)testGenerateTokenWithNilBindingID {
    bindingParams.bindingID=nil;
    NSDictionary *expectedResponse = @{@"field": CKCFieldBindingID, @"error": CKCErrorRequired};
    CKCTokenResult *res = [CKCToken generateWithBinding:(bindingParams)];
    
    XCTAssertEqualObjects(res.errors[0], expectedResponse);
}

- (void)testGenerateTokenWithNilCVC {
    bindingParams.cvc=nil;
    CKCTokenResult *res = [CKCToken generateWithBinding:(bindingParams)];
    
    XCTAssertNotNil(res.token, @"pointer:%p", res.token);
}

- (void)testGenerateTokenWithCard {
    CKCTokenResult *res = [CKCToken generateWithCard:cardParams];

    XCTAssertNotNil(res.token, @"pointer:%p", res.token);
}

- (void)testGenerateTokenWithCardWithoutCardholder {
    cardParams.cardholder=@"";
    CKCTokenResult *res = [CKCToken generateWithCard:cardParams];
    NSDictionary *expectedResponse = @{@"field": CKCFieldCardholder, @"error": CKCErrorRequired};
    
    XCTAssertEqualObjects(res.errors[0], expectedResponse);
}

- (void)testGenerateTokenWithCardWithNilCardholder {
    cardParams.cardholder=nil;
    CKCTokenResult *res = [CKCToken generateWithCard:cardParams];
    NSDictionary *expectedResponse = @{@"field": CKCFieldCardholder, @"error": CKCErrorRequired};

    XCTAssertEqualObjects(res.errors[0], expectedResponse);
}

- (void)testGenerateTokenWithCardWithNumbersCardholder {
    cardParams.cardholder=@"1223324";
    CKCTokenResult *res = [CKCToken generateWithCard:cardParams];
    NSDictionary *expectedResponse = @{@"field": CKCFieldCardholder, @"error": CKCErrorInvalidFormat};
    
    XCTAssertEqualObjects(res.errors[0], expectedResponse);
}

- (void)testGenerateTokenWithCardWithoutExpiryMMYY {
    cardParams.expiryMMYY=@"";
    CKCTokenResult *res = [CKCToken generateWithCard:cardParams];
    NSDictionary *expectedResponse = @{@"field": CKCFieldExpiryMMYY, @"error": CKCErrorRequired};
    
    XCTAssertEqualObjects(res.errors[0], expectedResponse);
}

- (void)testGenerateTokenWithCardWithNilExpiryMMYY {
    cardParams.expiryMMYY=nil;
    CKCTokenResult *res = [CKCToken generateWithCard:cardParams];
    NSDictionary *expectedResponse = @{@"field": CKCFieldExpiryMMYY, @"error": CKCErrorRequired};

    XCTAssertEqualObjects(res.errors[0], expectedResponse);
}

- (void)testGenerateTokenWithCardWithInvalidExpiryMMYY {
    cardParams.expiryMMYY=@"222/2";
    CKCTokenResult *res = [CKCToken generateWithCard:cardParams];
    NSDictionary *expectedResponse = @{@"field": CKCFieldExpiryMMYY, @"error": CKCErrorInvalidFormat};

    XCTAssertEqualObjects(res.errors[0], expectedResponse);
}

- (void)testGenerateTokenWithCardWithNilPan {
    cardParams.pan=nil;
    CKCTokenResult *res = [CKCToken generateWithCard:cardParams];
    NSDictionary *expectedResponse = @{@"field": CKCFieldPan, @"error": CKCErrorRequired};

    XCTAssertEqualObjects(res.errors[0], expectedResponse);
}

- (void)testGenerateTokenWithCardWithoutPan {
    cardParams.pan=@"";
    CKCTokenResult *res = [CKCToken generateWithCard:cardParams];
    NSDictionary *expectedResponse = @{@"field": CKCFieldPan, @"error": CKCErrorRequired};

    XCTAssertEqualObjects(res.errors[0], expectedResponse);
}

- (void)testGenerateTokenWithCardWithLettersPan {
    cardParams.pan=@"qwertyuiopasdfghjk";
    CKCTokenResult *res = [CKCToken generateWithCard:cardParams];
    NSDictionary *expectedResponse = @{@"field": CKCFieldPan, @"error": CKCErrorInvalidFormat};

    XCTAssertEqualObjects(res.errors[0], expectedResponse);
}

- (void)testGenerateTokenWithCardWithSmallPan {
    cardParams.pan=@"1232131231321";
    CKCTokenResult *res = [CKCToken generateWithCard:cardParams];
    NSDictionary *expectedResponse = @{@"field": CKCFieldPan, @"error": CKCErrorInvalidLength};

    XCTAssertEqualObjects(res.errors[0], expectedResponse);
}

- (void)testGenerateTokenWithCardWithInvalidPan {
    cardParams.pan=@"123456789012345678";
    CKCTokenResult *res = [CKCToken generateWithCard:cardParams];
    NSDictionary *expectedResponse = @{@"field": CKCFieldPan, @"error": CKCErrorInvalidFormat};

    XCTAssertEqualObjects(res.errors[0], expectedResponse);
}

- (void)testGenerateTokenWithCardWithoutCVC {
    cardParams.cvc=@"";
    CKCTokenResult *res = [CKCToken generateWithCard:cardParams];
    NSDictionary *expectedResponse = @{@"field": CKCFieldCVC, @"error": CKCErrorRequired};

    XCTAssertEqualObjects(res.errors[0], expectedResponse);
}

- (void)testGenerateTokenWithCardNilCVC {
    cardParams.cvc=nil;
    CKCTokenResult *res = [CKCToken generateWithCard:cardParams];
    NSDictionary *expectedResponse = @{@"field": CKCFieldCVC, @"error": CKCErrorRequired};

    XCTAssertEqualObjects(res.errors[0], expectedResponse);
}

- (void)testGenerateTokenWithCardWithInvalidCVC {
    cardParams.cvc=@"adsa";
    CKCTokenResult *res = [CKCToken generateWithCard:cardParams];
    NSDictionary *expectedResponse = @{@"field": CKCFieldCVC, @"error": CKCErrorInvalidFormat};

    XCTAssertEqualObjects(res.errors[0], expectedResponse);
}

- (void)testGenerateTokenWithCardWithLargeCVC {
    cardParams.cvc=@"1234";
    CKCTokenResult *res = [CKCToken generateWithCard:cardParams];
    NSDictionary *expectedResponse = @{@"field": CKCFieldCVC, @"error": CKCErrorInvalidFormat};

    XCTAssertEqualObjects(res.errors[0], expectedResponse);
}

- (void)testGenerateTokenWithCardWithShortCVC {
    cardParams.cvc=@"14";
    CKCTokenResult *res = [CKCToken generateWithCard:cardParams];
    NSDictionary *expectedResponse = @{@"field": CKCFieldCVC, @"error": CKCErrorInvalidFormat};

    XCTAssertEqualObjects(res.errors[0], expectedResponse);
}

- (void)testGenerateTokenWithCardWithInvalidPubKey {
    cardParams.pubKey = @"adadskmaaklasd";
    CKCTokenResult *res = [CKCToken generateWithCard:cardParams];
    NSDictionary *expectedResponse = @{@"field": CKCFieldPubKey, @"error": CKCErrorInvalid};

    XCTAssertEqualObjects(res.errors[0], expectedResponse);
}

- (void)testGenerateTokenWithCardWithoutPubKey {
    cardParams.pubKey =@"";
    CKCTokenResult *res = [CKCToken generateWithCard:cardParams];
    NSDictionary *expectedResponse = @{@"field": CKCFieldPubKey, @"error": CKCErrorRequired};

    XCTAssertEqualObjects(res.errors[0], expectedResponse);
}

- (void)testGenerateTokenWithCardWithNilPubKey {
    cardParams.pubKey = nil;
    CKCTokenResult *res = [CKCToken generateWithCard:cardParams];
    NSDictionary *expectedResponse = @{@"field": CKCFieldPubKey, @"error": CKCErrorRequired};

    XCTAssertEqualObjects(res.errors[0], expectedResponse);
}

- (void)testGenerateTokenWithCardWithoutMdOrder {
    cardParams.mdOrder =@"";
    CKCTokenResult *res = [CKCToken generateWithCard:cardParams];
    NSDictionary *expectedResponse = @{@"field": CKCFieldMdOrder, @"error": CKCErrorRequired};

    XCTAssertEqualObjects(res.errors[0], expectedResponse);
}

- (void)testGenerateTokenWithCardWithNilMdOrder {
    cardParams.mdOrder = nil;
    CKCTokenResult *res = [CKCToken generateWithCard:cardParams];
    NSDictionary *expectedResponse = @{@"field": CKCFieldMdOrder, @"error": CKCErrorRequired};

    XCTAssertEqualObjects(res.errors[0], expectedResponse);
}

- (void)testReturnPubKeyFromJSONString {
    NSString *pubKey = @"-----BEGIN PUBLIC KEY-----MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAhjH8R0jfvvEJwAHRhJi2Q4fLi1p2z10PaDMIhHbD3fp4OqypWaE7p6n6EHig9qnwC/4U7hCiOCqY6uYtgEoDHfbNA87/X0jV8UI522WjQH7Rgkmgk35r75G5m4cYeF6OvCHmAJ9ltaFsLBdr+pK6vKz/3AzwAc/5a6QcO/vR3PHnhE/qU2FOU3Vd8OYN2qcw4TFvitXY2H6YdTNF4YmlFtj4CqQoPL1u/uI0UpsG3/epWMOk44FBlXoZ7KNmJU29xbuiNEm1SWRJS2URMcUxAdUfhzQ2+Z4F0eSo2/cxwlkNA+gZcXnLbEWIfYYvASKpdXBIzgncMBro424z/KUr3QIDAQAB-----END PUBLIC KEY-----";
    NSString *jsonString = @"{\"keys\":[{\"keyValue\":\"-----BEGIN PUBLIC KEY-----MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAhjH8R0jfvvEJwAHRhJi2Q4fLi1p2z10PaDMIhHbD3fp4OqypWaE7p6n6EHig9qnwC/4U7hCiOCqY6uYtgEoDHfbNA87/X0jV8UI522WjQH7Rgkmgk35r75G5m4cYeF6OvCHmAJ9ltaFsLBdr+pK6vKz/3AzwAc/5a6QcO/vR3PHnhE/qU2FOU3Vd8OYN2qcw4TFvitXY2H6YdTNF4YmlFtj4CqQoPL1u/uI0UpsG3/epWMOk44FBlXoZ7KNmJU29xbuiNEm1SWRJS2URMcUxAdUfhzQ2+Z4F0eSo2/cxwlkNA+gZcXnLbEWIfYYvASKpdXBIzgncMBro424z/KUr3QIDAQAB-----END PUBLIC KEY-----\",\"protocolVersion\":\"RSA\",\"keyExpiration\":1661599747000}]}";

    NSString *result = [CKCPubKey fromJSONString: jsonString];


    XCTAssertTrue([result isEqualToString:pubKey]);
}

- (void)testTimestampforDate {
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:1];
    [dateComponents setMonth:1];
    [dateComponents setYear:2021];
    NSDate *date = [[NSCalendar currentCalendar] dateFromComponents:dateComponents];
    
    NSString *timestamp = [CKCToken timestampForDate:date];
    
    XCTAssertEqualObjects([timestamp substringToIndex:19], @"2021-01-01T00:00:00", @"timestamp: %@ is not Equal 2021-01-01T00:00:00+03:00", timestamp);
}

@end
