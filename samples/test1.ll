; ModuleID = '../samples/test1.c'
source_filename = "../samples/test1.c"
target datalayout = "e-m:e-p:64:64-i64:64-i128:128-n32:64-S128"
target triple = "riscv64"

; Function Attrs: noinline nounwind optnone
define dso_local signext i32 @main() #0 !dbg !9 {
entry:
  %retval = alloca i32, align 4
  %a = alloca i32, align 4
  %b = alloca i32, align 4
  %c = alloca i32, align 4
  %d = alloca i32, align 4
  store i32 0, ptr %retval, align 4
  call void @llvm.dbg.declare(metadata ptr %a, metadata !14, metadata !DIExpression()), !dbg !16
  store i32 305419896, ptr %a, align 4, !dbg !16
  call void @llvm.dbg.declare(metadata ptr %b, metadata !17, metadata !DIExpression()), !dbg !18
  store i32 -2023406815, ptr %b, align 4, !dbg !18
  call void @llvm.dbg.declare(metadata ptr %c, metadata !19, metadata !DIExpression()), !dbg !20
  %0 = load i32, ptr %a, align 4, !dbg !21
  %1 = load i32, ptr %b, align 4, !dbg !22
  %and = and i32 %0, %1, !dbg !23
  %2 = load i32, ptr %a, align 4, !dbg !24
  %3 = load i32, ptr %b, align 4, !dbg !25
  %or = or i32 %2, %3, !dbg !26
  %xor = xor i32 %and, %or, !dbg !27
  store i32 %xor, ptr %c, align 4, !dbg !20
  call void @llvm.dbg.declare(metadata ptr %d, metadata !28, metadata !DIExpression()), !dbg !29
  %4 = load i32, ptr %c, align 4, !dbg !30
  %shl = shl i32 %4, 5, !dbg !31
  %5 = load i32, ptr %c, align 4, !dbg !32
  %shr = lshr i32 %5, 3, !dbg !33
  %or1 = or i32 %shl, %shr, !dbg !34
  store i32 %or1, ptr %d, align 4, !dbg !29
  %6 = load i32, ptr %d, align 4, !dbg !35
  ret i32 %6, !dbg !36
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

attributes #0 = { noinline nounwind optnone "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic-rv64" "target-features"="+64bit,+a,+c,+m,+relax,-d,-e,-experimental-zawrs,-experimental-zca,-experimental-zcd,-experimental-zcf,-experimental-zihintntl,-experimental-ztso,-experimental-zvfh,-f,-h,-save-restore,-svinval,-svnapot,-svpbmt,-v,-xtheadvdot,-xventanacondops,-zba,-zbb,-zbc,-zbkb,-zbkc,-zbkx,-zbs,-zdinx,-zfh,-zfhmin,-zfinx,-zhinx,-zhinxmin,-zicbom,-zicbop,-zicboz,-zihintpause,-zk,-zkn,-zknd,-zkne,-zknh,-zkr,-zks,-zksed,-zksh,-zkt,-zmmul,-zve32f,-zve32x,-zve64d,-zve64f,-zve64x,-zvl1024b,-zvl128b,-zvl16384b,-zvl2048b,-zvl256b,-zvl32768b,-zvl32b,-zvl4096b,-zvl512b,-zvl64b,-zvl65536b,-zvl8192b" }
attributes #1 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!2, !3, !4, !5, !6, !7}
!llvm.ident = !{!8}

!0 = distinct !DICompileUnit(language: DW_LANG_C11, file: !1, producer: "clang version 16.0.0 (git@github.com:pranav-mallela/llvm-cse583.git 25eac4a017d7281591c86020790c695d7b2b931d)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "../samples/test1.c", directory: "/home/pmallela/CSE583/llvm-cse583/build", checksumkind: CSK_MD5, checksum: "9fcf6abebbbc00a32f023b2ac20d7dd0")
!2 = !{i32 7, !"Dwarf Version", i32 5}
!3 = !{i32 2, !"Debug Info Version", i32 3}
!4 = !{i32 1, !"wchar_size", i32 4}
!5 = !{i32 1, !"target-abi", !"lp64"}
!6 = !{i32 7, !"frame-pointer", i32 2}
!7 = !{i32 1, !"SmallDataLimit", i32 8}
!8 = !{!"clang version 16.0.0 (git@github.com:pranav-mallela/llvm-cse583.git 25eac4a017d7281591c86020790c695d7b2b931d)"}
!9 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 1, type: !10, scopeLine: 1, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !13)
!10 = !DISubroutineType(types: !11)
!11 = !{!12}
!12 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!13 = !{}
!14 = !DILocalVariable(name: "a", scope: !9, file: !1, line: 2, type: !15)
!15 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!16 = !DILocation(line: 2, column: 18, scope: !9)
!17 = !DILocalVariable(name: "b", scope: !9, file: !1, line: 3, type: !15)
!18 = !DILocation(line: 3, column: 18, scope: !9)
!19 = !DILocalVariable(name: "c", scope: !9, file: !1, line: 6, type: !15)
!20 = !DILocation(line: 6, column: 18, scope: !9)
!21 = !DILocation(line: 6, column: 23, scope: !9)
!22 = !DILocation(line: 6, column: 27, scope: !9)
!23 = !DILocation(line: 6, column: 25, scope: !9)
!24 = !DILocation(line: 6, column: 33, scope: !9)
!25 = !DILocation(line: 6, column: 37, scope: !9)
!26 = !DILocation(line: 6, column: 35, scope: !9)
!27 = !DILocation(line: 6, column: 30, scope: !9)
!28 = !DILocalVariable(name: "d", scope: !9, file: !1, line: 7, type: !15)
!29 = !DILocation(line: 7, column: 18, scope: !9)
!30 = !DILocation(line: 7, column: 23, scope: !9)
!31 = !DILocation(line: 7, column: 25, scope: !9)
!32 = !DILocation(line: 7, column: 34, scope: !9)
!33 = !DILocation(line: 7, column: 36, scope: !9)
!34 = !DILocation(line: 7, column: 31, scope: !9)
!35 = !DILocation(line: 9, column: 12, scope: !9)
!36 = !DILocation(line: 9, column: 5, scope: !9)
