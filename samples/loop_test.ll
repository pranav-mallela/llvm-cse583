; ModuleID = '../samples/loop_test.c'
source_filename = "../samples/loop_test.c"
target datalayout = "e-m:e-p:64:64-i64:64-i128:128-n32:64-S128"
target triple = "riscv64"

; Function Attrs: noinline nounwind optnone
define dso_local signext i32 @loop_test(i32 noundef signext %n) #0 !dbg !9 {
entry:
  %n.addr = alloca i32, align 4
  %sum = alloca i32, align 4
  %i = alloca i32, align 4
  store i32 %n, ptr %n.addr, align 4
  call void @llvm.dbg.declare(metadata ptr %n.addr, metadata !14, metadata !DIExpression()), !dbg !15
  call void @llvm.dbg.declare(metadata ptr %sum, metadata !16, metadata !DIExpression()), !dbg !17
  store i32 0, ptr %sum, align 4, !dbg !17
  call void @llvm.dbg.declare(metadata ptr %i, metadata !18, metadata !DIExpression()), !dbg !20
  store i32 0, ptr %i, align 4, !dbg !20
  br label %for.cond, !dbg !21

for.cond:                                         ; preds = %for.inc, %entry
  %0 = load i32, ptr %i, align 4, !dbg !22
  %1 = load i32, ptr %n.addr, align 4, !dbg !24
  %cmp = icmp slt i32 %0, %1, !dbg !25
  br i1 %cmp, label %for.body, label %for.end, !dbg !26

for.body:                                         ; preds = %for.cond
  %2 = load i32, ptr %i, align 4, !dbg !27
  %3 = load i32, ptr %sum, align 4, !dbg !29
  %xor = xor i32 %3, %2, !dbg !29
  store i32 %xor, ptr %sum, align 4, !dbg !29
  br label %for.inc, !dbg !30

for.inc:                                          ; preds = %for.body
  %4 = load i32, ptr %i, align 4, !dbg !31
  %inc = add nsw i32 %4, 1, !dbg !31
  store i32 %inc, ptr %i, align 4, !dbg !31
  br label %for.cond, !dbg !32, !llvm.loop !33

for.end:                                          ; preds = %for.cond
  %5 = load i32, ptr %sum, align 4, !dbg !36
  ret i32 %5, !dbg !37
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

attributes #0 = { noinline nounwind optnone "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic-rv64" "target-features"="+64bit,+a,+c,+m,+relax,-d,-e,-experimental-zawrs,-experimental-zca,-experimental-zcd,-experimental-zcf,-experimental-zihintntl,-experimental-ztso,-experimental-zvfh,-f,-h,-save-restore,-svinval,-svnapot,-svpbmt,-v,-xtheadvdot,-xventanacondops,-zba,-zbb,-zbc,-zbkb,-zbkc,-zbkx,-zbs,-zdinx,-zfh,-zfhmin,-zfinx,-zhinx,-zhinxmin,-zicbom,-zicbop,-zicboz,-zihintpause,-zk,-zkn,-zknd,-zkne,-zknh,-zkr,-zks,-zksed,-zksh,-zkt,-zmmul,-zve32f,-zve32x,-zve64d,-zve64f,-zve64x,-zvl1024b,-zvl128b,-zvl16384b,-zvl2048b,-zvl256b,-zvl32768b,-zvl32b,-zvl4096b,-zvl512b,-zvl64b,-zvl65536b,-zvl8192b" }
attributes #1 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!2, !3, !4, !5, !6, !7}
!llvm.ident = !{!8}

!0 = distinct !DICompileUnit(language: DW_LANG_C11, file: !1, producer: "clang version 16.0.0 (git@github.com:pranav-mallela/llvm-cse583.git 6a4d8c9ae13c37491d9c074fc1d7848cf82c528b)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "../samples/loop_test.c", directory: "/home/pmallela/CSE583/llvm-cse583/build", checksumkind: CSK_MD5, checksum: "6faa68575c0aa1ef12d852e8091d83d2")
!2 = !{i32 7, !"Dwarf Version", i32 5}
!3 = !{i32 2, !"Debug Info Version", i32 3}
!4 = !{i32 1, !"wchar_size", i32 4}
!5 = !{i32 1, !"target-abi", !"lp64"}
!6 = !{i32 7, !"frame-pointer", i32 2}
!7 = !{i32 1, !"SmallDataLimit", i32 8}
!8 = !{!"clang version 16.0.0 (git@github.com:pranav-mallela/llvm-cse583.git 6a4d8c9ae13c37491d9c074fc1d7848cf82c528b)"}
!9 = distinct !DISubprogram(name: "loop_test", scope: !1, file: !1, line: 1, type: !10, scopeLine: 1, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !13)
!10 = !DISubroutineType(types: !11)
!11 = !{!12, !12}
!12 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!13 = !{}
!14 = !DILocalVariable(name: "n", arg: 1, scope: !9, file: !1, line: 1, type: !12)
!15 = !DILocation(line: 1, column: 19, scope: !9)
!16 = !DILocalVariable(name: "sum", scope: !9, file: !1, line: 2, type: !12)
!17 = !DILocation(line: 2, column: 9, scope: !9)
!18 = !DILocalVariable(name: "i", scope: !19, file: !1, line: 3, type: !12)
!19 = distinct !DILexicalBlock(scope: !9, file: !1, line: 3, column: 5)
!20 = !DILocation(line: 3, column: 13, scope: !19)
!21 = !DILocation(line: 3, column: 9, scope: !19)
!22 = !DILocation(line: 3, column: 20, scope: !23)
!23 = distinct !DILexicalBlock(scope: !19, file: !1, line: 3, column: 5)
!24 = !DILocation(line: 3, column: 24, scope: !23)
!25 = !DILocation(line: 3, column: 22, scope: !23)
!26 = !DILocation(line: 3, column: 5, scope: !19)
!27 = !DILocation(line: 4, column: 16, scope: !28)
!28 = distinct !DILexicalBlock(scope: !23, file: !1, line: 3, column: 32)
!29 = !DILocation(line: 4, column: 13, scope: !28)
!30 = !DILocation(line: 5, column: 5, scope: !28)
!31 = !DILocation(line: 3, column: 28, scope: !23)
!32 = !DILocation(line: 3, column: 5, scope: !23)
!33 = distinct !{!33, !26, !34, !35}
!34 = !DILocation(line: 5, column: 5, scope: !19)
!35 = !{!"llvm.loop.mustprogress"}
!36 = !DILocation(line: 6, column: 12, scope: !9)
!37 = !DILocation(line: 6, column: 5, scope: !9)
