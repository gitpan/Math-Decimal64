
#ifdef  __MINGW32__
#ifndef __USE_MINGW_ANSI_STDIO
#define __USE_MINGW_ANSI_STDIO 1
#endif
#endif


#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include <stdlib.h>

#ifdef OLDPERL
#define SvUOK SvIsUV
#endif

#ifndef Newx
#  define Newx(v,n,t) New(0,v,n,t)
#endif

int  _is_nan(_Decimal64 x) {
     if(x == x) return 0;
     return 1;
}

int  _is_inf(_Decimal64 x) {
     if(x != x) return 0; /* NaN  */
     if(x == 0.0DD) return 0; /* Zero */
     if(x/x != x/x) {
       if(x < 0.0DD) return -1;
       else return 1;
     }
     return 0; /* Finite Real */
}

int  _is_neg_zero(_Decimal64 x) {
     char * buffer;

     if(x != 0.0DD) return 0;

     Newx(buffer, 2, char);
     sprintf(buffer, "%.0f", (double)x);

     if(strcmp(buffer, "-0")) {
       Safefree(buffer);
       return 0;
     }   

     Safefree(buffer);
     return 1;
}

int  _is_nan_NV(SV * x) {
     if(SvNV(x) == SvNV(x)) return 0;
     return 1;
}

int  _is_inf_NV(SV * x) {
     if(SvNV(x) != SvNV(x)) return 0; /* NaN  */
     if(SvNV(x) == 0.0) return 0; /* Zero */
     if(SvNV(x)/SvNV(x) != SvNV(x)/SvNV(x)) {
       if(SvNV(x) < 0.0) return -1;
       else return 1;
     }
     return 0; /* Finite Real */
}

int  _is_neg_zero_NV(SV * x) {
     char * buffer;

     if(SvNV(x) != 0.0) return 0;

     Newx(buffer, 2, char);

     sprintf(buffer, "%.0f", (double)SvNV(x));

     if(strcmp(buffer, "-0")) {
       Safefree(buffer);
       return 0;
     }   

     Safefree(buffer);
     return 1;
}

_Decimal64 _get_inf(int sign) {
     if(sign < 0) return -1.0DD/0.0DD;
     return 1.0DD/0.0DD;
}

_Decimal64 _get_nan(void) {
     _Decimal64 inf = _get_inf(1);
     return inf/inf;
}

SV * _DEC64_MAX(void) {
     _Decimal64 * d64;
     SV * obj_ref, * obj;

     Newx(d64, 1, _Decimal64);
     if(d64 == NULL) croak("Failed to allocate memory in DEC64_MAX() function");

     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, "Math::Decimal64");

     *d64 = 9999999999999999e369DD;
     

     sv_setiv(obj, INT2PTR(IV,d64));
     SvREADONLY_on(obj);
     return obj_ref;
}

SV * _DEC64_MIN(void) {
     _Decimal64 * d64;
     SV * obj_ref, * obj;

     Newx(d64, 1, _Decimal64);
     if(d64 == NULL) croak("Failed to allocate memory in DEC64_MIN() function");

     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, "Math::Decimal64");

     *d64 = 1e-398DD;
     

     sv_setiv(obj, INT2PTR(IV,d64));
     SvREADONLY_on(obj);
     return obj_ref;
}
    

SV * NaND64(void) {
     _Decimal64 * d64;
     SV * obj_ref, * obj;

     Newx(d64, 1, _Decimal64);
     if(d64 == NULL) croak("Failed to allocate memory in NaND64() function");

     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, "Math::Decimal64");

     *d64 = _get_nan();

     sv_setiv(obj, INT2PTR(IV,d64));
     SvREADONLY_on(obj);
     return obj_ref;
}

SV * InfD64(int sign) {
     _Decimal64 * d64;
     SV * obj_ref, * obj;

     Newx(d64, 1, _Decimal64);
     if(d64 == NULL) croak("Failed to allocate memory in InfD64() function");

     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, "Math::Decimal64");

     *d64 = _get_inf(sign);

     sv_setiv(obj, INT2PTR(IV,d64));
     SvREADONLY_on(obj);
     return obj_ref;
}

SV * ZeroD64(int sign) {
     _Decimal64 * d64;
     SV * obj_ref, * obj;

     Newx(d64, 1, _Decimal64);
     if(d64 == NULL) croak("Failed to allocate memory in ZeroD64() function");

     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, "Math::Decimal64");

     *d64 = 0.0DD;
     if(sign < 0) *d64 *= -1;

     sv_setiv(obj, INT2PTR(IV,d64));
     SvREADONLY_on(obj);
     return obj_ref;
}

SV * UnityD64(int sign) {
     _Decimal64 * d64;
     SV * obj_ref, * obj;

     Newx(d64, 1, _Decimal64);
     if(d64 == NULL) croak("Failed to allocate memory in UnityD64() function");

     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, "Math::Decimal64");

     *d64 = 1.0DD;
     if(sign < 0) *d64 *= -1;

     sv_setiv(obj, INT2PTR(IV,d64));
     SvREADONLY_on(obj);
     return obj_ref;
}

SV * Exp10(int power) {
     _Decimal64 * d64;
     SV * obj_ref, * obj;

     if(power < -398 || power > 384)
       croak("Argument supplied to Exp10 function (%d) is out of allowable range", power);

     Newx(d64, 1, _Decimal64);
     if(d64 == NULL) croak("Failed to allocate memory in Exp10() function");

     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, "Math::Decimal64");

     *d64 = 1.0DD;
     if(power < 0) {
       while(power) {
         *d64 *= 0.1DD;
         power++;
       }
     }
     else {
       while(power) {
         *d64 *= 10.0DD;
         power--;
       }
     }

     sv_setiv(obj, INT2PTR(IV,d64));
     SvREADONLY_on(obj);
     return obj_ref;
}

