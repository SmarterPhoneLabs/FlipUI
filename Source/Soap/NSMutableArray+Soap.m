//
//  NSMutableArray+Soap.m
//
//  Created by Jason Kichline on 12/14/10.
//  Copyright 2010 Jason Kichline
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

#import "NSMutableArray+Soap.h"
#import "Soap.h"

@implementation NSMutableArray (Soap)

+(NSMutableArray*)newWithNode: (CXMLNode*) node {
	return [[[self alloc] initWithNode:node] autorelease];
}

-(id)initWithNode:(CXMLNode*)node {
	if(self = [self init]) {
		for(CXMLNode* child in [node children]) {
			[self addObject:[Soap deserialize:child]];
		}
	}
	return self;
}

-(id)object { return self; }

+ (NSMutableString*) serialize: (NSArray*) array {
	return [NSMutableString stringWithString:[Soap serialize:array]];
}

@end
