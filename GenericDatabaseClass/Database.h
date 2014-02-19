

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface Database : NSObject {

	sqlite3 *databaseObj;

}
+(Database*) shareDatabase;
+(Database*) newDatabase;
-(BOOL) createEditableCopyOfDatabaseIfNeeded;
-(NSString *) GetDatabasePath:(NSString *)dbName;

-(NSMutableArray *)SelectAllFromTable:(NSString *)query;
-(NSMutableArray *)SelectAllFromTableWithLog:(NSString *)query;
-(int)getCount:(NSString *)query;
-(BOOL)CheckForRecord:(NSString *)query;
- (void)Insert:(NSString *)query;
-(void)Delete:(NSString *)query;
-(void)Update:(NSString *)query;
-(void)UpdateWithPower:(NSString *)query;

-(NSInteger) getMaxValueForQuery:(NSString *)sql;
- (NSMutableArray *)fetchParticularData:(NSString *)query;
-(NSInteger) getSumOfValueForQuery:(NSString *)sql;

-(NSString *) getFirstValueForQuery:(NSString *)sql;
-(NSMutableArray *) getFirstColumnForQuery:(NSString *)sql;
-(NSMutableDictionary *) getFirstRowForQuery:(NSString *)sql;
-(NSString*) getSingleDataValueForQuery:(NSString *)sql;
-(NSInteger) getMaxValueFromTable:(NSString *)strTableName forField:(NSString *)strFieldName;

//Jatin Patel
-(void)UpdateForBackGround:(NSString *)query;
-(NSString*) getSingleDataValueForQueryForBackGround:(NSString *)sql;
- (void)InsertForBackGround:(NSString *)query; 
-(NSMutableArray *)SelectAllFromTableForBackGround:(NSString *)query;
-(void)DeleteForBackGround:(NSString *)query;
-(NSString *) getFirstValueForQueryForBackGround:(NSString *)sql;
-(NSMutableDictionary *) getFirstRowForQueryForBackGround:(NSString *)sql;
//End

///Shail
- (void)insertMultipleRecordsWithDictionary:(NSMutableDictionary *)dictParameter inTable:(NSString *)tableName;
- (void)insertMultipleRecordsWithArray:(NSMutableArray *)arrayParameter inTable:(NSString *)tableName;

///

@end