SV * _testvalD64(int sign) {
     _Decimal64 * d64;
     SV * obj_ref, * obj;

     Newx(d64, 1, _Decimal64);
     if(d64 == NULL) croak("Failed to allocate memory in _testvalD64() function");

     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, "Math::Decimal64");

     *d64 = 9307199254740993e-15DD;
     
     if(sign < 0) *d64 *= -1;

     sv_setiv(obj, INT2PTR(IV,d64));
     SvREADONLY_on(obj);
     return obj_ref;
}

SV * _MEtoD64(char * mantissa, SV * exponent) {

     _Decimal64 * d64;
     SV * obj_ref, * obj;
     int exp = (int)SvIV(exponent), i;
     char * ptr;
     long double man;

     man = strtold(mantissa, &ptr);

     Newx(d64, 1, _Decimal64);
     if(d64 == NULL) croak("Failed to allocate memory in MEtoD64() function");

     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, "Math::Decimal64");

     *d64 = (_Decimal64)man;
     if(exp < 0) {
       for(i = 0; i > exp; --i) *d64 *= 0.1DD;
     }
     else {
       for(i = 0; i < exp; ++i) *d64 *= 10.0DD;
     } 

     sv_setiv(obj, INT2PTR(IV,d64));
     SvREADONLY_on(obj);
     return obj_ref;
}

SV * NVtoD64(SV * x) {

     _Decimal64 * d64;
     SV * obj_ref, * obj;

     Newx(d64, 1, _Decimal64);
     if(d64 == NULL) croak("Failed to allocate memory in NVtoD64() function");

     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, "Math::Decimal64");

     *d64 = (_Decimal64)SvNV(x);

     sv_setiv(obj, INT2PTR(IV,d64));
     SvREADONLY_on(obj);
     return obj_ref;
}

SV * UVtoD64(SV * x) {

     _Decimal64 * d64;
     SV * obj_ref, * obj;

     Newx(d64, 1, _Decimal64);
     if(d64 == NULL) croak("Failed to allocate memory in UVtoD64() function");

     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, "Math::Decimal64");

     *d64 = (_Decimal64)SvUV(x);

     sv_setiv(obj, INT2PTR(IV,d64));
     SvREADONLY_on(obj);
     return obj_ref;
}

SV * IVtoD64(SV * x) {

     _Decimal64 * d64;
     SV * obj_ref, * obj;

     Newx(d64, 1, _Decimal64);
     if(d64 == NULL) croak("Failed to allocate memory in IVtoD64() function");

     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, "Math::Decimal64");

     *d64 = (_Decimal64)SvIV(x);

     sv_setiv(obj, INT2PTR(IV,d64));
     SvREADONLY_on(obj);
     return obj_ref;
}

SV * PVtoD64(char * x) {
     _Decimal64 * d64;
     long double temp;
     char * ptr;
     SV * obj_ref, * obj;

     temp = strtold(x, &ptr);

     Newx(d64, 1, _Decimal64);
     if(d64 == NULL) croak("Failed to allocate memory in PVtoD64() function");

     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, "Math::Decimal64");

     *d64 = (_Decimal64)temp;

     sv_setiv(obj, INT2PTR(IV,d64));
     SvREADONLY_on(obj);
     return obj_ref;
}

SV * STRtoD64(char * x) {
#ifdef STRTOD64_AVAILABLE
     _Decimal64 * d64;
     char * ptr;
     SV * obj_ref, * obj;

     Newx(d64, 1, _Decimal64);
     if(d64 == NULL) croak("Failed to allocate memory in STRtoD64() function");

     *d64 = strtod64(x, &ptr);

     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, "Math::Decimal64");

     sv_setiv(obj, INT2PTR(IV,d64));
     SvREADONLY_on(obj);
     return obj_ref;
#else
     croak("The strtod64() function has not been made available");
#endif
}

int  have_strtod64(void) {
#ifdef STRTOD64_AVAILABLE
     return 1;
#else
     return 0;
#endif
}

SV * D64toNV(SV * d64) {
     return newSVnv((NV)(*(INT2PTR(_Decimal64*, SvIV(SvRV(d64))))));
}

void LDtoD64(SV * d64, SV * ld) {
     if(sv_isobject(d64) && sv_isobject(ld)) {
       const char *h1 = HvNAME(SvSTASH(SvRV(d64)));
       const char *h2 = HvNAME(SvSTASH(SvRV(ld)));
       if(strEQ(h1, "Math::Decimal64") && strEQ(h2, "Math::LongDouble")) {
         *(INT2PTR(_Decimal64 *, SvIV(SvRV(d64)))) = (_Decimal64)*(INT2PTR(long double *, SvIV(SvRV(ld))));
       }
       else croak("Invalid object supplied to Math::Decimal64::LDtoD64");
     }
     else croak("Invalid argument supplied to Math::Decimal64::LDtoD64");
}

void D64toLD(SV * ld, SV * d64) {
     if(sv_isobject(d64) && sv_isobject(ld)) {
       const char *h1 = HvNAME(SvSTASH(SvRV(d64)));
       const char *h2 = HvNAME(SvSTASH(SvRV(ld)));
       if(strEQ(h1, "Math::Decimal64") && strEQ(h2, "Math::LongDouble")) {
         *(INT2PTR(long double *, SvIV(SvRV(ld)))) = (long double)*(INT2PTR(_Decimal64 *, SvIV(SvRV(d64)))); 
       }
       else croak("Invalid object supplied to Math::Decimal64::D64toLD");
     }
     else croak("Invalid argument supplied to Math::Decimal64::D64toLD");
}

