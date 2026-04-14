; ModuleID = '../samples/experiment.c'
source_filename = "../samples/experiment.c"
target datalayout = "e-m:e-p:64:64-i64:64-i128:128-n32:64-S128"
target triple = "riscv64"

; Function Attrs: noinline nounwind optnone
define dso_local signext i32 @experiment(i32 noundef signext %volatile_input) #0 !dbg !9 {
entry:
  %volatile_input.addr = alloca i32, align 4
  %a = alloca i32, align 4
  %b = alloca i32, align 4
  store i32 %volatile_input, ptr %volatile_input.addr, align 4
  call void @llvm.dbg.declare(metadata ptr %volatile_input.addr, metadata !14, metadata !DIExpression()), !dbg !15
  call void @llvm.dbg.declare(metadata ptr %a, metadata !16, metadata !DIExpression()), !dbg !17
  %0 = load i32, ptr %volatile_input.addr, align 4, !dbg !18
  %shr = ashr i32 %0, 2, !dbg !19
  store i32 %shr, ptr %a, align 4, !dbg !17
  call void @llvm.dbg.declare(metadata ptr %b, metadata !20, metadata !DIExpression()), !dbg !21
  %1 = load i32, ptr %a, align 4, !dbg !22
  %xor = xor i32 %1, 1, !dbg !23
  store i32 %xor, ptr %b, align 4, !dbg !21
  %2 = load i32, ptr %b, align 4, !dbg !24
  %and = and i32 %2, 1, !dbg !25
  ret i32 %and, !dbg !26
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind optnone
define dso_local signext i32 @main() #0 !dbg !27 {
entry:
  %retval = alloca i32, align 4
  %input = alloca i32, align 4
  %result = alloca i32, align 4
  store i32 0, ptr %retval, align 4
  call void @llvm.dbg.declare(metadata ptr %input, metadata !30, metadata !DIExpression()), !dbg !31
  store i32 12, ptr %input, align 4, !dbg !31
  call void @llvm.dbg.declare(metadata ptr %result, metadata !32, metadata !DIExpression()), !dbg !33
  %0 = load i32, ptr %input, align 4, !dbg !34
  %call = call signext i32 @experiment(i32 noundef signext %0), !dbg !35
  store i32 %call, ptr %result, align 4, !dbg !33
  ret i32 0, !dbg !36
}

attributes #0 = { noinline nounwind optnone "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic-rv64" "target-features"="+64bit,+a,+c,+m,+relax,-d,-e,-experimental-zawrs,-experimental-zca,-experimental-zcd,-experimental-zcf,-experimental-zihintntl,-experimental-ztso,-experimental-zvfh,-f,-h,-save-restore,-svinval,-svnapot,-svpbmt,-v,-xtheadvdot,-xventanacondops,-zba,-zbb,-zbc,-zbkb,-zbkc,-zbkx,-zbs,-zdinx,-zfh,-zfhmin,-zfinx,-zhinx,-zhinxmin,-zicbom,-zicbop,-zicboz,-zihintpause,-zk,-zkn,-zknd,-zkne,-zknh,-zkr,-zks,-zksed,-zksh,-zkt,-zmmul,-zve32f,-zve32x,-zve64d,-zve64f,-zve64x,-zvl1024b,-zvl128b,-zvl16384b,-zvl2048b,-zvl256b,-zvl32768b,-zvl32b,-zvl4096b,-zvl512b,-zvl64b,-zvl65536b,-zvl8192b" }
attributes #1 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!2, !3, !4, !5, !6, !7}
!llvm.ident = !{!8}

!0 = distinct !DICompileUnit(language: DW_LANG_C11, file: !1, producer: "clang version 16.0.0 (git@github.com:pranav-mallela/llvm-cse583.git 6b027f5ec54797fba84cfe6ee688001078bcbb23)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "../samples/experiment.c", directory: "/home/pmallela/CSE583/llvm-cse583/build", checksumkind: CSK_MD5, checksum: "d09dfdb3f88f6705d08ce5f2f1a813d1")
!2 = !{i32 7, !"Dwarf Version", i32 5}
!3 = !{i32 2, !"Debug Info Version", i32 3}
!4 = !{i32 1, !"wchar_size", i32 4}
!5 = !{i32 1, !"target-abi", !"lp64"}
!6 = !{i32 7, !"frame-pointer", i32 2}
!7 = !{i32 1, !"SmallDataLimit", i32 8}
!8 = !{!"clang version 16.0.0 (git@github.com:pranav-mallela/llvm-cse583.git 6b027f5ec54797fba84cfe6ee688001078bcbb23)"}
!9 = distinct !DISubprogram(name: "experiment", scope: !1, file: !1, line: 2, type: !10, scopeLine: 2, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !13)
!10 = !DISubroutineType(types: !11)
!11 = !{!12, !12}
!12 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!13 = !{}
!14 = !DILocalVariable(name: "volatile_input", arg: 1, scope: !9, file: !1, line: 2, type: !12)
!15 = !DILocation(line: 2, column: 20, scope: !9)
!16 = !DILocalVariable(name: "a", scope: !9, file: !1, line: 4, type: !12)
!17 = !DILocation(line: 4, column: 9, scope: !9)
!18 = !DILocation(line: 4, column: 13, scope: !9)
!19 = !DILocation(line: 4, column: 28, scope: !9)
!20 = !DILocalVariable(name: "b", scope: !9, file: !1, line: 5, type: !12)
!21 = !DILocation(line: 5, column: 9, scope: !9)
!22 = !DILocation(line: 5, column: 13, scope: !9)
!23 = !DILocation(line: 5, column: 15, scope: !9)
!24 = !DILocation(line: 6, column: 12, scope: !9)
!25 = !DILocation(line: 6, column: 14, scope: !9)
!26 = !DILocation(line: 6, column: 5, scope: !9)
!27 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 9, type: !28, scopeLine: 9, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !13)
!28 = !DISubroutineType(types: !29)
!29 = !{!12}
!30 = !DILocalVariable(name: "input", scope: !27, file: !1, line: 10, type: !12)
!31 = !DILocation(line: 10, column: 9, scope: !27)
!32 = !DILocalVariable(name: "result", scope: !27, file: !1, line: 11, type: !12)
!33 = !DILocation(line: 11, column: 9, scope: !27)
!34 = !DILocation(line: 11, column: 29, scope: !27)
!35 = !DILocation(line: 11, column: 18, scope: !27)
!36 = !DILocation(line: 12, column: 5, scope: !27)
