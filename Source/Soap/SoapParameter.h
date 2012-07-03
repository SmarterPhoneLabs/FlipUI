//
//  SoapParameter.h
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

#import <Foundation/Foundation.h>


@interface SoapParameter : NSObject {
	NSString* name;
	NSString* xml;
	id value;
	BOOL null;
}

@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) id value;
@property (readonly) BOOL null;
@property (nonatomic, retain, readonly) NSString* xml;

-(id)initWithValue:(id)value forName: (NSString*) name;

@end