void DESTROY(SV *  rop) {
     Safefree(INT2PTR(_Decimal64 *, SvIV(SvRV(rop))));
}

void _assignME(SV * a, char * mantissa, SV * c) {
     char * ptr;
     long double man;
     int exp = (int)SvIV(c), i;

     man = strtold(mantissa, &ptr);

     *(INT2PTR(_Decimal64 *, SvIV(SvRV(a)))) = (_Decimal64)man;

     if(exp < 0) {
       for(i = 0; i > exp; --i) *(INT2PTR(_Decimal64 *, SvIV(SvRV(a)))) *= 0.1DD;
     }
     else {
       for(i = 0; i < exp; ++i) *(INT2PTR(_Decimal64 *, SvIV(SvRV(a)))) *= 10.0DD;
     }
}

void assignPV(SV * a, char * str) {
     char * ptr;
     long double man = strtold(str, &ptr);

     *(INT2PTR(_Decimal64 *, SvIV(SvRV(a)))) = (_Decimal64)man;
}

void assignNaN(SV * a) {

     if(sv_isobject(a)) {
       const char * h = HvNAME(SvSTASH(SvRV(a)));
       if(strEQ(h, "Math::Decimal64")) {
          *(INT2PTR(_Decimal64 *, SvIV(SvRV(a)))) = _get_nan();
       }
       else croak("Invalid object supplied to Math::Decimal64::assignNaN function");
     }
     else croak("Invalid argument supplied to Math::Decimal64::assignNaN function");
}

void assignInf(SV * a, int sign) {

     if(sv_isobject(a)) {
       const char * h = HvNAME(SvSTASH(SvRV(a)));
       if(strEQ(h, "Math::Decimal64")) {
          *(INT2PTR(_Decimal64 *, SvIV(SvRV(a)))) = _get_inf(sign);
       }
       else croak("Invalid object supplied to Math::Decimal64::assignInf function");
     }
     else croak("Invalid argument supplied to Math::Decimal64::assignInf function");
}

SV * _overload_add(SV * a, SV * b, SV * third) {

     _Decimal64 * d64;
     SV * obj_ref, * obj;

     Newx(d64, 1, _Decimal64);
     if(d64 == NULL) croak("Failed to allocate memory in _overload_add() function");

     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, "Math::Decimal64");

     sv_setiv(obj, INT2PTR(IV,d64));
     SvREADONLY_on(obj);

    if(SvUOK(b)) {
      *d64 = *(INT2PTR(_Decimal64 *, SvIV(SvRV(a)))) + SvUV(b);
      return obj_ref;
    }

    if(SvIOK(b)) {
      *d64 = *(INT2PTR(_Decimal64 *, SvIV(SvRV(a)))) + SvIV(b);
      return obj_ref;
    }

    if(sv_isobject(b)) {
      const char *h = HvNAME(SvSTASH(SvRV(b)));
      if(strEQ(h, "Math::Decimal64")) {
        *d64 = *(INT2PTR(_Decimal64 *, SvIV(SvRV(a)))) + *(INT2PTR(_Decimal64 *, SvIV(SvRV(b))));
        return obj_ref; 
      }
      croak("Invalid object supplied to Math::Decimal64::_overload_add function");
    }
    croak("Invalid argument supplied to Math::Decimal64::_overload_add function");
}

SV * _overload_mul(SV * a, SV * b, SV * third) {

     _Decimal64 * d64;
     SV * obj_ref, * obj;

     Newx(d64, 1, _Decimal64);
     if(d64 == NULL) croak("Failed to allocate memory in _overload_mul() function");

     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, "Math::Decimal64");

     sv_setiv(obj, INT2PTR(IV,d64));
     SvREADONLY_on(obj);

    if(SvUOK(b)) {
      *d64 = *(INT2PTR(_Decimal64 *, SvIV(SvRV(a)))) * SvUV(b);
      return obj_ref;
    }

    if(SvIOK(b)) {
      *d64 = *(INT2PTR(_Decimal64 *, SvIV(SvRV(a)))) * SvIV(b);
      return obj_ref;
    }

    if(sv_isobject(b)) {
      const char *h = HvNAME(SvSTASH(SvRV(b)));
      if(strEQ(h, "Math::Decimal64")) {
        *d64 = *(INT2PTR(_Decimal64 *, SvIV(SvRV(a)))) * *(INT2PTR(_Decimal64 *, SvIV(SvRV(b))));
        return obj_ref; 
      }
      croak("Invalid object supplied to Math::Decimal64::_overload_mul function");
    }
    croak("Invalid argument supplied to Math::Decimal64::_overload_mul function");
}

SV * _overload_sub(SV * a, SV * b, SV * third) {

     _Decimal64 * d64;
     SV * obj_ref, * obj;

     Newx(d64, 1, _Decimal64);
     if(d64 == NULL) croak("Failed to allocate memory in _overload_sub() function");

     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, "Math::Decimal64");

     sv_setiv(obj, INT2PTR(IV,d64));
     SvREADONLY_on(obj);

    if(SvUOK(b)) {
      if(third == &PL_sv_yes) *d64 = SvUV(b) - *(INT2PTR(_Decimal64 *, SvIV(SvRV(a))));
      else *d64 = *(INT2PTR(_Decimal64 *, SvIV(SvRV(a)))) - SvUV(b);
      return obj_ref;
    }

    if(SvIOK(b)) {
      if(third == &PL_sv_yes) *d64 = SvIV(b) - *(INT2PTR(_Decimal64 *, SvIV(SvRV(a))));
      else *d64 = *(INT2PTR(_Decimal64 *, SvIV(SvRV(a)))) - SvIV(b);
      return obj_ref;
    }

    if(sv_isobject(b)) {
      const char *h = HvNAME(SvSTASH(SvRV(b)));
      if(strEQ(h, "Math::Decimal64")) {
        *d64 = *(INT2PTR(_Decimal64 *, SvIV(SvRV(a)))) - *(INT2PTR(_Decimal64 *, SvIV(SvRV(b))));
        return obj_ref; 
      }
      croak("Invalid object supplied to Math::Decimal64::_overload_sub function");
    }

    if(third == &PL_sv_yes) {
      *d64 = *(INT2PTR(_Decimal64 *, SvIV(SvRV(a)))) * -1.0DD;
      return obj_ref;
    }

    croak("Invalid argument supplied to Math::Decimal64::_overload_sub function");
}

