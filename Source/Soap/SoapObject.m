//
//  SoapObject.m
//
//  Created by Jason Kichline on 7/2/09.
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
//
//  Authors:
//    Jason Kichline, andCulture - Harrisburg, Pennsylvania USA
//    Karl Schulenburg, UMAI Development - Shoreditch, London UK

#import "Soap.h"
#import "SoapObject.h"

@implementation SoapObject

// Initialization include for every object - important (NSString and NSDates's to nil) - Karl
- (id) init {
	if (self = [super init]) {
	}
	return self;
}

// Static method for initializing from a node.
+ (id) newWithNode: (CXMLNode*) node {
	return (id)[[[SoapObject alloc] initWithNode: node] autorelease];
}

// Called when initializing the object from a node
- (id) initWithNode: (CXMLNode*) node {
	if(self = [self init]) {
	}
	return self;
}

// This will get called when traversing objects, returning nothing is ok - Karl
- (NSMutableString*) serialize {
	return [NSMutableString string];
}

- (NSMutableString*) serialize: (NSString*) nodeName {
	return [NSMutableString string];
}

- (NSMutableString*) serializeElements {
	return [NSMutableString string];
}

- (NSMutableString*) serializeAttributes {
	return [NSMutableString string];
}

- (id) object {
	return self;
}

- (NSString*) description {
	return [Soap serialize:self];
}

- (void) dealloc {
	[super dealloc];
}

@end