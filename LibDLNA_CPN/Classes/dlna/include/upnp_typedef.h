#ifndef _UPNP_TYPEDEF_H_
#define _UPNP_TYPEDEF_H_

#include <stddef.h>
#include <limits.h>
#include <sys/types.h>
#include <inttypes.h>
#ifdef UPNP_COMPILER
#include <typedef.h>
#endif

/**
 * @file
 * @ingroup highlevelapi
 * Upnp common module provides a high level interface to access stack
 */

#ifdef  __cplusplus
extern "C" {
#endif

#ifndef UPNP_COMPILER

#if !defined(BOOL) && !defined(__OBJC__)
typedef int BOOL;
#endif

#if !defined(TRUE)
#if defined(__OBJC__)
#define TRUE YES
#else
#define TRUE (1)
#endif
#endif

#if !defined(FALSE)
#if defined(__OBJC__)
#define FALSE NO
#else
#define FALSE (0)
#endif
#endif

#ifndef  __cplusplus
#if !defined(bool) && !defined(__OBJC__)
typedef int bool;
#endif

#if !defined(true)
#if defined(__OBJC__)
#define true YES
#else
#define true (1)
#endif
#endif

#if !defined(false)
#if defined(__OBJC__)
#define false NO
#else
#define false (0)
#endif
#endif
#endif

#endif

#ifdef  __cplusplus
}
#endif

#endif
