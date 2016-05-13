//
//  VSToken.h
//  TokenInputView
//
//  Created by Vinodh Swamy on 4/25/16.
//  Copyright © 2016 Vinodh Swamy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VSToken : NSObject
@property (nonatomic, copy) NSString *uniqueId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSDate *timeStamp;
@property (nonatomic) NSRange tokenRange;
@end
