; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py UTC_ARGS: --version 4
; RUN: llc < %s -mtriple=riscv64 -mattr=+v | FileCheck %s

; FIXME: The i32 load and store pair isn't dead and shouldn't be omitted.
define void @f(ptr %p) vscale_range(2,2) {
; CHECK-LABEL: f:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e8, m4, ta, ma
; CHECK-NEXT:    vmv.v.i v8, 0
; CHECK-NEXT:    vs4r.v v8, (a0)
; CHECK-NEXT:    addi a1, a0, 80
; CHECK-NEXT:    vsetivli zero, 16, e8, m1, ta, ma
; CHECK-NEXT:    vmv.v.i v8, 0
; CHECK-NEXT:    vs1r.v v8, (a1)
; CHECK-NEXT:    addi a0, a0, 64
; CHECK-NEXT:    vs1r.v v8, (a0)
; CHECK-NEXT:    ret
  %q = getelementptr inbounds i8, ptr %p, i64 84
  %x = load i32, ptr %q
  call void @llvm.memset.p0.i64(ptr %p, i8 0, i64 96, i1 false)
  store i32 %x, ptr %q
  ret void
}
