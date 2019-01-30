//
//  UtilsConstants.h
//  GB_Football
//
//  Created by 王时温 on 2017/6/2.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#ifndef UtilsConstants_h
#define UtilsConstants_h

#define BLOCK_EXEC(block, ...) if (block) { block(__VA_ARGS__); };
#define BLOCK_EXEC_SetNil(block, ...) if (block) { block(__VA_ARGS__); block = nil;};
#define LS(key) NSLocalizedString(key, nil)
#define kAppScale ([UIScreen mainScreen].bounds.size.width*1.0/375)
#define FONT_ADAPT(F) [UIFont systemFontOfSize:(F*kAppScale)]

#define STRING_VALUE(obj, default) DICT_VALUE_IS_NOTNULL(obj) ? (DICT_VALUE_IS_NUMBER(obj) ? [obj stringValue] : (DICT_VALUE_IS_STRING(obj) ? obj : default)) : default
#define INTEGER_VALUE(obj, default) (DICT_VALUE_IS_VALID(obj) ? [obj integerValue] : default)
#define FLOAT_VALUE(obj, default) (DICT_VALUE_IS_VALID(obj) ? [obj floatValue] : default)
#define DOUBLE_VALUE(obj, default) (DICT_VALUE_IS_VALID(obj) ? [obj doubleValue] : default)
#define BOOL_VALUE(obj, default) (DICT_VALUE_IS_VALID(obj) ? [obj boolValue] : default)

#endif /* UtilsConstants_h */
