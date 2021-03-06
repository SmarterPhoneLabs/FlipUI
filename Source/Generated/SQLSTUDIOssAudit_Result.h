/*
	SQLSTUDIOssAudit_Result.h
	The interface definition of properties and methods for the SQLSTUDIOssAudit_Result object.
	Generated by SudzC.com
*/

#import "Soap.h"
	

@interface SQLSTUDIOssAudit_Result : SoapObject
{
	int _Audid_Action;
	int _Audit_ID;
	int _PKID;
	NSString* _Table_Name;
	NSDate* _TimeStamp;
	int _User_ID;
	
}
		
	@property int Audid_Action;
	@property int Audit_ID;
	@property int PKID;
	@property (retain, nonatomic) NSString* Table_Name;
	@property (retain, nonatomic) NSDate* TimeStamp;
	@property int User_ID;

	+ (SQLSTUDIOssAudit_Result*) newWithNode: (CXMLNode*) node;
	- (id) initWithNode: (CXMLNode*) node;
	- (NSMutableString*) serialize;
	- (NSMutableString*) serialize: (NSString*) nodeName;
	- (NSMutableString*) serializeAttributes;
	- (NSMutableString*) serializeElements;

@end
