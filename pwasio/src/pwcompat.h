#ifndef __PWASIO_PWCOMPAT_H__
#define __PWASIO_PWCOMPAT_H__

#ifndef nullptr
#define nullptr ((void *) 0)
#endif

#ifdef __GNUC__
#  define UNUSED(x) x ## _UNUSED __attribute__((__unused__))
#else
#  define UNUSED(x) x ## _UNUSED
#endif

#ifdef __GNUC__
#  define UNUSED_FUNCTION(x) __attribute__((__unused__)) x ## _UNUSED
#else
#  define UNUSED_FUNCTION(x) x ## _UNUSED
#endif

#endif // !__PWASIO_PWCOMPAT_H__
