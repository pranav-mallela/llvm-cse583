; ModuleID = '../samples/fib.c'
source_filename = "../samples/fib.c"
target datalayout = "e-m:e-p:64:64-i64:64-i128:128-n32:64-S128"
target triple = "riscv64"

@input = dso_local global i32 10, align 4, !dbg !0
@sink = dso_local global i32 0, align 4, !dbg !5

; Function Attrs: noinline nounwind optnone
define dso_local signext i32 @fib(i32 noundef signext %n) #0 !dbg !16 {
entry:
  %n.addr = alloca i32, align 4
  %fib0 = alloca i32, align 4
  %fib1 = alloca i32, align 4
  %result = alloca i32, align 4
  %i = alloca i32, align 4
  store i32 %n, ptr %n.addr, align 4
  call void @llvm.dbg.declare(metadata ptr %n.addr, metadata !20, metadata !DIExpression()), !dbg !21
  call void @llvm.dbg.declare(metadata ptr %fib0, metadata !22, metadata !DIExpression()), !dbg !23
  store i32 0, ptr %fib0, align 4, !dbg !23
  call void @llvm.dbg.declare(metadata ptr %fib1, metadata !24, metadata !DIExpression()), !dbg !25
  store i32 1, ptr %fib1, align 4, !dbg !25
  call void @llvm.dbg.declare(metadata ptr %result, metadata !26, metadata !DIExpression()), !dbg !27
  store i32 0, ptr %result, align 4, !dbg !27
  %0 = load i32, ptr %n.addr, align 4, !dbg !28
  %cmp = icmp eq i32 %0, 0, !dbg !30
  br i1 %cmp, label %if.then, label %if.else, !dbg !31

if.then:                                          ; preds = %entry
  store i32 0, ptr %result, align 4, !dbg !32
  br label %if.end10, !dbg !34

if.else:                                          ; preds = %entry
  %1 = load i32, ptr %n.addr, align 4, !dbg !35
  %cmp1 = icmp eq i32 %1, 1, !dbg !37
  br i1 %cmp1, label %if.then2, label %if.else3, !dbg !38

if.then2:                                         ; preds = %if.else
  store i32 1, ptr %result, align 4, !dbg !39
  br label %if.end9, !dbg !41

if.else3:                                         ; preds = %if.else
  call void @llvm.dbg.declare(metadata ptr %i, metadata !42, metadata !DIExpression()), !dbg !45
  store i32 0, ptr %i, align 4, !dbg !46
  br label %for.cond, !dbg !48

for.cond:                                         ; preds = %for.inc, %if.else3
  %2 = load i32, ptr %i, align 4, !dbg !49
  %3 = load i32, ptr %n.addr, align 4, !dbg !51
  %sub = sub i32 %3, 1, !dbg !52
  %cmp4 = icmp ult i32 %2, %sub, !dbg !53
  br i1 %cmp4, label %for.body, label %for.end, !dbg !54

for.body:                                         ; preds = %for.cond
  %4 = load i32, ptr %i, align 4, !dbg !55
  %rem = srem i32 %4, 2, !dbg !58
  %cmp5 = icmp eq i32 %rem, 0, !dbg !59
  br i1 %cmp5, label %if.then6, label %if.else7, !dbg !60

if.then6:                                         ; preds = %for.body
  %5 = load i32, ptr %fib1, align 4, !dbg !61
  %6 = load i32, ptr %fib0, align 4, !dbg !63
  %add = add i32 %6, %5, !dbg !63
  store i32 %add, ptr %fib0, align 4, !dbg !63
  %7 = load i32, ptr %fib0, align 4, !dbg !64
  store i32 %7, ptr %result, align 4, !dbg !65
  br label %if.end, !dbg !66

if.else7:                                         ; preds = %for.body
  %8 = load i32, ptr %fib0, align 4, !dbg !67
  %9 = load i32, ptr %fib1, align 4, !dbg !69
  %add8 = add i32 %9, %8, !dbg !69
  store i32 %add8, ptr %fib1, align 4, !dbg !69
  %10 = load i32, ptr %fib1, align 4, !dbg !70
  store i32 %10, ptr %result, align 4, !dbg !71
  br label %if.end

if.end:                                           ; preds = %if.else7, %if.then6
  br label %for.inc, !dbg !72

for.inc:                                          ; preds = %if.end
  %11 = load i32, ptr %i, align 4, !dbg !73
  %inc = add nsw i32 %11, 1, !dbg !73
  store i32 %inc, ptr %i, align 4, !dbg !73
  br label %for.cond, !dbg !74, !llvm.loop !75

