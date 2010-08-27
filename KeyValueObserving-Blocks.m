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

#import <Foundation/Foundation.h>
#import "NSObject+PSYKVOAdditions.h"

@interface Person : NSObject
{
    NSString *firstName;
    NSString *lastName;
}
@property(copy) NSString *firstName, *lastName;
@end

@interface Family : NSObject
{
    Person *father;
    Person *mother;
}
@property(retain) Person *father, *mother;
@end


int main (int argc, const char * argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    
    void (^blk)(NSString *keyPath, id object, NSDictionary *change) =
    ^(NSString *keyPath, id object, NSDictionary *change)
    {
        NSLog(@"%@ %@ %@", keyPath, object, change);
    };
    
    Person *psy = [[Person alloc] init];
    
    id psyFirstNameObs = [psy addBlockObserverForKeyPath:@"firstName" options:0xF queue:nil usingBlock:blk];
    
    [psy setFirstName:@"Remy"];
    
    Family *myFamily = [[Family alloc] init];
    
    id myFamFatherLastNameObs = [myFamily addBlockObserverForKeyPath:@"father.lastName" options:0xF queue:nil usingBlock:blk];
    
    [myFamily setFather:psy];
    
    [psy setLastName:@"Demarest"];
    
    [psy setFirstName:@"Paul"];
    [psy setLastName:@"Dupont"];
    
    [psy removeBlockObserver:psyFirstNameObs];
    
    [myFamily setFather:nil];
    
    [myFamily removeBlockObserver:myFamFatherLastNameObs];
    
    [psy release];
    [myFamily release];
    
    [pool drain];
    return 0;
}

@implementation Person
@synthesize firstName, lastName;
- (void)dealloc
{
    [firstName release];
    [lastName release];
    [super dealloc];
}
@end

@implementation Family
@synthesize father, mother;
- (void)dealloc
{
    [father release];
    [mother release];
    [super dealloc];
}
@end