SV * _overload_div(SV * a, SV * b, SV * third) {

     _Decimal64 * d64;
     SV * obj_ref, * obj;

     Newx(d64, 1, _Decimal64);
     if(d64 == NULL) croak("Failed to allocate memory in _overload_div() function");

     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, "Math::Decimal64");

     sv_setiv(obj, INT2PTR(IV,d64));
     SvREADONLY_on(obj);

    if(SvUOK(b)) {
      if(third == &PL_sv_yes) *d64 = SvUV(b) / *(INT2PTR(_Decimal64 *, SvIV(SvRV(a))));
      else *d64 = *(INT2PTR(_Decimal64 *, SvIV(SvRV(a)))) / SvUV(b);
      return obj_ref;
    }

    if(SvIOK(b)) {
      if(third == &PL_sv_yes) *d64 = SvIV(b) / *(INT2PTR(_Decimal64 *, SvIV(SvRV(a))));
      else *d64 = *(INT2PTR(_Decimal64 *, SvIV(SvRV(a)))) / SvIV(b);
      return obj_ref;
    }

    if(sv_isobject(b)) {
      const char *h = HvNAME(SvSTASH(SvRV(b)));
      if(strEQ(h, "Math::Decimal64")) {
        *d64 = *(INT2PTR(_Decimal64 *, SvIV(SvRV(a)))) / *(INT2PTR(_Decimal64 *, SvIV(SvRV(b))));
        return obj_ref; 
      }
      croak("Invalid object supplied to Math::Decimal64::_overload_div function");
    }
    croak("Invalid argument supplied to Math::Decimal64::_overload_div function");
}

SV * _overload_add_eq(SV * a, SV * b, SV * third) {

     SvREFCNT_inc(a);

    if(SvUOK(b)) {
      *(INT2PTR(_Decimal64 *, SvIV(SvRV(a)))) += SvUV(b);
      return a;
    }
    if(SvIOK(b)) {
      *(INT2PTR(_Decimal64 *, SvIV(SvRV(a)))) += SvIV(b);
      return a;
    }

    if(sv_isobject(b)) {
      const char *h = HvNAME(SvSTASH(SvRV(b)));
      if(strEQ(h, "Math::Decimal64")) {
        *(INT2PTR(_Decimal64 *, SvIV(SvRV(a)))) += *(INT2PTR(_Decimal64 *, SvIV(SvRV(b))));
        return a;
      }
      SvREFCNT_dec(a);
      croak("Invalid object supplied to Math::Decimal64::_overload_add_eq function");
    }
    SvREFCNT_dec(a);
    croak("Invalid argument supplied to Math::Decimal64::_overload_add_eq function");
}

SV * _overload_mul_eq(SV * a, SV * b, SV * third) {

     SvREFCNT_inc(a);

    if(SvUOK(b)) {
      *(INT2PTR(_Decimal64 *, SvIV(SvRV(a)))) *= SvUV(b);
      return a;
    }
    if(SvIOK(b)) {
      *(INT2PTR(_Decimal64 *, SvIV(SvRV(a)))) *= SvIV(b);
      return a;
    }

    if(sv_isobject(b)) {
      const char *h = HvNAME(SvSTASH(SvRV(b)));
      if(strEQ(h, "Math::Decimal64")) {
        *(INT2PTR(_Decimal64 *, SvIV(SvRV(a)))) *= *(INT2PTR(_Decimal64 *, SvIV(SvRV(b))));
        return a;
      }
      SvREFCNT_dec(a);
      croak("Invalid object supplied to Math::Decimal64::_overload_mul_eq function");
    }
    SvREFCNT_dec(a);
    croak("Invalid argument supplied to Math::Decimal64::_overload_mul_eq function");
}

SV * _overload_sub_eq(SV * a, SV * b, SV * third) {

     SvREFCNT_inc(a);

    if(SvUOK(b)) {
      *(INT2PTR(_Decimal64 *, SvIV(SvRV(a)))) -= SvUV(b);
      return a;
    }
    if(SvIOK(b)) {
      *(INT2PTR(_Decimal64 *, SvIV(SvRV(a)))) -= SvIV(b);
      return a;
    }

    if(sv_isobject(b)) {
      const char *h = HvNAME(SvSTASH(SvRV(b)));
      if(strEQ(h, "Math::Decimal64")) {
        *(INT2PTR(_Decimal64 *, SvIV(SvRV(a)))) -= *(INT2PTR(_Decimal64 *, SvIV(SvRV(b))));
        return a;
      }
      SvREFCNT_dec(a);
      croak("Invalid object supplied to Math::Decimal64::_overload_sub_eq function");
    }
    SvREFCNT_dec(a);
    croak("Invalid argument supplied to Math::Decimal64::_overload_sub_eq function");
}

