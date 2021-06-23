; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --check-globals
; RUN: opt -S -passes=openmp-opt < %s | FileCheck %s

;; void unknown(void);
;; void spmd_amenable(void) __attribute__((assume("ompx_spmd_amenable")))
;;
;; void sequential_loop() {
;;   #pragma omp target teams
;;   {
;;     for (int i = 0; i < 100; ++i) {
;;       #pragma omp parallel
;;       {
;;         unknown();
;;       }
;;     }
;      spmd_amenable();
;;   }
;; }

target triple = "nvptx64"

%struct.ident_t = type { i32, i32, i32, i32, i8* }

@0 = private unnamed_addr constant [23 x i8] c";unknown;unknown;0;0;;\00", align 1
@1 = private unnamed_addr constant %struct.ident_t { i32 0, i32 2, i32 0, i32 0, i8* getelementptr inbounds ([23 x i8], [23 x i8]* @0, i32 0, i32 0) }, align 8
@__omp_offloading_2c_38c77_sequential_loop_l4_exec_mode = weak constant i8 1
@llvm.compiler.used = appending global [1 x i8*] [i8* @__omp_offloading_2c_38c77_sequential_loop_l4_exec_mode], section "llvm.metadata"

; The second argument of __kmpc_target_init and deinit is is set to true to indicate that we can run in SPMD mode.
; We also adjusted the global __omp_offloading_2c_38c77_sequential_loop_l4_exec_mode to have a zero initializer (which indicates SPMD mode to the runtime).
;.
; CHECK: @[[GLOB0:[0-9]+]] = private unnamed_addr constant [23 x i8] c"
; CHECK: @[[GLOB1:[0-9]+]] = private unnamed_addr constant [[STRUCT_IDENT_T:%.*]] { i32 0, i32 2, i32 0, i32 0, i8* getelementptr inbounds ([23 x i8], [23 x i8]* @[[GLOB0]], i32 0, i32 0) }, align 8
; CHECK: @[[__OMP_OFFLOADING_2C_38C77_SEQUENTIAL_LOOP_L4_EXEC_MODE:[a-zA-Z0-9_$"\\.-]+]] = weak constant i8 0
; CHECK: @[[LLVM_COMPILER_USED:[a-zA-Z0-9_$"\\.-]+]] = appending global [1 x i8*] [i8* @__omp_offloading_2c_38c77_sequential_loop_l4_exec_mode], section "llvm.metadata"
;.
define weak void @__omp_offloading_2c_38c77_sequential_loop_l4() #0 {
; CHECK-LABEL: define {{[^@]+}}@__omp_offloading_2c_38c77_sequential_loop_l4
; CHECK-SAME: () #[[ATTR0:[0-9]+]] {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[DOTZERO_ADDR:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[DOTTHREADID_TEMP_:%.*]] = alloca i32, align 4
; CHECK-NEXT:    store i32 0, i32* [[DOTZERO_ADDR]], align 4
; CHECK-NEXT:    [[TMP0:%.*]] = call i32 @__kmpc_target_init(%struct.ident_t* @[[GLOB1]], i1 true, i1 false, i1 true)
; CHECK-NEXT:    [[EXEC_USER_CODE:%.*]] = icmp eq i32 [[TMP0]], -1
; CHECK-NEXT:    br i1 [[EXEC_USER_CODE]], label [[USER_CODE_ENTRY:%.*]], label [[WORKER_EXIT:%.*]]
; CHECK:       user_code.entry:
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @__kmpc_global_thread_num(%struct.ident_t* @[[GLOB1]]) #[[ATTR2:[0-9]+]]
; CHECK-NEXT:    store i32 [[TMP1]], i32* [[DOTTHREADID_TEMP_]], align 4
; CHECK-NEXT:    call void @__omp_outlined__(i32* noalias nocapture noundef nonnull readonly align 4 dereferenceable(4) [[DOTTHREADID_TEMP_]], i32* noalias nocapture noundef nonnull readnone align 4 dereferenceable(4) [[DOTZERO_ADDR]]) #[[ATTR2]]
; CHECK-NEXT:    call void @__kmpc_target_deinit(%struct.ident_t* @[[GLOB1]], i1 true, i1 true)
; CHECK-NEXT:    ret void
; CHECK:       worker.exit:
; CHECK-NEXT:    ret void
;
entry:
  %.zero.addr = alloca i32, align 4
  %.threadid_temp. = alloca i32, align 4
  store i32 0, i32* %.zero.addr, align 4
  %0 = call i32 @__kmpc_target_init(%struct.ident_t* @1, i1 false, i1 true, i1 true)
  %exec_user_code = icmp eq i32 %0, -1
  br i1 %exec_user_code, label %user_code.entry, label %worker.exit

user_code.entry:                                  ; preds = %entry
  %1 = call i32 @__kmpc_global_thread_num(%struct.ident_t* @1)
  store i32 %1, i32* %.threadid_temp., align 4
  call void @__omp_outlined__(i32* %.threadid_temp., i32* %.zero.addr) #2
  call void @__kmpc_target_deinit(%struct.ident_t* @1, i1 false, i1 true)
  ret void

worker.exit:                                      ; preds = %entry
  ret void
}

declare i32 @__kmpc_target_init(%struct.ident_t*, i1, i1, i1)

; Function Attrs: convergent norecurse nounwind
define internal void @__omp_outlined__(i32* noalias %.global_tid., i32* noalias %.bound_tid.) #0 {
; CHECK-LABEL: define {{[^@]+}}@__omp_outlined__
; CHECK-SAME: (i32* noalias nocapture nofree noundef nonnull readonly align 4 dereferenceable(4) [[DOTGLOBAL_TID_:%.*]], i32* noalias nocapture nofree nonnull readnone align 4 dereferenceable(4) [[DOTBOUND_TID_:%.*]]) #[[ATTR0]] {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CAPTURED_VARS_ADDRS:%.*]] = alloca [0 x i8*], align 8
; CHECK-NEXT:    br label [[FOR_COND:%.*]]
; CHECK:       for.cond:
; CHECK-NEXT:    [[I_0:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ [[INC:%.*]], [[FOR_INC:%.*]] ]
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i32 [[I_0]], 100
; CHECK-NEXT:    br i1 [[CMP]], label [[FOR_BODY:%.*]], label [[FOR_END:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[TMP0:%.*]] = load i32, i32* [[DOTGLOBAL_TID_]], align 4
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast [0 x i8*]* [[CAPTURED_VARS_ADDRS]] to i8**
; CHECK-NEXT:    call void @__kmpc_parallel_51(%struct.ident_t* noundef @[[GLOB1]], i32 [[TMP0]], i32 noundef 1, i32 noundef -1, i32 noundef -1, i8* noundef bitcast (void (i32*, i32*)* @__omp_outlined__1 to i8*), i8* noundef bitcast (void (i16, i32)* @__omp_outlined__1_wrapper to i8*), i8** noundef [[TMP1]], i64 noundef 0)
; CHECK-NEXT:    br label [[FOR_INC]]
; CHECK:       for.inc:
; CHECK-NEXT:    [[INC]] = add nsw i32 [[I_0]], 1
; CHECK-NEXT:    br label [[FOR_COND]], !llvm.loop [[LOOP8:![0-9]+]]
; CHECK:       for.end:
; CHECK-NEXT:    call void @spmd_amenable()
; CHECK-NEXT:    ret void
;
entry:
  %captured_vars_addrs = alloca [0 x i8*], align 8
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %i.0 = phi i32 [ 0, %entry ], [ %inc, %for.inc ]
  %cmp = icmp slt i32 %i.0, 100
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %0 = load i32, i32* %.global_tid., align 4
  %1 = bitcast [0 x i8*]* %captured_vars_addrs to i8**
  call void @__kmpc_parallel_51(%struct.ident_t* @1, i32 %0, i32 1, i32 -1, i32 -1, i8* bitcast (void (i32*, i32*)* @__omp_outlined__1 to i8*), i8* bitcast (void (i16, i32)* @__omp_outlined__1_wrapper to i8*), i8** %1, i64 0)
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %inc = add nsw i32 %i.0, 1
  br label %for.cond, !llvm.loop !6

for.end:                                          ; preds = %for.cond
  call void @spmd_amenable()
  ret void
}

; Function Attrs: convergent norecurse nounwind
define internal void @__omp_outlined__1(i32* noalias %.global_tid., i32* noalias %.bound_tid.) #0 {
; CHECK-LABEL: define {{[^@]+}}@__omp_outlined__1
; CHECK-SAME: (i32* noalias nocapture nofree readnone [[DOTGLOBAL_TID_:%.*]], i32* noalias nocapture nofree readnone [[DOTBOUND_TID_:%.*]]) #[[ATTR0]] {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    call void @unknown() #[[ATTR4:[0-9]+]]
; CHECK-NEXT:    ret void
;
entry:
  call void @unknown() #3
  ret void
}

; Function Attrs: convergent
declare void @unknown() #1

; Function Attrs: convergent norecurse nounwind
define internal void @__omp_outlined__1_wrapper(i16 zeroext %0, i32 %1) #0 {
; CHECK-LABEL: define {{[^@]+}}@__omp_outlined__1_wrapper
; CHECK-SAME: (i16 zeroext [[TMP0:%.*]], i32 [[TMP1:%.*]]) #[[ATTR0]] {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[DOTADDR1:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[DOTZERO_ADDR:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[GLOBAL_ARGS:%.*]] = alloca i8**, align 8
; CHECK-NEXT:    store i32 0, i32* [[DOTZERO_ADDR]], align 4
; CHECK-NEXT:    store i32 [[TMP1]], i32* [[DOTADDR1]], align 4
; CHECK-NEXT:    call void @__kmpc_get_shared_variables(i8*** [[GLOBAL_ARGS]])
; CHECK-NEXT:    call void @__omp_outlined__1(i32* [[DOTADDR1]], i32* [[DOTZERO_ADDR]]) #[[ATTR2]]
; CHECK-NEXT:    ret void
;
entry:
  %.addr1 = alloca i32, align 4
  %.zero.addr = alloca i32, align 4
  %global_args = alloca i8**, align 8
  store i32 0, i32* %.zero.addr, align 4
  store i32 %1, i32* %.addr1, align 4
  call void @__kmpc_get_shared_variables(i8*** %global_args)
  call void @__omp_outlined__1(i32* %.addr1, i32* %.zero.addr) #2
  ret void
}

declare void @__kmpc_get_shared_variables(i8***)

declare void @__kmpc_parallel_51(%struct.ident_t*, i32, i32, i32, i32, i8*, i8*, i8**, i64)

; Function Attrs: nounwind
declare i32 @__kmpc_global_thread_num(%struct.ident_t*) #2

declare void @__kmpc_target_deinit(%struct.ident_t*, i1, i1)

declare void @spmd_amenable() #4

attributes #0 = { convergent norecurse nounwind "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="sm_53" "target-features"="+ptx32,+sm_53" }
attributes #1 = { convergent "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="sm_53" "target-features"="+ptx32,+sm_53" }
attributes #2 = { nounwind }
attributes #3 = { convergent }
attributes #4 = { "llvm.assume"="ompx_spmd_amenable" }

!omp_offload.info = !{!0}
!nvvm.annotations = !{!1}
!llvm.module.flags = !{!2, !3, !4, !8, !9}
!llvm.ident = !{!5}

!0 = !{i32 0, i32 44, i32 232567, !"sequential_loop", i32 4, i32 0}
!1 = !{void ()* @__omp_offloading_2c_38c77_sequential_loop_l4, !"kernel", i32 1}
!2 = !{i32 1, !"wchar_size", i32 4}
!3 = !{i32 7, !"PIC Level", i32 2}
!4 = !{i32 7, !"frame-pointer", i32 2}
!5 = !{!"clang version 13.0.0"}
!6 = distinct !{!6, !7}
!7 = !{!"llvm.loop.mustprogress"}
!8 = !{i32 7, !"openmp", i32 50}
!9 = !{i32 7, !"openmp-device", i32 50}
;.
; CHECK: attributes #[[ATTR0]] = { convergent norecurse nounwind "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="sm_53" "target-features"="+ptx32,+sm_53" }
; CHECK: attributes #[[ATTR1:[0-9]+]] = { convergent "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="sm_53" "target-features"="+ptx32,+sm_53" }
; CHECK: attributes #[[ATTR2]] = { nounwind }
; CHECK: attributes #[[ATTR3:[0-9]+]] = { "llvm.assume"="ompx_spmd_amenable" }
; CHECK: attributes #[[ATTR4]] = { convergent }
;.
; CHECK: [[META0:![0-9]+]] = !{i32 0, i32 44, i32 232567, !"sequential_loop", i32 4, i32 0}
; CHECK: [[META1:![0-9]+]] = !{void ()* @__omp_offloading_2c_38c77_sequential_loop_l4, !"kernel", i32 1}
; CHECK: [[META2:![0-9]+]] = !{i32 1, !"wchar_size", i32 4}
; CHECK: [[META3:![0-9]+]] = !{i32 7, !"PIC Level", i32 2}
; CHECK: [[META4:![0-9]+]] = !{i32 7, !"frame-pointer", i32 2}
; CHECK: [[META5:![0-9]+]] = !{i32 7, !"openmp", i32 50}
; CHECK: [[META6:![0-9]+]] = !{i32 7, !"openmp-device", i32 50}
; CHECK: [[META7:![0-9]+]] = !{!"clang version 13.0.0"}
; CHECK: [[LOOP8]] = distinct !{!8, !9}
; CHECK: [[META9:![0-9]+]] = !{!"llvm.loop.mustprogress"}
;.
