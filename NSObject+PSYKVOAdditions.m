/*
 Copyright (c) 2009 Remy Demarest
 
 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the "Software"), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:
 
 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
 */

#import "NSObject+PSYKVOAdditions.h"

// Convenience type, used internally
typedef void (^_PSYKVOHandler)(NSString *keyPath, id object, NSDictionary *change);

// Private class that will do the actual observation and allow its removal
@interface _PSYKVOBlockHelper : NSObject
{
    _PSYKVOHandler  handler;         // The observing block
    NSString       *observedKeyPath; // The observed keyPath, useful when removing the handler
    __weak id       observed;        // A weak reference to the observer object to avoid hanging references
}
@property (copy)   _PSYKVOHandler  handler;
@property (assign) __weak id       observed;
@property (copy)   NSString       *observedKeyPath;
@end


@implementation NSObject (PSYKVOAdditions)

- (id)addBlockObserverForKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options handler:(void (^)(NSString *keyPath, id object, NSDictionary *change))block
{
    // Creates and initialize the helper for observing 
    _PSYKVOBlockHelper *helper = [[_PSYKVOBlockHelper alloc] init];
    [helper setHandler:block];
    [helper setObserved:self];
    [helper setObservedKeyPath:keyPath];
    
    // Add the actual observer, this allow the exact same behavior as the normal technique
    [self addObserver:helper forKeyPath:keyPath options:options context:helper];
    
    return helper;
}

- (void)removeBlockObserver:(id)observer
{
    // Removes the observer and releases it.
    [self removeObserver:observer forKeyPath:[observer observedKeyPath]];
    [observer release];
}

@end


@implementation _PSYKVOBlockHelper
@synthesize handler, observed, observedKeyPath;

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    // If the context is self the handler is called
    if(context == self) handler(keyPath, object, change);
    // This is clearly useless
    else [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

- (void)dealloc
{
    [self setHandler:nil];
    [self setObserved:nil];
    [self setObservedKeyPath:nil];
    [super dealloc];
}

@end



