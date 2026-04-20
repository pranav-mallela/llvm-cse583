; ModuleID = '../samples/rad2deg.c'
source_filename = "../samples/rad2deg.c"
target datalayout = "e-m:e-p:64:64-i64:64-i128:128-n32:64-S128"
target triple = "riscv64"

@g_deg = dso_local global i32 45, align 4, !dbg !0
@g_rad_scaled = dso_local global i32 3141, align 4, !dbg !5
@sink1 = dso_local global i32 0, align 4, !dbg !9
@sink2 = dso_local global i32 0, align 4, !dbg !11

; Function Attrs: noinline nounwind optnone
define dso_local signext i32 @rad2deg_int(i32 noundef signext %rad_scaled) #0 !dbg !20 {
entry:
  %rad_scaled.addr = alloca i32, align 4
  store i32 %rad_scaled, ptr %rad_scaled.addr, align 4
  call void @llvm.dbg.declare(metadata ptr %rad_scaled.addr, metadata !24, metadata !DIExpression()), !dbg !25
  %0 = load i32, ptr %rad_scaled.addr, align 4, !dbg !26
  %mul = mul nsw i32 180, %0, !dbg !27
  %div = sdiv i32 %mul, 3141, !dbg !28
  ret i32 %div, !dbg !29
}

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind optnone
define dso_local signext i32 @deg2rad_int(i32 noundef signext %deg) #0 !dbg !30 {
entry:
  %deg.addr = alloca i32, align 4
  store i32 %deg, ptr %deg.addr, align 4
  call void @llvm.dbg.declare(metadata ptr %deg.addr, metadata !31, metadata !DIExpression()), !dbg !32
  %0 = load i32, ptr %deg.addr, align 4, !dbg !33
  %mul = mul nsw i32 3141, %0, !dbg !34
  %div = sdiv i32 %mul, 180, !dbg !35
  ret i32 %div, !dbg !36
}

; Function Attrs: noinline nounwind optnone
define dso_local signext i32 @main() #0 !dbg !37 {
entry:
  %retval = alloca i32, align 4
  %r1 = alloca i32, align 4
  %r2 = alloca i32, align 4
  store i32 0, ptr %retval, align 4
  call void @llvm.dbg.declare(metadata ptr %r1, metadata !40, metadata !DIExpression()), !dbg !41
  %0 = load volatile i32, ptr @g_deg, align 4, !dbg !42
  %call = call signext i32 @deg2rad_int(i32 noundef signext %0), !dbg !43
  store i32 %call, ptr %r1, align 4, !dbg !41
  call void @llvm.dbg.declare(metadata ptr %r2, metadata !44, metadata !DIExpression()), !dbg !45
  %1 = load volatile i32, ptr @g_rad_scaled, align 4, !dbg !46
  %call1 = call signext i32 @rad2deg_int(i32 noundef signext %1), !dbg !47
  store i32 %call1, ptr %r2, align 4, !dbg !45
  %2 = load i32, ptr %r1, align 4, !dbg !48
  store volatile i32 %2, ptr @sink1, align 4, !dbg !49
  %3 = load i32, ptr %r2, align 4, !dbg !50
  store volatile i32 %3, ptr @sink2, align 4, !dbg !51
  ret i32 0, !dbg !52
}