SV * _overload_div_eq(SV * a, SV * b, SV * third) {

     SvREFCNT_inc(a);

    if(SvUOK(b)) {
      *(INT2PTR(_Decimal64 *, SvIV(SvRV(a)))) /= SvUV(b);
      return a;
    }
    if(SvIOK(b)) {
      *(INT2PTR(_Decimal64 *, SvIV(SvRV(a)))) /= SvIV(b);
      return a;
    }

    if(sv_isobject(b)) {
      const char *h = HvNAME(SvSTASH(SvRV(b)));
      if(strEQ(h, "Math::Decimal64")) {
        *(INT2PTR(_Decimal64 *, SvIV(SvRV(a)))) /= *(INT2PTR(_Decimal64 *, SvIV(SvRV(b))));
        return a;
      }
      SvREFCNT_dec(a);
      croak("Invalid object supplied to Math::Decimal64::_overload_div_eq function");
    }
    SvREFCNT_dec(a);
    croak("Invalid argument supplied to Math::Decimal64::_overload_div_eq function");
}

int _overload_equiv(SV * a, SV * b, SV * third) {

    if(SvUOK(b)) {
      if(*(INT2PTR(_Decimal64 *, SvIV(SvRV(a)))) == SvUV(b)) return 1;
      return 0;
    }

    if(SvIOK(b)) {
      if(*(INT2PTR(_Decimal64 *, SvIV(SvRV(a)))) == SvIV(b)) return 1;
      return 0;
    }

    if(sv_isobject(b)) {
      const char *h = HvNAME(SvSTASH(SvRV(b)));
      if(strEQ(h, "Math::Decimal64")) {
        if(*(INT2PTR(_Decimal64 *, SvIV(SvRV(a)))) == *(INT2PTR(_Decimal64 *, SvIV(SvRV(b))))) return 1;
        return 0; 
      }
      croak("Invalid object supplied to Math::Decimal64::_overload_equiv function");
    }
    croak("Invalid argument supplied to Math::Decimal64::_overload_equiv function");
}

int _overload_not_equiv(SV * a, SV * b, SV * third) {

    if(SvUOK(b)) {
      if(*(INT2PTR(_Decimal64 *, SvIV(SvRV(a)))) != SvUV(b)) return 1;
      return 0;
    }

    if(SvIOK(b)) {
      if(*(INT2PTR(_Decimal64 *, SvIV(SvRV(a)))) != SvIV(b)) return 1;
      return 0;
    }

    if(sv_isobject(b)) {
      const char *h = HvNAME(SvSTASH(SvRV(b)));
      if(strEQ(h, "Math::Decimal64")) {
        if(*(INT2PTR(_Decimal64 *, SvIV(SvRV(a)))) == *(INT2PTR(_Decimal64 *, SvIV(SvRV(b))))) return 0;
        return 1; 
      }
      croak("Invalid object supplied to Math::Decimal64::_overload_not_equiv function");
    }
    croak("Invalid argument supplied to Math::Decimal64::_overload_not_equiv function");
}

int _overload_lt(SV * a, SV * b, SV * third) {

    if(SvUOK(b)) {
      if(*(INT2PTR(_Decimal64 *, SvIV(SvRV(a)))) < SvUV(b)) return 1;
      return 0;
    }

    if(SvIOK(b)) {
      if(*(INT2PTR(_Decimal64 *, SvIV(SvRV(a)))) < SvIV(b)) return 1;
      return 0;
    }

    if(sv_isobject(b)) {
      const char *h = HvNAME(SvSTASH(SvRV(b)));
      if(strEQ(h, "Math::Decimal64")) {
        if(*(INT2PTR(_Decimal64 *, SvIV(SvRV(a)))) < *(INT2PTR(_Decimal64 *, SvIV(SvRV(b))))) return 1;
        return 0; 
      }
      croak("Invalid object supplied to Math::Decimal64::_overload_lt function");
    }
    croak("Invalid argument supplied to Math::Decimal64::_overload_lt function");
}

int _overload_gt(SV * a, SV * b, SV * third) {

    if(SvUOK(b)) {
      if(*(INT2PTR(_Decimal64 *, SvIV(SvRV(a)))) > SvUV(b)) return 1;
      return 0;
    }

    if(SvIOK(b)) {
      if(*(INT2PTR(_Decimal64 *, SvIV(SvRV(a)))) > SvIV(b)) return 1;
      return 0;
    }

    if(sv_isobject(b)) {
      const char *h = HvNAME(SvSTASH(SvRV(b)));
      if(strEQ(h, "Math::Decimal64")) {
        if(*(INT2PTR(_Decimal64 *, SvIV(SvRV(a)))) > *(INT2PTR(_Decimal64 *, SvIV(SvRV(b))))) return 1;
        return 0; 
      }
      croak("Invalid object supplied to Math::Decimal64::_overload_gt function");
    }
    croak("Invalid argument supplied to Math::Decimal64::_overload_gt function");
}

int _overload_lte(SV * a, SV * b, SV * third) {

    if(SvUOK(b)) {
      if(*(INT2PTR(_Decimal64 *, SvIV(SvRV(a)))) <= SvUV(b)) return 1;
      return 0;
    }

    if(SvIOK(b)) {
      if(*(INT2PTR(_Decimal64 *, SvIV(SvRV(a)))) <= SvIV(b)) return 1;
      return 0;
    }

    if(sv_isobject(b)) {
      const char *h = HvNAME(SvSTASH(SvRV(b)));
      if(strEQ(h, "Math::Decimal64")) {
        if(*(INT2PTR(_Decimal64 *, SvIV(SvRV(a)))) <= *(INT2PTR(_Decimal64 *, SvIV(SvRV(b))))) return 1;
        return 0; 
      }
      croak("Invalid object supplied to Math::Decimal64::_overload_lte function");
    }
    croak("Invalid argument supplied to Math::Decimal64::_overload_lte function");
}

