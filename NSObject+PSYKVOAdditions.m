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
typedef void (^_PSYKVOHandler)(NSString *keyPath, id object, NSDictionary *change, void *context);

// Private class that will do the actual observation and allow its removal
@interface _PSYKVOBlockHelper : NSObject
{
    _PSYKVOHandler   handler;          // The observing block
    NSString         *observedKeyPath; // The observed keyPath, useful when removing the handler
    __weak id        observed;         // A weak reference to the observer object to avoid hanging references
    __weak NSOperationQueue *queue;           
}
@property (copy)   _PSYKVOHandler  handler;
@property (assign) __weak id       observed;
@property (copy)   NSString       *observedKeyPath;
@property (assign) __weak NSOperationQueue *queue;
@end


@implementation NSObject (PSYKVOAdditions)

- (id)addBlockObserverForKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context queue:(NSOperationQueue *)queue usingBlock:(void (^)(NSString *keyPath, id object, NSDictionary *change, void *context))block 
{
    // Creates and initialize the helper for observing 
    _PSYKVOBlockHelper *helper = [[[_PSYKVOBlockHelper alloc] init] autorelease]; 
    [helper setHandler:block];
    [helper setObserved:self];
    [helper setObservedKeyPath:keyPath];
    [helper setQueue:queue];
    
    // Add the actual observer, this allow the exact same behavior as the normal technique
    [self addObserver:helper forKeyPath:keyPath options:options context:context];
    
    return helper;
}

- (void)removeBlockObserver:(id)observer
{
    // Removes the observer and releases it.
    [self removeObserver:observer forKeyPath:[observer observedKeyPath]];
}

@end


@implementation _PSYKVOBlockHelper
@synthesize handler, observed, observedKeyPath, queue;

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
  if (queue == nil) {
    handler(keyPath, object, change, context);
  }
  else {
    [queue addOperation:[NSBlockOperation blockOperationWithBlock:^{ handler(keyPath, object, change, context); }]];
  }
}

- (void)dealloc
{
    [self setHandler:nil];
    [self setObserved:nil];
    [self setObservedKeyPath:nil];
    [self setQueue:nil];
    [super dealloc];
}

@end



