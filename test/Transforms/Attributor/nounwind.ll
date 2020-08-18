; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --scrub-attributes --check-attributes
; RUN: opt -attributor -enable-new-pm=0 -attributor-manifest-internal  -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=1 -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_CGSCC_NPM,NOT_CGSCC_OPM,NOT_TUNIT_NPM,IS__TUNIT____,IS________OPM,IS__TUNIT_OPM
; RUN: opt -aa-pipeline=basic-aa -passes=attributor -attributor-manifest-internal  -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=1 -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_CGSCC_OPM,NOT_CGSCC_NPM,NOT_TUNIT_OPM,IS__TUNIT____,IS________NPM,IS__TUNIT_NPM
; RUN: opt -attributor-cgscc -enable-new-pm=0 -attributor-manifest-internal  -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_TUNIT_NPM,NOT_TUNIT_OPM,NOT_CGSCC_NPM,IS__CGSCC____,IS________OPM,IS__CGSCC_OPM
; RUN: opt -aa-pipeline=basic-aa -passes=attributor-cgscc -attributor-manifest-internal  -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_TUNIT_NPM,NOT_TUNIT_OPM,NOT_CGSCC_OPM,IS__CGSCC____,IS________NPM,IS__CGSCC_NPM

; TEST 1
define i32 @foo1() {
; IS__TUNIT____: Function Attrs: nofree nosync nounwind readnone willreturn
; IS__TUNIT____-LABEL: define {{[^@]+}}@foo1()
; IS__TUNIT____-NEXT:    ret i32 1
;
; IS__CGSCC____: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC____-LABEL: define {{[^@]+}}@foo1()
; IS__CGSCC____-NEXT:    ret i32 1
;
  ret i32 1
}

; TEST 2
define i32 @scc1_foo() {
; NOT_CGSCC_NPM: Function Attrs: nofree noreturn nosync nounwind readnone willreturn
; NOT_CGSCC_NPM-LABEL: define {{[^@]+}}@scc1_foo()
; NOT_CGSCC_NPM-NEXT:    unreachable
;
; IS__CGSCC_NPM: Function Attrs: nofree norecurse noreturn nosync nounwind readnone willreturn
; IS__CGSCC_NPM-LABEL: define {{[^@]+}}@scc1_foo()
; IS__CGSCC_NPM-NEXT:    unreachable
;
  %1 = call i32 @scc1_bar()
  ret i32 1
}


; TEST 3
define i32 @scc1_bar() {
; NOT_CGSCC_NPM: Function Attrs: nofree noreturn nosync nounwind readnone willreturn
; NOT_CGSCC_NPM-LABEL: define {{[^@]+}}@scc1_bar()
; NOT_CGSCC_NPM-NEXT:    unreachable
;
; IS__CGSCC_NPM: Function Attrs: nofree norecurse noreturn nosync nounwind readnone willreturn
; IS__CGSCC_NPM-LABEL: define {{[^@]+}}@scc1_bar()
; IS__CGSCC_NPM-NEXT:    unreachable
;
  %1 = call i32 @scc1_foo()
  ret i32 1
}

declare i32 @non_nounwind()

; TEST 4
define void @call_non_nounwind(){
; CHECK-LABEL: define {{[^@]+}}@call_non_nounwind()
; CHECK-NEXT:    [[TMP1:%.*]] = tail call i32 @non_nounwind()
; CHECK-NEXT:    ret void
;
  tail call i32 @non_nounwind()
  ret void
}

; TEST 5 - throw
; int maybe_throw(bool canThrow) {
;   if (canThrow)
;     throw;
;   else
;     return -1;
; }

define i32 @maybe_throw(i1 zeroext %0) {
; CHECK-LABEL: define {{[^@]+}}@maybe_throw
; CHECK-SAME: (i1 zeroext [[TMP0:%.*]])
; CHECK-NEXT:    br i1 [[TMP0]], label [[TMP2:%.*]], label [[TMP3:%.*]]
; CHECK:       2:
; CHECK-NEXT:    tail call void @__cxa_rethrow()
; CHECK-NEXT:    unreachable
; CHECK:       3:
; CHECK-NEXT:    ret i32 -1
;
  br i1 %0, label %2, label %3

2:                                                ; preds = %1
  tail call void @__cxa_rethrow() #1
  unreachable

3:                                                ; preds = %1
  ret i32 -1
}

declare void @__cxa_rethrow()

; TEST 6 - catch
; int catch_thing() {
;   try {
;       int a = doThing(true);
;   }
;   catch(...) { return -1; }
;   return 1;
; }

define i32 @catch_thing() personality i8* bitcast (i32 (...)* @__gxx_personality_v0 to i8*) {
; CHECK-LABEL: define {{[^@]+}}@catch_thing() personality i8* bitcast (i32 (...)* @__gxx_personality_v0 to i8*)
; CHECK-NEXT:    invoke void @__cxa_rethrow()
; CHECK-NEXT:    to label [[TMP1:%.*]] unwind label [[TMP2:%.*]]
; CHECK:       1:
; CHECK-NEXT:    unreachable
; CHECK:       2:
; CHECK-NEXT:    [[TMP3:%.*]] = landingpad { i8*, i32 }
; CHECK-NEXT:    catch i8* null
; CHECK-NEXT:    [[TMP4:%.*]] = extractvalue { i8*, i32 } [[TMP3]], 0
; CHECK-NEXT:    [[TMP5:%.*]] = tail call i8* @__cxa_begin_catch(i8* [[TMP4]])
; CHECK-NEXT:    tail call void @__cxa_end_catch()
; CHECK-NEXT:    ret i32 -1
;
  invoke void @__cxa_rethrow() #1
  to label %1 unwind label %2

1:                                                ; preds = %0
  unreachable

2:                                                ; preds = %0
  %3 = landingpad { i8*, i32 }
  catch i8* null
  %4 = extractvalue { i8*, i32 } %3, 0
  %5 = tail call i8* @__cxa_begin_catch(i8* %4) #2
  tail call void @__cxa_end_catch()
  ret i32 -1
}

define i32 @catch_thing_user() {
; CHECK-LABEL: define {{[^@]+}}@catch_thing_user()
; CHECK-NEXT:    [[CATCH_THING_CALL:%.*]] = call i32 @catch_thing()
; CHECK-NEXT:    ret i32 -1
;
  %catch_thing_call = call i32 @catch_thing()
  ret i32 %catch_thing_call
}


declare i32 @__gxx_personality_v0(...)

declare i8* @__cxa_begin_catch(i8*)

declare void @__cxa_end_catch()