int _overload_gte(SV * a, SV * b, SV * third) {

    if(SvUOK(b)) {
      if(*(INT2PTR(_Decimal64 *, SvIV(SvRV(a)))) >= SvUV(b)) return 1;
      return 0;
    }

    if(SvIOK(b)) {
      if(*(INT2PTR(_Decimal64 *, SvIV(SvRV(a)))) >= SvIV(b)) return 1;
      return 0;
    }

    if(sv_isobject(b)) {
      const char *h = HvNAME(SvSTASH(SvRV(b)));
      if(strEQ(h, "Math::Decimal64")) {
        if(*(INT2PTR(_Decimal64 *, SvIV(SvRV(a)))) >= *(INT2PTR(_Decimal64 *, SvIV(SvRV(b))))) return 1;
        return 0; 
      }
      croak("Invalid object supplied to Math::Decimal64::_overload_gte function");
    }
    croak("Invalid argument supplied to Math::Decimal64::_overload_gte function");
}

SV * _overload_spaceship(SV * a, SV * b, SV * third) {

    if(SvUOK(b)) {
      if(*(INT2PTR(_Decimal64 *, SvIV(SvRV(a)))) > SvUV(b)) return newSViv(1);
      if(*(INT2PTR(_Decimal64 *, SvIV(SvRV(a)))) < SvUV(b)) return newSViv(-1);
      if(*(INT2PTR(_Decimal64 *, SvIV(SvRV(a)))) == SvUV(b)) return newSViv(0);
      return &PL_sv_undef; /* Math::Decimal64 object (1st arg) is a nan */
    }

    if(SvIOK(b)) {
      if(*(INT2PTR(_Decimal64 *, SvIV(SvRV(a)))) > SvIV(b)) return newSViv(1);
      if(*(INT2PTR(_Decimal64 *, SvIV(SvRV(a)))) < SvIV(b)) return newSViv(-1);
      if(*(INT2PTR(_Decimal64 *, SvIV(SvRV(a)))) == SvIV(b)) return newSViv(0);
      return &PL_sv_undef; /* Math::Decimal64 object (1st arg) is a nan */
    }

    if(sv_isobject(b)) {
      const char *h = HvNAME(SvSTASH(SvRV(b)));
      if(strEQ(h, "Math::Decimal64")) {
        if(*(INT2PTR(_Decimal64 *, SvIV(SvRV(a)))) < *(INT2PTR(_Decimal64 *, SvIV(SvRV(b))))) return newSViv(-1);
        if(*(INT2PTR(_Decimal64 *, SvIV(SvRV(a)))) > *(INT2PTR(_Decimal64 *, SvIV(SvRV(b))))) return newSViv(1);
        if(*(INT2PTR(_Decimal64 *, SvIV(SvRV(a)))) == *(INT2PTR(_Decimal64 *, SvIV(SvRV(b))))) return newSViv(0);
        return &PL_sv_undef; /* it's a nan */  
      }
      croak("Invalid object supplied to Math::Decimal64::_overload_spaceship function");
    }
    croak("Invalid argument supplied to Math::Decimal64::_overload_spaceship function");
}

SV * _overload_copy(SV * a, SV * b, SV * third) {

     _Decimal64 * d64;
     SV * obj_ref, * obj;

     Newx(d64, 1, _Decimal64);
     if(d64 == NULL) croak("Failed to allocate memory in _overload_copy() function");

     *d64 = *(INT2PTR(_Decimal64 *, SvIV(SvRV(a))));

     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, "Math::Decimal64");
     sv_setiv(obj, INT2PTR(IV,d64));
     SvREADONLY_on(obj);
     return obj_ref; 
}

SV * D64toD64(SV * a) {
     _Decimal64 * d64;
     SV * obj_ref, * obj;

     if(sv_isobject(a)) {
       const char *h = HvNAME(SvSTASH(SvRV(a)));
       if(strEQ(h, "Math::Decimal64")) {

         Newx(d64, 1, _Decimal64);
         if(d64 == NULL) croak("Failed to allocate memory in D64toD64() function");

         *d64 = *(INT2PTR(_Decimal64 *, SvIV(SvRV(a))));

         obj_ref = newSV(0);
         obj = newSVrv(obj_ref, "Math::Decimal64");
         sv_setiv(obj, INT2PTR(IV,d64));
         SvREADONLY_on(obj);
         return obj_ref;
       }
       croak("Invalid object supplied to Math::Decimal64::D64toD64 function"); 
     }
     croak("Invalid argument supplied to Math::Decimal64::D64toD64 function");
}

int _overload_true(SV * a, SV * b, SV * third) {

     if(_is_nan(*(INT2PTR(_Decimal64 *, SvIV(SvRV(a)))))) return 0;
     if(*(INT2PTR(_Decimal64 *, SvIV(SvRV(a)))) != 0.0DD) return 1;
     return 0; 
}

int _overload_not(SV * a, SV * b, SV * third) {
     if(_is_nan(*(INT2PTR(_Decimal64 *, SvIV(SvRV(a)))))) return 1;
     if(*(INT2PTR(_Decimal64 *, SvIV(SvRV(a)))) != 0.0DD) return 0;
     return 1; 
}

SV * _overload_abs(SV * a, SV * b, SV * third) {

     _Decimal64 * d64;
     SV * obj_ref, * obj;

     Newx(d64, 1, _Decimal64);
     if(d64 == NULL) croak("Failed to allocate memory in _overload_abs() function");

     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, "Math::Decimal64");

     sv_setiv(obj, INT2PTR(IV,d64));
     SvREADONLY_on(obj);

     *d64 = *(INT2PTR(_Decimal64 *, SvIV(SvRV(a))));
     if(_is_neg_zero(*d64) || *d64 < 0 ) *d64 *= -1.0DD;
     return obj_ref; 
}

