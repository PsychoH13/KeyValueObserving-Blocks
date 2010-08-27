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

#import <Cocoa/Cocoa.h>

@interface NSObject (PSYKVOAdditions)

/*
 @abstract Returns a handler object used to remove the observer when appropriate.
 @param keyPath The key path, relative to the receiver, of the property to observe. This value must not be nil.
 @param options A combination of the NSKeyValueObservingOptions values that specifies what is included in observation notifications. For possible values, see ¡§NSKeyValueObservingOptions.¡¨
 @param context Arbitrary data that is passed to anObserver in observeValueForKeyPath:ofObject:change:context:.
 @param queue The operation queue to which block should be added. If you pass nil, the Block is run synchronously on the posting thread. 
 @param block The Block to be executed when the notification is received.
 * The Block is copied by the system and (the copy) held until the observer registration is removed.
 * The Block takes three argument:
 * keyPath
 *   The key path, relative to object, to the value that has changed.
 * object
 *   The source object of the key path keyPath.
 * change
 *   A dictionary that describes the changes that have been made to the value of the property at the key path keyPath relative to object. Entries are described in ¡§Keys used by the change dictionary.¡¨
 * context
 *   The value that was provided when the receiver was registered to receive key-value observation notifications.
 @result An object to act as the observer ¡V of unspecified type, though it will respond to methods in the NSObject protocol ¡V is created for you and returned.
 * You must retain the returned value as long as long as you want the registration to exist in the notification center.
 */
- (id)addBlockObserverForKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context queue:(NSOperationQueue *)queue usingBlock:(void (^)(NSString *keyPath, id object, NSDictionary *change, void *context))block;

/*
 @abstract Removes a block observer previously added with addBlockObserverForKeyPath:options:handler:.
 @param observer The observer to remove. Must not be nil.
 */
- (void)removeBlockObserver:(id)observer;

@end
