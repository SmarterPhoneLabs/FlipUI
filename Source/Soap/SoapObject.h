//
//  SoapObject.h
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

#import "TouchXML.h"

@interface SoapObject : NSObject {
}

@property (readonly) id object;

+ (id) newWithNode: (CXMLNode*) node;
- (id) initWithNode: (CXMLNode*) node;
- (NSMutableString*) serialize;
- (NSMutableString*) serialize: (NSString*) nodeName;
- (NSMutableString*) serializeElements;
- (NSMutableString*) serializeAttributes;

@end