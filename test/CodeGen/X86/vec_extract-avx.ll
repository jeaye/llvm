; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown-unknown -mattr=+avx | FileCheck %s --check-prefix=CHECK --check-prefix=X32
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx | FileCheck %s --check-prefix=CHECK --check-prefix=X64

; When extracting multiple consecutive elements from a larger
; vector into a smaller one, do it efficiently. We should use
; an EXTRACT_SUBVECTOR node internally rather than a bunch of
; single element extractions.

; Extracting the low elements only requires using the right kind of store.
define void @low_v8f32_to_v4f32(<8 x float> %v, <4 x float>* %ptr) {
; X32-LABEL: low_v8f32_to_v4f32:
; X32:       # BB#0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    vmovaps %xmm0, (%eax)
; X32-NEXT:    vzeroupper
; X32-NEXT:    retl
;
; X64-LABEL: low_v8f32_to_v4f32:
; X64:       # BB#0:
; X64-NEXT:    vmovaps %xmm0, (%rdi)
; X64-NEXT:    vzeroupper
; X64-NEXT:    retq
  %ext0 = extractelement <8 x float> %v, i32 0
  %ext1 = extractelement <8 x float> %v, i32 1
  %ext2 = extractelement <8 x float> %v, i32 2
  %ext3 = extractelement <8 x float> %v, i32 3
  %ins0 = insertelement <4 x float> undef, float %ext0, i32 0
  %ins1 = insertelement <4 x float> %ins0, float %ext1, i32 1
  %ins2 = insertelement <4 x float> %ins1, float %ext2, i32 2
  %ins3 = insertelement <4 x float> %ins2, float %ext3, i32 3
  store <4 x float> %ins3, <4 x float>* %ptr, align 16
  ret void
}

; Extracting the high elements requires just one AVX instruction.
define void @high_v8f32_to_v4f32(<8 x float> %v, <4 x float>* %ptr) {
; X32-LABEL: high_v8f32_to_v4f32:
; X32:       # BB#0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    vextractf128 $1, %ymm0, (%eax)
; X32-NEXT:    vzeroupper
; X32-NEXT:    retl
;
; X64-LABEL: high_v8f32_to_v4f32:
; X64:       # BB#0:
; X64-NEXT:    vextractf128 $1, %ymm0, (%rdi)
; X64-NEXT:    vzeroupper
; X64-NEXT:    retq
  %ext0 = extractelement <8 x float> %v, i32 4
  %ext1 = extractelement <8 x float> %v, i32 5
  %ext2 = extractelement <8 x float> %v, i32 6
  %ext3 = extractelement <8 x float> %v, i32 7
  %ins0 = insertelement <4 x float> undef, float %ext0, i32 0
  %ins1 = insertelement <4 x float> %ins0, float %ext1, i32 1
  %ins2 = insertelement <4 x float> %ins1, float %ext2, i32 2
  %ins3 = insertelement <4 x float> %ins2, float %ext3, i32 3
  store <4 x float> %ins3, <4 x float>* %ptr, align 16
  ret void
}

; Make sure element type doesn't alter the codegen. Note that
; if we were actually using the vector in this function and
; have AVX2, we should generate vextracti128 (the int version).
define void @high_v8i32_to_v4i32(<8 x i32> %v, <4 x i32>* %ptr) {
; X32-LABEL: high_v8i32_to_v4i32:
; X32:       # BB#0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    vextractf128 $1, %ymm0, (%eax)
; X32-NEXT:    vzeroupper
; X32-NEXT:    retl
;
; X64-LABEL: high_v8i32_to_v4i32:
; X64:       # BB#0:
; X64-NEXT:    vextractf128 $1, %ymm0, (%rdi)
; X64-NEXT:    vzeroupper
; X64-NEXT:    retq
  %ext0 = extractelement <8 x i32> %v, i32 4
  %ext1 = extractelement <8 x i32> %v, i32 5
  %ext2 = extractelement <8 x i32> %v, i32 6
  %ext3 = extractelement <8 x i32> %v, i32 7
  %ins0 = insertelement <4 x i32> undef, i32 %ext0, i32 0
  %ins1 = insertelement <4 x i32> %ins0, i32 %ext1, i32 1
  %ins2 = insertelement <4 x i32> %ins1, i32 %ext2, i32 2
  %ins3 = insertelement <4 x i32> %ins2, i32 %ext3, i32 3
  store <4 x i32> %ins3, <4 x i32>* %ptr, align 16
  ret void
}

; Make sure that element size doesn't alter the codegen.
define void @high_v4f64_to_v2f64(<4 x double> %v, <2 x double>* %ptr) {
; X32-LABEL: high_v4f64_to_v2f64:
; X32:       # BB#0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    vextractf128 $1, %ymm0, (%eax)
; X32-NEXT:    vzeroupper
; X32-NEXT:    retl
;
; X64-LABEL: high_v4f64_to_v2f64:
; X64:       # BB#0:
; X64-NEXT:    vextractf128 $1, %ymm0, (%rdi)
; X64-NEXT:    vzeroupper
; X64-NEXT:    retq
  %ext0 = extractelement <4 x double> %v, i32 2
  %ext1 = extractelement <4 x double> %v, i32 3
  %ins0 = insertelement <2 x double> undef, double %ext0, i32 0
  %ins1 = insertelement <2 x double> %ins0, double %ext1, i32 1
  store <2 x double> %ins1, <2 x double>* %ptr, align 16
  ret void
}

; PR25320 Make sure that a widened (possibly legalized) vector correctly zero-extends upper elements.
; FIXME - Ideally these should just call VMOVD/VMOVQ/VMOVSS/VMOVSD

