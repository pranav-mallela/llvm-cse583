; ModuleID = '../samples/factorial.c'
source_filename = "../samples/factorial.c"
target datalayout = "e-m:e-p:64:64-i64:64-i128:128-n32:64-S128"
target triple = "riscv64"

; Function Attrs: noinline nounwind optnone
define dso_local signext i32 @factorial(i32 noundef signext %n) #0 !dbg !9 {
entry:
  %n.addr = alloca i32, align 4
  %i = alloca i32, align 4
  %fact = alloca i32, align 4
  store i32 %n, ptr %n.addr, align 4
  call void @llvm.dbg.declare(metadata ptr %n.addr, metadata !14, metadata !DIExpression()), !dbg !15
  call void @llvm.dbg.declare(metadata ptr %i, metadata !16, metadata !DIExpression()), !dbg !17
  call void @llvm.dbg.declare(metadata ptr %fact, metadata !18, metadata !DIExpression()), !dbg !19
  store i32 1, ptr %fact, align 4, !dbg !20
  store i32 1, ptr %i, align 4, !dbg !21
  br label %for.cond, !dbg !23

for.cond:                                         ; preds = %for.inc, %entry
  %0 = load i32, ptr %i, align 4, !dbg !24
  %1 = load i32, ptr %n.addr, align 4, !dbg !26
  %cmp = icmp sle i32 %0, %1, !dbg !27
  br i1 %cmp, label %for.body, label %for.end, !dbg !28

for.body:                                         ; preds = %for.cond
  %2 = load i32, ptr %fact, align 4, !dbg !29
  %3 = load i32, ptr %i, align 4, !dbg !31
  %mul = mul nsw i32 %2, %3, !dbg !32
  store i32 %mul, ptr %fact, align 4, !dbg !33
  br label %for.inc, !dbg !34

for.inc:                                          ; preds = %for.body
  %4 = load i32, ptr %i, align 4, !dbg !35
  %inc = add nsw i32 %4, 1, !dbg !35
  store i32 %inc, ptr %i, align 4, !dbg !35
  br label %for.cond, !dbg !36, !llvm.loop !37

for.end:                                          ; preds = %for.cond
  %5 = load i32, ptr %fact, align 4, !dbg !40
  ret i32 %5, !dbg !41
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind optnone
define dso_local signext i32 @main() #0 !dbg !42 {
entry:
  %retval = alloca i32, align 4
  %number = alloca i32, align 4
  %result = alloca i32, align 4
  store i32 0, ptr %retval, align 4
  call void @llvm.dbg.declare(metadata ptr %number, metadata !45, metadata !DIExpression()), !dbg !46
  store i32 5, ptr %number, align 4, !dbg !46
  call void @llvm.dbg.declare(metadata ptr %result, metadata !47, metadata !DIExpression()), !dbg !48
  %0 = load i32, ptr %number, align 4, !dbg !49
  %call = call signext i32 @factorial(i32 noundef signext %0), !dbg !50
  store i32 %call, ptr %result, align 4, !dbg !48
  ret i32 0, !dbg !51
}

attributes #0 = { noinline nounwind optnone "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic-rv64" "target-features"="+64bit,+a,+c,+m,+relax,-d,-e,-experimental-zawrs,-experimental-zca,-experimental-zcd,-experimental-zcf,-experimental-zihintntl,-experimental-ztso,-experimental-zvfh,-f,-h,-save-restore,-svinval,-svnapot,-svpbmt,-v,-xtheadvdot,-xventanacondops,-zba,-zbb,-zbc,-zbkb,-zbkc,-zbkx,-zbs,-zdinx,-zfh,-zfhmin,-zfinx,-zhinx,-zhinxmin,-zicbom,-zicbop,-zicboz,-zihintpause,-zk,-zkn,-zknd,-zkne,-zknh,-zkr,-zks,-zksed,-zksh,-zkt,-zmmul,-zve32f,-zve32x,-zve64d,-zve64f,-zve64x,-zvl1024b,-zvl128b,-zvl16384b,-zvl2048b,-zvl256b,-zvl32768b,-zvl32b,-zvl4096b,-zvl512b,-zvl64b,-zvl65536b,-zvl8192b" }
attributes #1 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!2, !3, !4, !5, !6, !7}
!llvm.ident = !{!8}

