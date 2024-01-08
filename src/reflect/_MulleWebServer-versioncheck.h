/*
 *   This file will be regenerated by `mulle-project-versioncheck`.
 *   Any edits will be lost.
 */
#ifndef mulle_web_server_versioncheck_h__
#define mulle_web_server_versioncheck_h__

#if defined( MULLE_CIVET_WEB_VERSION)
# ifndef MULLE_CIVET_WEB_VERSION_MIN
#  define MULLE_CIVET_WEB_VERSION_MIN  ((0UL << 20) | (17 << 8) | 10)
# endif
# ifndef MULLE_CIVET_WEB_VERSION_MAX
#  define MULLE_CIVET_WEB_VERSION_MAX  ((0UL << 20) | (18 << 8) | 0)
# endif
# if MULLE_CIVET_WEB_VERSION < MULLE_CIVET_WEB_VERSION_MIN
#  error "MulleCivetWeb is too old"
# endif
# if MULLE_CIVET_WEB_VERSION >= MULLE_CIVET_WEB_VERSION_MAX
#  error "MulleCivetWeb is too new"
# endif
#endif

#if defined( MULLE_FOUNDATION_VERSION)
# ifndef MULLE_FOUNDATION_VERSION_MIN
#  define MULLE_FOUNDATION_VERSION_MIN  ((0UL << 20) | (22 << 8) | 1)
# endif
# ifndef MULLE_FOUNDATION_VERSION_MAX
#  define MULLE_FOUNDATION_VERSION_MAX  ((0UL << 20) | (23 << 8) | 0)
# endif
# if MULLE_FOUNDATION_VERSION < MULLE_FOUNDATION_VERSION_MIN
#  error "MulleFoundation is too old"
# endif
# if MULLE_FOUNDATION_VERSION >= MULLE_FOUNDATION_VERSION_MAX
#  error "MulleFoundation is too new"
# endif
#endif

#if defined( MULLE_OBJC_JSMN_FOUNDATION_VERSION)
# ifndef MULLE_OBJC_JSMN_FOUNDATION_VERSION_MIN
#  define MULLE_OBJC_JSMN_FOUNDATION_VERSION_MIN  ((0UL << 20) | (18 << 8) | 6)
# endif
# ifndef MULLE_OBJC_JSMN_FOUNDATION_VERSION_MAX
#  define MULLE_OBJC_JSMN_FOUNDATION_VERSION_MAX  ((0UL << 20) | (19 << 8) | 0)
# endif
# if MULLE_OBJC_JSMN_FOUNDATION_VERSION < MULLE_OBJC_JSMN_FOUNDATION_VERSION_MIN
#  error "MulleObjCJSMNFoundation is too old"
# endif
# if MULLE_OBJC_JSMN_FOUNDATION_VERSION >= MULLE_OBJC_JSMN_FOUNDATION_VERSION_MAX
#  error "MulleObjCJSMNFoundation is too new"
# endif
#endif

#endif
