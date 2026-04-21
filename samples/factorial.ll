; ModuleID = '../samples/factorial.c'
source_filename = "../samples/factorial.c"
target datalayout = "e-m:e-p:64:64-i64:64-i128:128-n32:64-S128"
target triple = "riscv64"

@number = dso_local global i32 5, align 4, !dbg !0
@sink = dso_local global i32 0, align 4, !dbg !5

; Function Attrs: noinline nounwind optnone
define dso_local signext i32 @factorial(i32 noundef signext %n) #0 !dbg !16 {
entry:
  %n.addr = alloca i32, align 4
  %i = alloca i32, align 4
  %fact = alloca i32, align 4
  store i32 %n, ptr %n.addr, align 4
  call void @llvm.dbg.declare(metadata ptr %n.addr, metadata !20, metadata !DIExpression()), !dbg !21
  call void @llvm.dbg.declare(metadata ptr %i, metadata !22, metadata !DIExpression()), !dbg !23
  call void @llvm.dbg.declare(metadata ptr %fact, metadata !24, metadata !DIExpression()), !dbg !25
  store i32 1, ptr %fact, align 4, !dbg !26
  store i32 1, ptr %i, align 4, !dbg !27
  br label %for.cond, !dbg !29

for.cond:                                         ; preds = %for.inc, %entry
  %0 = load i32, ptr %i, align 4, !dbg !30
  %1 = load i32, ptr %n.addr, align 4, !dbg !32
  %cmp = icmp sle i32 %0, %1, !dbg !33
  br i1 %cmp, label %for.body, label %for.end, !dbg !34

for.body:                                         ; preds = %for.cond
  %2 = load i32, ptr %fact, align 4, !dbg !35
  %3 = load i32, ptr %i, align 4, !dbg !37
  %mul = mul nsw i32 %2, %3, !dbg !38
  store i32 %mul, ptr %fact, align 4, !dbg !39
  br label %for.inc, !dbg !40

for.inc:                                          ; preds = %for.body
  %4 = load i32, ptr %i, align 4, !dbg !41
  %inc = add nsw i32 %4, 1, !dbg !41
  store i32 %inc, ptr %i, align 4, !dbg !41
  br label %for.cond, !dbg !42, !llvm.loop !43

for.end:                                          ; preds = %for.cond
  %5 = load i32, ptr %fact, align 4, !dbg !46
  ret i32 %5, !dbg !47
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind optnone
define dso_local signext i32 @main() #0 !dbg !48 {
entry:
  %retval = alloca i32, align 4
  %result = alloca i32, align 4
  store i32 0, ptr %retval, align 4
  call void @llvm.dbg.declare(metadata ptr %result, metadata !51, metadata !DIExpression()), !dbg !52
  %0 = load volatile i32, ptr @number, align 4, !dbg !53
  %call = call signext i32 @factorial(i32 noundef signext %0), !dbg !54
  store i32 %call, ptr %result, align 4, !dbg !52
  %1 = load i32, ptr %result, align 4, !dbg !55
  store volatile i32 %1, ptr @sink, align 4, !dbg !56
  ret i32 0, !dbg !57
}