SV * _overload_inc(SV * p, SV * second, SV * third) {
     SvREFCNT_inc(p);
     *(INT2PTR(_Decimal64 *, SvIV(SvRV(p)))) += 1.0DD;
     return p;
}

SV * _overload_dec(SV * p, SV * second, SV * third) {
     SvREFCNT_inc(p);
     *(INT2PTR(_Decimal64 *, SvIV(SvRV(p)))) -= 1.0DD;
     return p;
}

SV * _itsa(SV * a) {
     if(SvUOK(a)) return newSVuv(1);
     if(SvIOK(a)) return newSVuv(2);
     if(SvNOK(a)) return newSVuv(3);
     if(SvPOK(a)) return newSVuv(4);
     if(sv_isobject(a)) {
       const char *h = HvNAME(SvSTASH(SvRV(a)));
       if(strEQ(h, "Math::Decimal64")) return newSVuv(64);
     }
     return newSVuv(0);
}

int is_NaND64(SV * b) {
     if(sv_isobject(b)) {
      const char *h = HvNAME(SvSTASH(SvRV(b)));
      if(strEQ(h, "Math::Decimal64"))
         return _is_nan(*(INT2PTR(_Decimal64 *, SvIV(SvRV(b)))));
     }
     croak("Invalid argument supplied to Math::Decimal64::is_NaND64 function");
}

int is_InfD64(SV * b) {
     if(sv_isobject(b)) {
      const char *h = HvNAME(SvSTASH(SvRV(b)));
      if(strEQ(h, "Math::Decimal64"))
         return _is_inf(*(INT2PTR(_Decimal64 *, SvIV(SvRV(b)))));
     }
     croak("Invalid argument supplied to Math::Decimal64::is_InfD64 function");
}

int is_ZeroD64(SV * b) {
     if(sv_isobject(b)) {
      const char *h = HvNAME(SvSTASH(SvRV(b)));
      if(strEQ(h, "Math::Decimal64"))
         if (_is_neg_zero(*(INT2PTR(_Decimal64 *, SvIV(SvRV(b)))))) return -1;
         if (*(INT2PTR(_Decimal64 *, SvIV(SvRV(b)))) == 0.0DD) return 1;
         return 0;
     }
     croak("Invalid argument supplied to Math::Decimal64::is_ZeroD64 function");
}

void _D64toME(SV * a) {
     dXSARGS;
     _Decimal64 t;
     char * buffer;
     int count = 0;

     if(sv_isobject(a)) {
       const char *h = HvNAME(SvSTASH(SvRV(a)));
       if(strEQ(h, "Math::Decimal64")) {
          t = *(INT2PTR(_Decimal64 *, SvIV(SvRV(a))));
          if(_is_nan(t) || _is_inf(t) || t == 0.0DD) {
            EXTEND(SP, 2);
            ST(0) = sv_2mortal(newSVnv(t));
            ST(1) = sv_2mortal(newSViv(0));
            XSRETURN(2);
          }

          /* At this stage we know the arg is not a _Decimal64 infinity/0, but on powerpc it might be a
             long double that's outside the allowable range */
#if defined(__powerpc__) || defined(_ARCH_PPC) || defined(_M_PPC) || defined(__PPCGECKO__) || defined(__PPCBROADWAY__)
          if((long double)t > LDBL_MAX ||
             (long double)t < -LDBL_MAX) {
            count = 150;
            t *= 1e-150DD; /* (long double)t should now be in range */
          }

          if((long double)t <  LDBL_MIN * 128.0L &&
             (long double)t > -LDBL_MIN * 128.0L) {
            count = -150;
            t *= 1e150DD; /* (long double)t should now be in range */
          }
#endif
          Newx(buffer, 32, char);
          if(buffer == NULL)croak("Couldn't allocate memory in _D64toME");
          sprintf(buffer, "%.15Le", (long double)t);
          EXTEND(SP, 3);
          ST(0) = sv_2mortal(newSVpv(buffer, 0));
          ST(1) = &PL_sv_undef;
          ST(2) = sv_2mortal(newSViv(count)); /* count will be added to the exponent in D64toME() perl sub. */
          Safefree(buffer);
          XSRETURN(3);
       }
       else croak("Invalid object supplied to Math::Decimal64::D64toME function");
     }
     else croak("Invalid argument supplied to Math::Decimal64::D64toME function");
}

/* Replaced by newer rendition (above) that caters for the case that the long double
   has the same exponent range as the double - eg. powerpc "double-double arithmetic".
void _D64toME(SV * a) {
     dXSARGS;
     _Decimal64 t;
     char * buffer;

     if(sv_isobject(a)) {
       const char *h = HvNAME(SvSTASH(SvRV(a)));
       if(strEQ(h, "Math::Decimal64")) {
          EXTEND(SP, 2);
          t = *(INT2PTR(_Decimal64 *, SvIV(SvRV(a))));
          if(_is_nan(t) || _is_inf(t) || t == 0.0DD) {
            ST(0) = sv_2mortal(newSVnv(t));
            ST(1) = sv_2mortal(newSViv(0));
            XSRETURN(2);
          }

          Newx(buffer, 32, char);
          sprintf(buffer, "%.15Le", (long double)t);
          ST(0) = sv_2mortal(newSVpv(buffer, 0));
          ST(1) = &PL_sv_undef;
          Safefree(buffer);
          XSRETURN(2);
       }
       else croak("Invalid object supplied to Math::Decimal64::D64toME function");
     }
     else croak("Invalid argument supplied to Math::Decimal64::D64toME function");
}
*/

