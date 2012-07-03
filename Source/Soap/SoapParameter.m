//
//  SoapParameter.m
//
//  Created by Jason Kichline on 7/13/09.
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

#import "SoapParameter.h"
#import "Soap.h"

@implementation SoapParameter

@synthesize name, value, null, xml;

-(void)setValue:(id)valueParam{
	[valueParam retain];
	[value release];
	value = valueParam;
	null = (value == nil);
}

-(id)initWithValue:(id)valueParam forName: (NSString*) nameValue {
	if(self = [super init]) {
		self.name = nameValue;
		self.value = valueParam;
	}
	return self;
}

-(NSString*)xml{
	if(self.value == nil) {
		return [NSString stringWithFormat:@"<%@ xsi:nil=\"true\"/>", name];
	} else {
		return [Soap serialize: self.value withName: name];
	}
}

-(void)dealloc{
	[name release];
	[value release];
	[xml release];
	[super dealloc];
}

@end
