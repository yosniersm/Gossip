// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to YOSService.h instead.

@import CoreData;
#import "YOSGossipBaseClass.h"

extern const struct YOSServiceAttributes {
	__unsafe_unretained NSString *detail;
	__unsafe_unretained NSString *name;
} YOSServiceAttributes;

extern const struct YOSServiceRelationships {
	__unsafe_unretained NSString *events;
	__unsafe_unretained NSString *photo;
	__unsafe_unretained NSString *user;
} YOSServiceRelationships;

@class YOSEvent;
@class YOSPhotoContainer;
@class YOSCredential;

@interface YOSServiceID : NSManagedObjectID {}
@end

@interface _YOSService : YOSGossipBaseClass {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) YOSServiceID* objectID;

@property (nonatomic, strong) NSString* detail;

//- (BOOL)validateDetail:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *events;

- (NSMutableSet*)eventsSet;

@property (nonatomic, strong) YOSPhotoContainer *photo;

//- (BOOL)validatePhoto:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) YOSCredential *user;

//- (BOOL)validateUser:(id*)value_ error:(NSError**)error_;

@end

@interface _YOSService (EventsCoreDataGeneratedAccessors)
- (void)addEvents:(NSSet*)value_;
- (void)removeEvents:(NSSet*)value_;
- (void)addEventsObject:(YOSEvent*)value_;
- (void)removeEventsObject:(YOSEvent*)value_;

@end

@interface _YOSService (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveDetail;
- (void)setPrimitiveDetail:(NSString*)value;

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;

- (NSMutableSet*)primitiveEvents;
- (void)setPrimitiveEvents:(NSMutableSet*)value;

- (YOSPhotoContainer*)primitivePhoto;
- (void)setPrimitivePhoto:(YOSPhotoContainer*)value;

- (YOSCredential*)primitiveUser;
- (void)setPrimitiveUser:(YOSCredential*)value;

@end