!0 = distinct !DICompileUnit(language: DW_LANG_C11, file: !1, producer: "clang version 16.0.0 (git@github.com:pranav-mallela/llvm-cse583.git c76bee6c6385876daafb8d09b2785b5212555ca5)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "../samples/factorial.c", directory: "/home/pmallela/CSE583/llvm-cse583/build", checksumkind: CSK_MD5, checksum: "cf2330f5af87b96bb6927b4e4cfe76b8")
!2 = !{i32 7, !"Dwarf Version", i32 5}
!3 = !{i32 2, !"Debug Info Version", i32 3}
!4 = !{i32 1, !"wchar_size", i32 4}
!5 = !{i32 1, !"target-abi", !"lp64"}
!6 = !{i32 7, !"frame-pointer", i32 2}
!7 = !{i32 1, !"SmallDataLimit", i32 8}
!8 = !{!"clang version 16.0.0 (git@github.com:pranav-mallela/llvm-cse583.git c76bee6c6385876daafb8d09b2785b5212555ca5)"}
!9 = distinct !DISubprogram(name: "factorial", scope: !1, file: !1, line: 1, type: !10, scopeLine: 2, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !13)
!10 = !DISubroutineType(types: !11)
!11 = !{!12, !12}
!12 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!13 = !{}
!14 = !DILocalVariable(name: "n", arg: 1, scope: !9, file: !1, line: 1, type: !12)
!15 = !DILocation(line: 1, column: 19, scope: !9)
!16 = !DILocalVariable(name: "i", scope: !9, file: !1, line: 3, type: !12)
!17 = !DILocation(line: 3, column: 7, scope: !9)
!18 = !DILocalVariable(name: "fact", scope: !9, file: !1, line: 3, type: !12)
!19 = !DILocation(line: 3, column: 9, scope: !9)
!20 = !DILocation(line: 4, column: 8, scope: !9)
!21 = !DILocation(line: 5, column: 8, scope: !22)
!22 = distinct !DILexicalBlock(scope: !9, file: !1, line: 5, column: 3)
!23 = !DILocation(line: 5, column: 7, scope: !22)
!24 = !DILocation(line: 5, column: 11, scope: !25)
!25 = distinct !DILexicalBlock(scope: !22, file: !1, line: 5, column: 3)
!26 = !DILocation(line: 5, column: 14, scope: !25)
!27 = !DILocation(line: 5, column: 12, scope: !25)
!28 = !DILocation(line: 5, column: 3, scope: !22)
!29 = !DILocation(line: 7, column: 12, scope: !30)
!30 = distinct !DILexicalBlock(scope: !25, file: !1, line: 6, column: 3)
!31 = !DILocation(line: 7, column: 19, scope: !30)
!32 = !DILocation(line: 7, column: 17, scope: !30)
!33 = !DILocation(line: 7, column: 10, scope: !30)
!34 = !DILocation(line: 8, column: 3, scope: !30)
!35 = !DILocation(line: 5, column: 17, scope: !25)
!36 = !DILocation(line: 5, column: 3, scope: !25)
!37 = distinct !{!37, !28, !38, !39}
!38 = !DILocation(line: 8, column: 3, scope: !22)
!39 = !{!"llvm.loop.mustprogress"}
!40 = !DILocation(line: 9, column: 10, scope: !9)
!41 = !DILocation(line: 9, column: 3, scope: !9)
!42 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 12, type: !43, scopeLine: 13, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !13)
!43 = !DISubroutineType(types: !44)
!44 = !{!12}
!45 = !DILocalVariable(name: "number", scope: !42, file: !1, line: 14, type: !12)
!46 = !DILocation(line: 14, column: 7, scope: !42)
!47 = !DILocalVariable(name: "result", scope: !42, file: !1, line: 15, type: !12)
!48 = !DILocation(line: 15, column: 7, scope: !42)
!49 = !DILocation(line: 15, column: 26, scope: !42)
!50 = !DILocation(line: 15, column: 16, scope: !42)
!51 = !DILocation(line: 16, column: 3, scope: !42)
