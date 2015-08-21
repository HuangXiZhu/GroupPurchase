
#import <UIKit/UIKit.h>

#ifdef DEBUG
#define ZYLog(...) NSLog(__VA_ARGS__)
#else
#define ZYLog(...)
#endif

#define ZYColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define ZYGlobalBg ZYColor(230, 230, 230)

extern NSString *const ZYCityDidChangeNotification;
extern NSString *const ZYSelectedCityName;

extern NSString *const ZYSortDidChangeNotification;
extern NSString *const ZYSelectSort;

extern NSString *const ZYCategoryDidChangeNotification;
extern NSString *const ZYSelectCategory;
extern NSString *const ZYSelectSubcategoryName;

extern NSString *const ZYRegionDidChangeNotification;
extern NSString *const ZYSelectRegion;
extern NSString *const ZYSelectSubregionName;