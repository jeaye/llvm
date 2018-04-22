; RUN: llvm-c-test --test-dibuilder | FileCheck %s

; CHECK: ; ModuleID = 'debuginfo.c'
; CHECK-NEXT: source_filename = "debuginfo.c"

; CHECK:      define i64 @foo(i64, i64) !dbg !7 {
; CHECK-NEXT: entry:
; CHECK-NEXT:   call void @llvm.dbg.declare(metadata i64 0, metadata !11, metadata !DIExpression()), !dbg !13
; CHECK-NEXT:   call void @llvm.dbg.declare(metadata i64 0, metadata !12, metadata !DIExpression()), !dbg !13
; CHECK-NEXT: }

; CHECK: declare void @llvm.dbg.declare(metadata, metadata, metadata) #0

; CHECK: declare !dbg !14 i64 @foo_inner_scope(i64, i64)

; CHECK: !llvm.dbg.cu = !{!0}
; CHECK-NEXT: !FooType = !{!3}

; CHECK:      !0 = distinct !DICompileUnit(language: DW_LANG_C, file: !1, producer: "llvm-c-test", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, splitDebugInlining: false)
; CHECK-NEXT: !1 = !DIFile(filename: "debuginfo.c", directory: ".")
; CHECK-NEXT: !2 = !{}
; CHECK-NEXT: !3 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !4, size: 192, dwarfAddressSpace: 0)
; CHECK-NEXT: !4 = !DICompositeType(tag: DW_TAG_structure_type, name: "MyStruct", file: !1, size: 192, elements: !5, runtimeLang: DW_LANG_C89, identifier: "MyStruct")
; CHECK-NEXT: !5 = !{!6, !6, !6}
; CHECK-NEXT: !6 = !DIBasicType(name: "Int64", size: 64)
; CHECK-NEXT: !7 = distinct !DISubprogram(name: "foo", linkageName: "foo", scope: !1, file: !1, line: 42, type: !8, isLocal: true, isDefinition: true, scopeLine: 42, isOptimized: false, unit: !0, variables: !10)
; CHECK-NEXT: !8 = !DISubroutineType(types: !9)
; CHECK-NEXT: !9 = !{!6, !6}
; CHECK-NEXT: !10 = !{!11, !12}
; CHECK-NEXT: !11 = !DILocalVariable(name: "a", arg: 1, scope: !7, file: !1, line: 42, type: !6)
; CHECK-NEXT: !12 = !DILocalVariable(name: "b", arg: 2, scope: !7, file: !1, line: 42, type: !6)
; CHECK-NEXT: !13 = !DILocation(line: 42, scope: !7)
; CHECK-NEXT: !14 = distinct !DISubprogram(name: "foo_inner_scope", linkageName: "foo_inner_scope", scope: !15, file: !1, line: 42, type: !8, isLocal: true, isDefinition: true, scopeLine: 42, isOptimized: false, unit: !0, variables: !2)
; CHECK-NEXT: !15 = distinct !DILexicalBlock(scope: !7, file: !1, line: 42)