define void @legal_vzmovl_2i32_8i32(<2 x i32>* %in, <8 x i32>* %out) {
; X32-LABEL: legal_vzmovl_2i32_8i32:
; X32:       # BB#0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    vmovsd {{.*#+}} xmm0 = mem[0],zero
; X32-NEXT:    vxorps %xmm1, %xmm1, %xmm1
; X32-NEXT:    vblendps {{.*#+}} ymm0 = ymm0[0],ymm1[1,2,3,4,5,6,7]
; X32-NEXT:    vmovaps %ymm0, (%eax)
; X32-NEXT:    vzeroupper
; X32-NEXT:    retl
;
; X64-LABEL: legal_vzmovl_2i32_8i32:
; X64:       # BB#0:
; X64-NEXT:    vmovsd {{.*#+}} xmm0 = mem[0],zero
; X64-NEXT:    vxorps %xmm1, %xmm1, %xmm1
; X64-NEXT:    vblendps {{.*#+}} ymm0 = ymm0[0],ymm1[1,2,3,4,5,6,7]
; X64-NEXT:    vmovaps %ymm0, (%rsi)
; X64-NEXT:    vzeroupper
; X64-NEXT:    retq
  %ld = load <2 x i32>, <2 x i32>* %in, align 8
  %ext = extractelement <2 x i32> %ld, i64 0
  %ins = insertelement <8 x i32> <i32 undef, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0>, i32 %ext, i64 0
  store <8 x i32> %ins, <8 x i32>* %out, align 32
  ret void
}

define void @legal_vzmovl_2i64_4i64(<2 x i64>* %in, <4 x i64>* %out) {
; X32-LABEL: legal_vzmovl_2i64_4i64:
; X32:       # BB#0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    vmovupd (%ecx), %xmm0
; X32-NEXT:    vxorpd %xmm1, %xmm1, %xmm1
; X32-NEXT:    vblendpd {{.*#+}} ymm0 = ymm0[0],ymm1[1,2,3]
; X32-NEXT:    vmovapd %ymm0, (%eax)
; X32-NEXT:    vzeroupper
; X32-NEXT:    retl
;
; X64-LABEL: legal_vzmovl_2i64_4i64:
; X64:       # BB#0:
; X64-NEXT:    vmovupd (%rdi), %xmm0
; X64-NEXT:    vxorpd %xmm1, %xmm1, %xmm1
; X64-NEXT:    vblendpd {{.*#+}} ymm0 = ymm0[0],ymm1[1,2,3]
; X64-NEXT:    vmovapd %ymm0, (%rsi)
; X64-NEXT:    vzeroupper
; X64-NEXT:    retq
  %ld = load <2 x i64>, <2 x i64>* %in, align 8
  %ext = extractelement <2 x i64> %ld, i64 0
  %ins = insertelement <4 x i64> <i64 undef, i64 0, i64 0, i64 0>, i64 %ext, i64 0
  store <4 x i64> %ins, <4 x i64>* %out, align 32
  ret void
}

define void @legal_vzmovl_2f32_8f32(<2 x float>* %in, <8 x float>* %out) {
; X32-LABEL: legal_vzmovl_2f32_8f32:
; X32:       # BB#0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    vmovss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; X32-NEXT:    vmovaps %ymm0, (%eax)
; X32-NEXT:    vzeroupper
; X32-NEXT:    retl
;
; X64-LABEL: legal_vzmovl_2f32_8f32:
; X64:       # BB#0:
; X64-NEXT:    vmovsd {{.*#+}} xmm0 = mem[0],zero
; X64-NEXT:    vxorps %xmm1, %xmm1, %xmm1
; X64-NEXT:    vblendps {{.*#+}} ymm0 = ymm0[0],ymm1[1,2,3,4,5,6,7]
; X64-NEXT:    vmovaps %ymm0, (%rsi)
; X64-NEXT:    vzeroupper
; X64-NEXT:    retq
  %ld = load <2 x float>, <2 x float>* %in, align 8
  %ext = extractelement <2 x float> %ld, i64 0
  %ins = insertelement <8 x float> <float undef, float 0.0, float 0.0, float 0.0, float 0.0, float 0.0, float 0.0, float 0.0>, float %ext, i64 0
  store <8 x float> %ins, <8 x float>* %out, align 32
  ret void
}

define void @legal_vzmovl_2f64_4f64(<2 x double>* %in, <4 x double>* %out) {
; X32-LABEL: legal_vzmovl_2f64_4f64:
; X32:       # BB#0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    vmovupd (%ecx), %xmm0
; X32-NEXT:    vxorpd %xmm1, %xmm1, %xmm1
; X32-NEXT:    vblendpd {{.*#+}} ymm0 = ymm0[0],ymm1[1,2,3]
; X32-NEXT:    vmovapd %ymm0, (%eax)
; X32-NEXT:    vzeroupper
; X32-NEXT:    retl
;
; X64-LABEL: legal_vzmovl_2f64_4f64:
; X64:       # BB#0:
; X64-NEXT:    vmovupd (%rdi), %xmm0
; X64-NEXT:    vxorpd %xmm1, %xmm1, %xmm1
; X64-NEXT:    vblendpd {{.*#+}} ymm0 = ymm0[0],ymm1[1,2,3]
; X64-NEXT:    vmovapd %ymm0, (%rsi)
; X64-NEXT:    vzeroupper
; X64-NEXT:    retq
  %ld = load <2 x double>, <2 x double>* %in, align 8
  %ext = extractelement <2 x double> %ld, i64 0
  %ins = insertelement <4 x double> <double undef, double 0.0, double 0.0, double 0.0>, double %ext, i64 0
  store <4 x double> %ins, <4 x double>* %out, align 32
  ret void
}
