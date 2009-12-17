//
//  tumblrimportPref.m
//  tumblrimport
//
//  Created by tmaeda on 09/08/30.
//  Copyright (c) 2009 tmaeda. All rights reserved.
//

#import <RubyCocoa/RBRuntime.h>


@interface tumblrimportLoader : NSObject
{}
@end
@implementation tumblrimportLoader
@end


static void __attribute__((constructor)) loadRubyScriptAction(void)
{
    RBBundleInit("tumblrimport.rb", [tumblrimportLoader class], nil);
}