void _c2ld(char * mantissa) { /* convert using %.15Le */
     dXSARGS;
     long double man;
     char *ptr, *buffer;

     man = strtold(mantissa, &ptr);
     Newx(buffer, 32, char);
     sprintf(buffer, "%.15Le", man);

     ST(0) = sv_2mortal(newSVpv(buffer, 0));
     Safefree(buffer);
     XSRETURN(1);
}

void _c2d(char * mantissa) { /* convert using %.15e */
     dXSARGS;
     double man;
     char *ptr, *buffer;

     man = strtod(mantissa, &ptr);
     Newx(buffer, 32, char);
     sprintf(buffer, "%.15e", man);

     ST(0) = sv_2mortal(newSVpv(buffer, 0));
     Safefree(buffer);
     XSRETURN(1);
}
 
SV * _wrap_count(void) {
     return newSVuv(PL_sv_count);
}

SV * _get_xs_version(void) {
     return newSVpv(XS_VERSION, 0);
}
MODULE = Math::Decimal64	PACKAGE = Math::Decimal64	

PROTOTYPES: DISABLE


int
_is_nan_NV (x)
	SV *	x

int
_is_inf_NV (x)
	SV *	x

int
_is_neg_zero_NV (x)
	SV *	x

SV *
_DEC64_MAX ()
		

SV *
_DEC64_MIN ()
		

SV *
NaND64 ()
		

SV *
InfD64 (sign)
	int	sign

SV *
ZeroD64 (sign)
	int	sign

SV *
UnityD64 (sign)
	int	sign

SV *
Exp10 (power)
	int	power

SV *
_testvalD64 (sign)
	int	sign

SV *
_MEtoD64 (mantissa, exponent)
	char *	mantissa
	SV *	exponent

SV *
NVtoD64 (x)
	SV *	x

SV *
UVtoD64 (x)
	SV *	x

SV *
IVtoD64 (x)
	SV *	x

SV *
PVtoD64 (x)
	char *	x

SV *
STRtoD64 (x)
	char *	x

int
have_strtod64 ()
		

SV *
D64toNV (d64)
	SV *	d64

void
LDtoD64 (d64, ld)
	SV *	d64
	SV *	ld
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	LDtoD64(d64, ld);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

void
D64toLD (ld, d64)
	SV *	ld
	SV *	d64
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	D64toLD(ld, d64);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

void
DESTROY (rop)
	SV *	rop
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	DESTROY(rop);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

void
_assignME (a, mantissa, c)
	SV *	a
	char *	mantissa
	SV *	c
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	_assignME(a, mantissa, c);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

void
assignPV (a, str)
	SV *	a
	char *	str
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	assignPV(a, str);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

void
assignNaN (a)
	SV *	a
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	assignNaN(a);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

void
assignInf (a, sign)
	SV *	a
	int	sign
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	assignInf(a, sign);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

SV *
_overload_add (a, b, third)
	SV *	a
	SV *	b
	SV *	third

SV *
_overload_mul (a, b, third)
	SV *	a
	SV *	b
	SV *	third

SV *
_overload_sub (a, b, third)
	SV *	a
	SV *	b
	SV *	third

SV *
_overload_div (a, b, third)
	SV *	a
	SV *	b
	SV *	third

SV *
_overload_add_eq (a, b, third)
	SV *	a
	SV *	b
	SV *	third

SV *
_overload_mul_eq (a, b, third)
	SV *	a
	SV *	b
	SV *	third

SV *
_overload_sub_eq (a, b, third)
	SV *	a
	SV *	b
	SV *	third

SV *
_overload_div_eq (a, b, third)
	SV *	a
	SV *	b
	SV *	third

int
_overload_equiv (a, b, third)
	SV *	a
	SV *	b
	SV *	third

int
_overload_not_equiv (a, b, third)
	SV *	a
	SV *	b
	SV *	third

int
_overload_lt (a, b, third)
	SV *	a
	SV *	b
	SV *	third

int
_overload_gt (a, b, third)
	SV *	a
	SV *	b
	SV *	third

int
_overload_lte (a, b, third)
	SV *	a
	SV *	b
	SV *	third

int
_overload_gte (a, b, third)
	SV *	a
	SV *	b
	SV *	third

SV *
_overload_spaceship (a, b, third)
	SV *	a
	SV *	b
	SV *	third

SV *
_overload_copy (a, b, third)
	SV *	a
	SV *	b
	SV *	third

SV *
D64toD64 (a)
	SV *	a

int
_overload_true (a, b, third)
	SV *	a
	SV *	b
	SV *	third

int
_overload_not (a, b, third)
	SV *	a
	SV *	b
	SV *	third

SV *
_overload_abs (a, b, third)
	SV *	a
	SV *	b
	SV *	third

SV *
_overload_inc (p, second, third)
	SV *	p
	SV *	second
	SV *	third

SV *
_overload_dec (p, second, third)
	SV *	p
	SV *	second
	SV *	third

SV *
_itsa (a)
	SV *	a

int
is_NaND64 (b)
	SV *	b

int
is_InfD64 (b)
	SV *	b

int
is_ZeroD64 (b)
	SV *	b

void
_D64toME (a)
	SV *	a
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	_D64toME(a);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

void
_c2ld (mantissa)
	char *	mantissa
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	_c2ld(mantissa);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

void
_c2d (mantissa)
	char *	mantissa
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	_c2d(mantissa);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

SV *
_wrap_count ()
		

SV *
_get_xs_version ()
		