attributes #0 = { noinline nounwind optnone "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic-rv64" "target-features"="+64bit,+a,+c,+m,+relax,-d,-e,-experimental-zawrs,-experimental-zca,-experimental-zcd,-experimental-zcf,-experimental-zihintntl,-experimental-ztso,-experimental-zvfh,-f,-h,-save-restore,-svinval,-svnapot,-svpbmt,-v,-xtheadvdot,-xventanacondops,-zba,-zbb,-zbc,-zbkb,-zbkc,-zbkx,-zbs,-zdinx,-zfh,-zfhmin,-zfinx,-zhinx,-zhinxmin,-zicbom,-zicbop,-zicboz,-zihintpause,-zk,-zkn,-zknd,-zkne,-zknh,-zkr,-zks,-zksed,-zksh,-zkt,-zmmul,-zve32f,-zve32x,-zve64d,-zve64f,-zve64x,-zvl1024b,-zvl128b,-zvl16384b,-zvl2048b,-zvl256b,-zvl32768b,-zvl32b,-zvl4096b,-zvl512b,-zvl64b,-zvl65536b,-zvl8192b" }
attributes #1 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!13, !14, !15, !16, !17, !18}
!llvm.ident = !{!19}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "g_deg", scope: !2, file: !3, line: 1, type: !7, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C11, file: !3, producer: "clang version 16.0.0 (git@github.com:pranav-mallela/llvm-cse583.git 25eac4a017d7281591c86020790c695d7b2b931d)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, globals: !4, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "../samples/rad2deg.c", directory: "/home/pmallela/CSE583/llvm-cse583/build", checksumkind: CSK_MD5, checksum: "fabc6fb1133aa2e52d506ae268be6706")
!4 = !{!0, !5, !9, !11}
!5 = !DIGlobalVariableExpression(var: !6, expr: !DIExpression())
!6 = distinct !DIGlobalVariable(name: "g_rad_scaled", scope: !2, file: !3, line: 2, type: !7, isLocal: false, isDefinition: true)
!7 = !DIDerivedType(tag: DW_TAG_volatile_type, baseType: !8)
!8 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!9 = !DIGlobalVariableExpression(var: !10, expr: !DIExpression())
!10 = distinct !DIGlobalVariable(name: "sink1", scope: !2, file: !3, line: 4, type: !7, isLocal: false, isDefinition: true)
!11 = !DIGlobalVariableExpression(var: !12, expr: !DIExpression())
!12 = distinct !DIGlobalVariable(name: "sink2", scope: !2, file: !3, line: 5, type: !7, isLocal: false, isDefinition: true)
!13 = !{i32 7, !"Dwarf Version", i32 5}
!14 = !{i32 2, !"Debug Info Version", i32 3}
!15 = !{i32 1, !"wchar_size", i32 4}
!16 = !{i32 1, !"target-abi", !"lp64"}
!17 = !{i32 7, !"frame-pointer", i32 2}
!18 = !{i32 1, !"SmallDataLimit", i32 8}
!19 = !{!"clang version 16.0.0 (git@github.com:pranav-mallela/llvm-cse583.git 25eac4a017d7281591c86020790c695d7b2b931d)"}
!20 = distinct !DISubprogram(name: "rad2deg_int", scope: !3, file: !3, line: 11, type: !21, scopeLine: 12, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !23)
!21 = !DISubroutineType(types: !22)
!22 = !{!8, !8}
!23 = !{}
!24 = !DILocalVariable(name: "rad_scaled", arg: 1, scope: !20, file: !3, line: 11, type: !8)
!25 = !DILocation(line: 11, column: 21, scope: !20)
!26 = !DILocation(line: 13, column: 19, scope: !20)
!27 = !DILocation(line: 13, column: 17, scope: !20)
!28 = !DILocation(line: 13, column: 31, scope: !20)
!29 = !DILocation(line: 13, column: 5, scope: !20)
!30 = distinct !DISubprogram(name: "deg2rad_int", scope: !3, file: !3, line: 17, type: !21, scopeLine: 18, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !23)
!31 = !DILocalVariable(name: "deg", arg: 1, scope: !30, file: !3, line: 17, type: !8)
!32 = !DILocation(line: 17, column: 21, scope: !30)
!33 = !DILocation(line: 19, column: 25, scope: !30)
!34 = !DILocation(line: 19, column: 23, scope: !30)
!35 = !DILocation(line: 19, column: 30, scope: !30)
!36 = !DILocation(line: 19, column: 5, scope: !30)
!37 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 22, type: !38, scopeLine: 23, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !23)
!38 = !DISubroutineType(types: !39)
!39 = !{!8}
!40 = !DILocalVariable(name: "r1", scope: !37, file: !3, line: 24, type: !8)
!41 = !DILocation(line: 24, column: 9, scope: !37)
!42 = !DILocation(line: 24, column: 26, scope: !37)
!43 = !DILocation(line: 24, column: 14, scope: !37)
!44 = !DILocalVariable(name: "r2", scope: !37, file: !3, line: 25, type: !8)
!45 = !DILocation(line: 25, column: 9, scope: !37)
!46 = !DILocation(line: 25, column: 26, scope: !37)
!47 = !DILocation(line: 25, column: 14, scope: !37)
!48 = !DILocation(line: 27, column: 13, scope: !37)
!49 = !DILocation(line: 27, column: 11, scope: !37)
!50 = !DILocation(line: 28, column: 13, scope: !37)
!51 = !DILocation(line: 28, column: 11, scope: !37)
!52 = !DILocation(line: 29, column: 5, scope: !37)
