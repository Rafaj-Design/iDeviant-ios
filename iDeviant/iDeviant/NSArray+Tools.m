//
//  NSArray+Tools.m
//  iDeviant
//
//  Created by Ondrej Rafaj on 18/10/2013.
//  Copyright (c) 2013 Fuerte Innovations. All rights reserved.
//

#import "NSArray+Tools.h"


@implementation NSArray (Tools)


#pragma mark Reverting

- (NSArray *)reversedArray {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:[self count]];
    NSEnumerator *enumerator = [self reverseObjectEnumerator];
    for (id element in enumerator) {
        [array addObject:element];
    }
    return array;
}


@end


@implementation NSMutableArray (Tools)


#pragma mark Reverting

- (void)reverse {
    if ([self count] == 0) return;
    NSUInteger i = 0;
    NSUInteger j = [self count] - 1;
    while (i < j) {
        [self exchangeObjectAtIndex:i withObjectAtIndex:j];
        i++;
        j--;
    }
}

#pragma mark Moving

- (void)moveObjectAtIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    id object = [self objectAtIndex:fromIndex];
    [self removeObjectAtIndex:fromIndex];
    [self insertObject:object atIndex:toIndex];
}


@end
