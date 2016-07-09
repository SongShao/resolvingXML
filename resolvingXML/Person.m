//
//  Person.m
//  resolvingXML
//
//  Created by lst on 16/7/9.
//  Copyright © 2016年 lst. All rights reserved.
//

#import "Person.h"

@implementation Person
- (NSString *)description
{
    return [NSString stringWithFormat:@"name:%@ ,age:%@ ,height:%@",self.name ,self.age ,self.height];
}
@end