for.end:                                          ; preds = %for.cond
  br label %if.end9

if.end9:                                          ; preds = %for.end, %if.then2
  br label %if.end10

if.end10:                                         ; preds = %if.end9, %if.then
  %12 = load i32, ptr %result, align 4, !dbg !78
  ret i32 %12, !dbg !79
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind optnone
define dso_local signext i32 @main() #0 !dbg !80 {
entry:
  %retval = alloca i32, align 4
  %result = alloca i32, align 4
  store i32 0, ptr %retval, align 4
  call void @llvm.dbg.declare(metadata ptr %result, metadata !83, metadata !DIExpression()), !dbg !84
  %0 = load volatile i32, ptr @input, align 4, !dbg !85
  %call = call signext i32 @fib(i32 noundef signext %0), !dbg !86
  store i32 %call, ptr %result, align 4, !dbg !84
  %1 = load i32, ptr %result, align 4, !dbg !87
  store volatile i32 %1, ptr @sink, align 4, !dbg !88
  ret i32 0, !dbg !89
}

attributes #0 = { noinline nounwind optnone "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic-rv64" "target-features"="+64bit,+a,+c,+m,+relax,-d,-e,-experimental-zawrs,-experimental-zca,-experimental-zcd,-experimental-zcf,-experimental-zihintntl,-experimental-ztso,-experimental-zvfh,-f,-h,-save-restore,-svinval,-svnapot,-svpbmt,-v,-xtheadvdot,-xventanacondops,-zba,-zbb,-zbc,-zbkb,-zbkc,-zbkx,-zbs,-zdinx,-zfh,-zfhmin,-zfinx,-zhinx,-zhinxmin,-zicbom,-zicbop,-zicboz,-zihintpause,-zk,-zkn,-zknd,-zkne,-zknh,-zkr,-zks,-zksed,-zksh,-zkt,-zmmul,-zve32f,-zve32x,-zve64d,-zve64f,-zve64x,-zvl1024b,-zvl128b,-zvl16384b,-zvl2048b,-zvl256b,-zvl32768b,-zvl32b,-zvl4096b,-zvl512b,-zvl64b,-zvl65536b,-zvl8192b" }
attributes #1 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!9, !10, !11, !12, !13, !14}
!llvm.ident = !{!15}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "input", scope: !2, file: !3, line: 1, type: !7, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "clang version 16.0.0 (git@github.com:pranav-mallela/llvm-cse583.git 538aaea3bc2f7c4d1cf336b68bd782edbccab061)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, globals: !4, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "../samples/fib.c", directory: "/home/pmallela/CSE583/llvm-cse583/build", checksumkind: CSK_MD5, checksum: "0691ae4a017a9ff6c7d3576304a5b02c")
!4 = !{!0, !5}
!5 = !DIGlobalVariableExpression(var: !6, expr: !DIExpression())
!6 = distinct !DIGlobalVariable(name: "sink", scope: !2, file: !3, line: 2, type: !7, isLocal: false, isDefinition: true)
!7 = !DIDerivedType(tag: DW_TAG_volatile_type, baseType: !8)
!8 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!9 = !{i32 7, !"Dwarf Version", i32 5}
!10 = !{i32 2, !"Debug Info Version", i32 3}
!11 = !{i32 1, !"wchar_size", i32 4}
!12 = !{i32 1, !"target-abi", !"lp64"}
!13 = !{i32 7, !"frame-pointer", i32 2}
!14 = !{i32 1, !"SmallDataLimit", i32 8}
!15 = !{!"clang version 16.0.0 (git@github.com:pranav-mallela/llvm-cse583.git 538aaea3bc2f7c4d1cf336b68bd782edbccab061)"}
!16 = distinct !DISubprogram(name: "fib", scope: !3, file: !3, line: 5, type: !17, scopeLine: 5, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !19)
!17 = !DISubroutineType(types: !18)
!18 = !{!8, !8}
!19 = !{}
!20 = !DILocalVariable(name: "n", arg: 1, scope: !16, file: !3, line: 5, type: !8)
!21 = !DILocation(line: 5, column: 31, scope: !16)
!22 = !DILocalVariable(name: "fib0", scope: !16, file: !3, line: 6, type: !8)
!23 = !DILocation(line: 6, column: 18, scope: !16)
!24 = !DILocalVariable(name: "fib1", scope: !16, file: !3, line: 6, type: !8)
!25 = !DILocation(line: 6, column: 28, scope: !16)
!26 = !DILocalVariable(name: "result", scope: !16, file: !3, line: 7, type: !8)
!27 = !DILocation(line: 7, column: 18, scope: !16)
!28 = !DILocation(line: 9, column: 9, scope: !29)
!29 = distinct !DILexicalBlock(scope: !16, file: !3, line: 9, column: 9)
!30 = !DILocation(line: 9, column: 11, scope: !29)
!31 = !DILocation(line: 9, column: 9, scope: !16)
!32 = !DILocation(line: 10, column: 16, scope: !33)
!33 = distinct !DILexicalBlock(scope: !29, file: !3, line: 9, column: 17)
!34 = !DILocation(line: 11, column: 5, scope: !33)
!35 = !DILocation(line: 11, column: 16, scope: !36)
!36 = distinct !DILexicalBlock(scope: !29, file: !3, line: 11, column: 16)
!37 = !DILocation(line: 11, column: 18, scope: !36)
!38 = !DILocation(line: 11, column: 16, scope: !29)
!39 = !DILocation(line: 12, column: 16, scope: !40)
!40 = distinct !DILexicalBlock(scope: !36, file: !3, line: 11, column: 24)
!41 = !DILocation(line: 13, column: 5, scope: !40)
!42 = !DILocalVariable(name: "i", scope: !43, file: !3, line: 14, type: !44)
!43 = distinct !DILexicalBlock(scope: !36, file: !3, line: 13, column: 12)
!44 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!45 = !DILocation(line: 14, column: 13, scope: !43)
!46 = !DILocation(line: 15, column: 16, scope: !47)
!47 = distinct !DILexicalBlock(scope: !43, file: !3, line: 15, column: 9)
!48 = !DILocation(line: 15, column: 14, scope: !47)
!49 = !DILocation(line: 15, column: 21, scope: !50)
!50 = distinct !DILexicalBlock(scope: !47, file: !3, line: 15, column: 9)
!51 = !DILocation(line: 15, column: 25, scope: !50)
!52 = !DILocation(line: 15, column: 27, scope: !50)
!53 = !DILocation(line: 15, column: 23, scope: !50)
!54 = !DILocation(line: 15, column: 9, scope: !47)
!55 = !DILocation(line: 16, column: 17, scope: !56)
!56 = distinct !DILexicalBlock(scope: !57, file: !3, line: 16, column: 17)
!57 = distinct !DILexicalBlock(scope: !50, file: !3, line: 15, column: 37)
!58 = !DILocation(line: 16, column: 19, scope: !56)
!59 = !DILocation(line: 16, column: 23, scope: !56)
!60 = !DILocation(line: 16, column: 17, scope: !57)
!61 = !DILocation(line: 17, column: 25, scope: !62)
!62 = distinct !DILexicalBlock(scope: !56, file: !3, line: 16, column: 29)
!63 = !DILocation(line: 17, column: 22, scope: !62)
!64 = !DILocation(line: 18, column: 26, scope: !62)
!65 = !DILocation(line: 18, column: 24, scope: !62)
!66 = !DILocation(line: 19, column: 13, scope: !62)
!67 = !DILocation(line: 20, column: 25, scope: !68)
!68 = distinct !DILexicalBlock(scope: !56, file: !3, line: 19, column: 20)
!69 = !DILocation(line: 20, column: 22, scope: !68)
!70 = !DILocation(line: 21, column: 26, scope: !68)
!71 = !DILocation(line: 21, column: 24, scope: !68)
!72 = !DILocation(line: 23, column: 9, scope: !57)
!73 = !DILocation(line: 15, column: 32, scope: !50)
!74 = !DILocation(line: 15, column: 9, scope: !50)
!75 = distinct !{!75, !54, !76, !77}
!76 = !DILocation(line: 23, column: 9, scope: !47)
!77 = !{!"llvm.loop.mustprogress"}
!78 = !DILocation(line: 26, column: 12, scope: !16)
!79 = !DILocation(line: 26, column: 5, scope: !16)
!80 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 29, type: !81, scopeLine: 29, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !19)
!81 = !DISubroutineType(types: !82)
!82 = !{!44}
!83 = !DILocalVariable(name: "result", scope: !80, file: !3, line: 30, type: !8)
!84 = !DILocation(line: 30, column: 18, scope: !80)
!85 = !DILocation(line: 30, column: 31, scope: !80)
!86 = !DILocation(line: 30, column: 27, scope: !80)
!87 = !DILocation(line: 31, column: 12, scope: !80)
!88 = !DILocation(line: 31, column: 10, scope: !80)
!89 = !DILocation(line: 32, column: 5, scope: !80)
