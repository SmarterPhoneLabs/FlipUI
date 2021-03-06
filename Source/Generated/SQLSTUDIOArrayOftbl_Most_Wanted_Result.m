/*
	SQLSTUDIOArrayOftbl_Most_Wanted_Result.h
	The implementation of properties and methods for the SQLSTUDIOArrayOftbl_Most_Wanted_Result array.
	Generated by SudzC.com
*/
#import "SQLSTUDIOArrayOftbl_Most_Wanted_Result.h"

#import "SQLSTUDIOtbl_Most_Wanted_Result.h"
@implementation SQLSTUDIOArrayOftbl_Most_Wanted_Result

	+ (id) newWithNode: (CXMLNode*) node
	{
		return [[[SQLSTUDIOArrayOftbl_Most_Wanted_Result alloc] initWithNode: node] autorelease];
	}

	- (id) initWithNode: (CXMLNode*) node
	{
		if(self = [self init]) {
			for(CXMLElement* child in [node children])
			{
				SQLSTUDIOtbl_Most_Wanted_Result* value = [[SQLSTUDIOtbl_Most_Wanted_Result newWithNode: child] object];
				if(value != nil) {
					[self addObject: value];
				}
			}
		}
		return self;
	}
	
	+ (NSMutableString*) serialize: (NSArray*) array
	{
		NSMutableString* s = [NSMutableString string];
		for(id item in array) {
			[s appendString: [item serialize: @"tbl_Most_Wanted_Result"]];
		}
		return s;
	}
@end