attributes #0 = { noinline nounwind optnone "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic-rv64" "target-features"="+64bit,+a,+c,+m,+relax,-d,-e,-experimental-zawrs,-experimental-zca,-experimental-zcd,-experimental-zcf,-experimental-zihintntl,-experimental-ztso,-experimental-zvfh,-f,-h,-save-restore,-svinval,-svnapot,-svpbmt,-v,-xtheadvdot,-xventanacondops,-zba,-zbb,-zbc,-zbkb,-zbkc,-zbkx,-zbs,-zdinx,-zfh,-zfhmin,-zfinx,-zhinx,-zhinxmin,-zicbom,-zicbop,-zicboz,-zihintpause,-zk,-zkn,-zknd,-zkne,-zknh,-zkr,-zks,-zksed,-zksh,-zkt,-zmmul,-zve32f,-zve32x,-zve64d,-zve64f,-zve64x,-zvl1024b,-zvl128b,-zvl16384b,-zvl2048b,-zvl256b,-zvl32768b,-zvl32b,-zvl4096b,-zvl512b,-zvl64b,-zvl65536b,-zvl8192b" }
attributes #1 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!9, !10, !11, !12, !13, !14}
!llvm.ident = !{!15}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "number", scope: !2, file: !3, line: 1, type: !7, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "clang version 16.0.0 (git@github.com:pranav-mallela/llvm-cse583.git 538aaea3bc2f7c4d1cf336b68bd782edbccab061)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, globals: !4, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "../samples/factorial.c", directory: "/home/pmallela/CSE583/llvm-cse583/build", checksumkind: CSK_MD5, checksum: "5a5df986b8109ae3b6b49ece1f95ece2")
!4 = !{!0, !5}
!5 = !DIGlobalVariableExpression(var: !6, expr: !DIExpression())
!6 = distinct !DIGlobalVariable(name: "sink", scope: !2, file: !3, line: 2, type: !7, isLocal: false, isDefinition: true)
!7 = !DIDerivedType(tag: DW_TAG_volatile_type, baseType: !8)
!8 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!9 = !{i32 7, !"Dwarf Version", i32 5}
!10 = !{i32 2, !"Debug Info Version", i32 3}
!11 = !{i32 1, !"wchar_size", i32 4}
!12 = !{i32 1, !"target-abi", !"lp64"}
!13 = !{i32 7, !"frame-pointer", i32 2}
!14 = !{i32 1, !"SmallDataLimit", i32 8}
!15 = !{!"clang version 16.0.0 (git@github.com:pranav-mallela/llvm-cse583.git 538aaea3bc2f7c4d1cf336b68bd782edbccab061)"}
!16 = distinct !DISubprogram(name: "factorial", scope: !3, file: !3, line: 5, type: !17, scopeLine: 6, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !19)
!17 = !DISubroutineType(types: !18)
!18 = !{!8, !8}
!19 = !{}
!20 = !DILocalVariable(name: "n", arg: 1, scope: !16, file: !3, line: 5, type: !8)
!21 = !DILocation(line: 5, column: 19, scope: !16)
!22 = !DILocalVariable(name: "i", scope: !16, file: !3, line: 7, type: !8)
!23 = !DILocation(line: 7, column: 9, scope: !16)
!24 = !DILocalVariable(name: "fact", scope: !16, file: !3, line: 7, type: !8)
!25 = !DILocation(line: 7, column: 12, scope: !16)
!26 = !DILocation(line: 8, column: 10, scope: !16)
!27 = !DILocation(line: 9, column: 12, scope: !28)
!28 = distinct !DILexicalBlock(scope: !16, file: !3, line: 9, column: 5)
!29 = !DILocation(line: 9, column: 10, scope: !28)
!30 = !DILocation(line: 9, column: 17, scope: !31)
!31 = distinct !DILexicalBlock(scope: !28, file: !3, line: 9, column: 5)
!32 = !DILocation(line: 9, column: 22, scope: !31)
!33 = !DILocation(line: 9, column: 19, scope: !31)
!34 = !DILocation(line: 9, column: 5, scope: !28)
!35 = !DILocation(line: 11, column: 16, scope: !36)
!36 = distinct !DILexicalBlock(scope: !31, file: !3, line: 10, column: 5)
!37 = !DILocation(line: 11, column: 23, scope: !36)
!38 = !DILocation(line: 11, column: 21, scope: !36)
!39 = !DILocation(line: 11, column: 14, scope: !36)
!40 = !DILocation(line: 12, column: 5, scope: !36)
!41 = !DILocation(line: 9, column: 26, scope: !31)
!42 = !DILocation(line: 9, column: 5, scope: !31)
!43 = distinct !{!43, !34, !44, !45}
!44 = !DILocation(line: 12, column: 5, scope: !28)
!45 = !{!"llvm.loop.mustprogress"}
!46 = !DILocation(line: 13, column: 12, scope: !16)
!47 = !DILocation(line: 13, column: 5, scope: !16)
!48 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 16, type: !49, scopeLine: 17, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !19)
!49 = !DISubroutineType(types: !50)
!50 = !{!8}
!51 = !DILocalVariable(name: "result", scope: !48, file: !3, line: 18, type: !8)
!52 = !DILocation(line: 18, column: 9, scope: !48)
!53 = !DILocation(line: 18, column: 28, scope: !48)
!54 = !DILocation(line: 18, column: 18, scope: !48)
!55 = !DILocation(line: 19, column: 12, scope: !48)
!56 = !DILocation(line: 19, column: 10, scope: !48)
!57 = !DILocation(line: 20, column: 5, scope: !48)
