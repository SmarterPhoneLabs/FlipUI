/*
	SQLSTUDIOtbl_Ad_Status_Result.h
	The interface definition of properties and methods for the SQLSTUDIOtbl_Ad_Status_Result object.
	Generated by SudzC.com
*/

#import "Soap.h"
	

@interface SQLSTUDIOtbl_Ad_Status_Result : SoapObject
{
	int _Ad_Status_ID;
	NSString* _Ad_Status_Name;
	
}
		
	@property int Ad_Status_ID;
	@property (retain, nonatomic) NSString* Ad_Status_Name;

	+ (SQLSTUDIOtbl_Ad_Status_Result*) newWithNode: (CXMLNode*) node;
	- (id) initWithNode: (CXMLNode*) node;
	- (NSMutableString*) serialize;
	- (NSMutableString*) serialize: (NSString*) nodeName;
	- (NSMutableString*) serializeAttributes;
	- (NSMutableString*) serializeElements;

@end
