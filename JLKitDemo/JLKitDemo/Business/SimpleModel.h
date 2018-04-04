//
//  SimpleModel.h
//  JLKitDemo
//
//  Created by Wangjianlong on 2018/4/4.
//  Copyright © 2018年 JL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OTProtocol.h"

@interface SimpleModel : NSObject<OTItemProtocol>

@property (nonatomic, copy) NSString *title;

@end
