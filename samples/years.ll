; ModuleID = '../samples/years.c'
source_filename = "../samples/years.c"
target datalayout = "e-m:e-p:64:64-i64:64-i128:128-n32:64-S128"
target triple = "riscv64"

; Function Attrs: noinline nounwind optnone
define dso_local signext i32 @countYears() #0 !dbg !9 {
entry:
  %res = alloca i32, align 4
  %year = alloca i32, align 4
  call void @llvm.dbg.declare(metadata ptr %res, metadata !14, metadata !DIExpression()), !dbg !15
  store i32 0, ptr %res, align 4, !dbg !15
  call void @llvm.dbg.declare(metadata ptr %year, metadata !16, metadata !DIExpression()), !dbg !18
  store i32 7, ptr %year, align 4, !dbg !18
  br label %for.cond, !dbg !19

for.cond:                                         ; preds = %for.inc, %entry
  %0 = load i32, ptr %year, align 4, !dbg !20
  %cmp = icmp sgt i32 %0, 0, !dbg !22
  br i1 %cmp, label %for.body, label %for.end, !dbg !23

for.body:                                         ; preds = %for.cond
  %1 = load i32, ptr %year, align 4, !dbg !24
  %rem = srem i32 %1, 2, !dbg !26
  %cmp1 = icmp eq i32 %rem, 0, !dbg !27
  br i1 %cmp1, label %land.lhs.true, label %if.end, !dbg !28

land.lhs.true:                                    ; preds = %for.body
  %2 = load i32, ptr %year, align 4, !dbg !29
  %rem2 = srem i32 %2, 4, !dbg !30
  %cmp3 = icmp ne i32 %rem2, 0, !dbg !31
  br i1 %cmp3, label %if.then, label %if.end, !dbg !32

if.then:                                          ; preds = %land.lhs.true
  %3 = load i32, ptr %res, align 4, !dbg !33
  %inc = add nsw i32 %3, 1, !dbg !33
  store i32 %inc, ptr %res, align 4, !dbg !33
  br label %if.end, !dbg !34

if.end:                                           ; preds = %if.then, %land.lhs.true, %for.body
  br label %for.inc, !dbg !35

for.inc:                                          ; preds = %if.end
  %4 = load i32, ptr %year, align 4, !dbg !36
  %dec = add nsw i32 %4, -1, !dbg !36
  store i32 %dec, ptr %year, align 4, !dbg !36
  br label %for.cond, !dbg !37, !llvm.loop !38

for.end:                                          ; preds = %for.cond
  %5 = load i32, ptr %res, align 4, !dbg !41
  ret i32 %5, !dbg !42
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

attributes #0 = { noinline nounwind optnone "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic-rv64" "target-features"="+64bit,+a,+c,+m,+relax,-d,-e,-experimental-zawrs,-experimental-zca,-experimental-zcd,-experimental-zcf,-experimental-zihintntl,-experimental-ztso,-experimental-zvfh,-f,-h,-save-restore,-svinval,-svnapot,-svpbmt,-v,-xtheadvdot,-xventanacondops,-zba,-zbb,-zbc,-zbkb,-zbkc,-zbkx,-zbs,-zdinx,-zfh,-zfhmin,-zfinx,-zhinx,-zhinxmin,-zicbom,-zicbop,-zicboz,-zihintpause,-zk,-zkn,-zknd,-zkne,-zknh,-zkr,-zks,-zksed,-zksh,-zkt,-zmmul,-zve32f,-zve32x,-zve64d,-zve64f,-zve64x,-zvl1024b,-zvl128b,-zvl16384b,-zvl2048b,-zvl256b,-zvl32768b,-zvl32b,-zvl4096b,-zvl512b,-zvl64b,-zvl65536b,-zvl8192b" }
attributes #1 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!2, !3, !4, !5, !6, !7}
!llvm.ident = !{!8}

!0 = distinct !DICompileUnit(language: DW_LANG_C11, file: !1, producer: "clang version 16.0.0 (git@github.com:pranav-mallela/llvm-cse583.git 25eac4a017d7281591c86020790c695d7b2b931d)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "../samples/years.c", directory: "/home/pmallela/CSE583/llvm-cse583/build", checksumkind: CSK_MD5, checksum: "938363177ce4cdb3a6467514902341ab")
!2 = !{i32 7, !"Dwarf Version", i32 5}
!3 = !{i32 2, !"Debug Info Version", i32 3}
!4 = !{i32 1, !"wchar_size", i32 4}
!5 = !{i32 1, !"target-abi", !"lp64"}
!6 = !{i32 7, !"frame-pointer", i32 2}
!7 = !{i32 1, !"SmallDataLimit", i32 8}
!8 = !{!"clang version 16.0.0 (git@github.com:pranav-mallela/llvm-cse583.git 25eac4a017d7281591c86020790c695d7b2b931d)"}
!9 = distinct !DISubprogram(name: "countYears", scope: !1, file: !1, line: 1, type: !10, scopeLine: 1, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !13)
!10 = !DISubroutineType(types: !11)
!11 = !{!12}
!12 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!13 = !{}
!14 = !DILocalVariable(name: "res", scope: !9, file: !1, line: 2, type: !12)
!15 = !DILocation(line: 2, column: 9, scope: !9)
!16 = !DILocalVariable(name: "year", scope: !17, file: !1, line: 3, type: !12)
!17 = distinct !DILexicalBlock(scope: !9, file: !1, line: 3, column: 5)
!18 = !DILocation(line: 3, column: 13, scope: !17)
!19 = !DILocation(line: 3, column: 9, scope: !17)
!20 = !DILocation(line: 3, column: 20, scope: !21)
!21 = distinct !DILexicalBlock(scope: !17, file: !1, line: 3, column: 5)
!22 = !DILocation(line: 3, column: 24, scope: !21)
!23 = !DILocation(line: 3, column: 5, scope: !17)
!24 = !DILocation(line: 4, column: 9, scope: !25)
!25 = distinct !DILexicalBlock(scope: !21, file: !1, line: 4, column: 8)
!26 = !DILocation(line: 4, column: 13, scope: !25)
!27 = !DILocation(line: 4, column: 15, scope: !25)
!28 = !DILocation(line: 4, column: 19, scope: !25)
!29 = !DILocation(line: 4, column: 22, scope: !25)
!30 = !DILocation(line: 4, column: 26, scope: !25)
!31 = !DILocation(line: 4, column: 28, scope: !25)
!32 = !DILocation(line: 4, column: 8, scope: !21)
!33 = !DILocation(line: 4, column: 37, scope: !25)
!34 = !DILocation(line: 4, column: 34, scope: !25)
!35 = !DILocation(line: 4, column: 31, scope: !25)
!36 = !DILocation(line: 3, column: 31, scope: !21)
!37 = !DILocation(line: 3, column: 5, scope: !21)
!38 = distinct !{!38, !23, !39, !40}
!39 = !DILocation(line: 4, column: 37, scope: !17)
!40 = !{!"llvm.loop.mustprogress"}
!41 = !DILocation(line: 5, column: 12, scope: !9)
!42 = !DILocation(line: 5, column: 5, scope: !9)
