//
//  DejDownManager.h
//  mj_downLoad
//
//  Created by maoziyue on 2017/10/10.
//  Copyright © 2017年 maoziyue. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^completion)(NSNumber *val);


@interface DejDownManager : NSObject

- (instancetype)initWithArray:(NSArray *)urlArray completion:(completion)completion;

- (void)startDown;

- (void)stopDown;

@end
