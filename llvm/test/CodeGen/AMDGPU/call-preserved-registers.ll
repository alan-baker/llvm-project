; RUN: llc -mtriple=amdgcn-amd-amdhsa -mcpu=fiji -enable-ipra=0 -verify-machineinstrs < %s | FileCheck -check-prefixes=GCN,MUBUF %s
; RUN: llc -mtriple=amdgcn-amd-amdhsa -mcpu=hawaii -enable-ipra=0 -verify-machineinstrs < %s | FileCheck -check-prefixes=GCN,MUBUF %s
; RUN: llc -mtriple=amdgcn-amd-amdhsa -mcpu=gfx900 -enable-ipra=0 -verify-machineinstrs < %s | FileCheck -check-prefixes=GCN,MUBUF %s
; RUN: llc -mtriple=amdgcn-amd-amdhsa -mcpu=gfx900 -enable-ipra=0 -amdgpu-enable-flat-scratch -verify-machineinstrs < %s | FileCheck -check-prefixes=GCN,FLATSCR %s

declare hidden void @external_void_func_void() #0

; GCN-LABEL: {{^}}test_kernel_call_external_void_func_void_clobber_s30_s31_call_external_void_func_void:
; GCN: s_getpc_b64 s[44:45]
; GCN-NEXT: s_add_u32 s44, s44,
; GCN-NEXT: s_addc_u32 s45, s45,
; GCN-NEXT: s_mov_b32 s32, 0
; GCN: s_swappc_b64 s[30:31], s[44:45]

; GCN-DAG: #ASMSTART
; GCN-DAG: #ASMEND
; GCN-DAG: s_swappc_b64 s[30:31], s[44:45]
define amdgpu_kernel void @test_kernel_call_external_void_func_void_clobber_s30_s31_call_external_void_func_void() #0 {
  call void @external_void_func_void()
  call void asm sideeffect "", ""() #0
  call void @external_void_func_void()
  ret void
}

; GCN-LABEL: {{^}}test_func_call_external_void_func_void_clobber_s30_s31_call_external_void_func_void:
; MUBUF:   buffer_store_dword
; FLATSCR: scratch_store_dword
; GCN:      v_writelane_b32 v41, s33, 15
; GCN-NEXT: v_writelane_b32 v41, s34, 0
; GCN-NEXT: v_writelane_b32 v41, s35, 1
; GCN-NEXT: v_writelane_b32 v41, s36, 2
; GCN-NEXT: v_writelane_b32 v41, s37, 3
; GCN-NEXT: v_writelane_b32 v41, s38, 4
; GCN-NEXT: v_writelane_b32 v41, s39, 5
; GCN-NEXT: v_writelane_b32 v41, s40, 6
; GCN-NEXT: v_writelane_b32 v41, s41, 7
; GCN-NEXT: v_writelane_b32 v41, s42, 8
; GCN-NEXT: v_writelane_b32 v41, s43, 9
; GCN-NEXT: v_writelane_b32 v41, s44, 10
; GCN-NEXT: v_writelane_b32 v41, s46, 11
; GCN-NEXT: v_writelane_b32 v41, s47, 12
; GCN-NEXT: v_writelane_b32 v41, s30, 13

; GCN: s_swappc_b64
; GCN-DAG: ;;#ASMSTART
; GCN-NEXT: ;;#ASMEND
; GCN-NEXT: s_swappc_b64

; MUBUF-DAG: v_readlane_b32 s4, v41, 13
; MUBUF-DAG: v_readlane_b32 s5, v41, 14
; MUBUF-DAG: v_readlane_b32 s47, v41, 12
; MUBUF-DAG: v_readlane_b32 s46, v41, 11
; MUBUF-DAG: v_readlane_b32 s44, v41, 10
; MUBUF-DAG: v_readlane_b32 s43, v41, 9
; MUBUF-DAG: v_readlane_b32 s42, v41, 8
; MUBUF-DAG: v_readlane_b32 s41, v41, 7
; MUBUF-DAG: v_readlane_b32 s40, v41, 6
; MUBUF-DAG: v_readlane_b32 s39, v41, 5
; MUBUF-DAG: v_readlane_b32 s38, v41, 4
; MUBUF-DAG: v_readlane_b32 s37, v41, 3
; MUBUF-DAG: v_readlane_b32 s36, v41, 2
; MUBUF-DAG: v_readlane_b32 s35, v41, 1
; MUBUF-DAG: v_readlane_b32 s34, v41, 0

; FLATSCR: v_readlane_b32 s0, v41, 13
; FLATSCR-DAG: v_readlane_b32 s1, v41, 14
; FLATSCR-DAG: v_readlane_b32 s47, v41, 12
; FLATSCR-DAG: v_readlane_b32 s46, v41, 11
; FLATSCR-DAG: v_readlane_b32 s44, v41, 10
; FLATSCR-DAG: v_readlane_b32 s43, v41, 9
; FLATSCR-DAG: v_readlane_b32 s42, v41, 8
; FLATSCR-DAG: v_readlane_b32 s41, v41, 7
; FLATSCR-DAG: v_readlane_b32 s40, v41, 6
; FLATSCR-DAG: v_readlane_b32 s39, v41, 5
; FLATSCR-DAG: v_readlane_b32 s38, v41, 4
; FLATSCR-DAG: v_readlane_b32 s37, v41, 3
; FLATSCR-DAG: v_readlane_b32 s36, v41, 2
; FLATSCR-DAG: v_readlane_b32 s35, v41, 1
; FLATSCR-DAG: v_readlane_b32 s34, v41, 0
; FLATSCR-DAG: v_readlane_b32 s33, v41, 15

; MUBUF:   buffer_load_dword
; FLATSCR: scratch_load_dword
; GCN: s_setpc_b64
define void @test_func_call_external_void_func_void_clobber_s30_s31_call_external_void_func_void() #0 {
  call void @external_void_func_void()
  call void asm sideeffect "", ""() #0
  call void @external_void_func_void()
  ret void
}

; GCN-LABEL: {{^}}test_func_call_external_void_funcx2:
; MUBUF:   buffer_store_dword v41
; GCN: v_writelane_b32 v41, s33, 15

; GCN: s_mov_b32 s33, s32
; FLATSCR: s_add_u32 s32, s32, 16
; FLATSCR: scratch_store_dword off, v40
; MUBUF:   s_add_u32 s32, s32, 0x400
; GCN: s_swappc_b64
; GCN-DAG: s_swappc_b64

; GCN: v_readlane_b32 s33, v41, 15
; MUBUF:   buffer_load_dword v41
; FLATSCR: scratch_load_dword v41
define void @test_func_call_external_void_funcx2() #0 {
  call void @external_void_func_void()
  call void @external_void_func_void()
  ret void
}

; GCN-LABEL: {{^}}void_func_void_clobber_s30_s31:
; GCN: s_waitcnt
; GCN-NEXT: s_mov_b64 [[SAVEPC:s\[[0-9]+:[0-9]+\]]], s[30:31]
; GCN-NEXT: #ASMSTART
; GCN: ; clobber
; GCN-NEXT: #ASMEND
; GCN-NEXT: s_setpc_b64 [[SAVEPC]]
define void @void_func_void_clobber_s30_s31() #2 {
  call void asm sideeffect "; clobber", "~{s[30:31]}"() #0
  ret void
}

; GCN-LABEL: {{^}}void_func_void_clobber_vcc:
; GCN: s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT: ;;#ASMSTART
; GCN-NEXT: ;;#ASMEND
; GCN-NEXT: s_setpc_b64 s[30:31]
define hidden void @void_func_void_clobber_vcc() #2 {
  call void asm sideeffect "", "~{vcc}"() #0
  ret void
}

; GCN-LABEL: {{^}}test_call_void_func_void_clobber_vcc:
; GCN: s_getpc_b64
; GCN-NEXT: s_add_u32
; GCN-NEXT: s_addc_u32
; GCN: s_mov_b64 s[34:35], vcc
; GCN-NEXT: s_swappc_b64
; GCN: s_mov_b64 vcc, s[34:35]
define amdgpu_kernel void @test_call_void_func_void_clobber_vcc(i32 addrspace(1)* %out) #0 {
  %vcc = call i64 asm sideeffect "; def $0", "={vcc}"()
  call void @void_func_void_clobber_vcc()
  %val0 = load volatile i32, i32 addrspace(1)* undef
  %val1 = load volatile i32, i32 addrspace(1)* undef
  call void asm sideeffect "; use $0", "{vcc}"(i64 %vcc)
  ret void
}

; GCN-LABEL: {{^}}test_call_void_func_void_mayclobber_s31:
; GCN: s_mov_b32 s33, s31
; GCN-NEXT: s_swappc_b64
; GCN-NEXT: s_mov_b32 s31, s33
define amdgpu_kernel void @test_call_void_func_void_mayclobber_s31(i32 addrspace(1)* %out) #0 {
  %s31 = call i32 asm sideeffect "; def $0", "={s31}"()
  call void @external_void_func_void()
  call void asm sideeffect "; use $0", "{s31}"(i32 %s31)
  ret void
}

; GCN-LABEL: {{^}}test_call_void_func_void_mayclobber_v31:
; GCN: v_mov_b32_e32 v40, v31
; GCN-DAG: s_swappc_b64
; GCN-NEXT: v_mov_b32_e32 v31, v40
define amdgpu_kernel void @test_call_void_func_void_mayclobber_v31(i32 addrspace(1)* %out) #0 {
  %v31 = call i32 asm sideeffect "; def $0", "={v31}"()
  call void @external_void_func_void()
  call void asm sideeffect "; use $0", "{v31}"(i32 %v31)
  ret void
}

; FIXME: What is the expected behavior for reserved registers here?

; GCN-LABEL: {{^}}test_call_void_func_void_preserves_s33:
; MUBUF:        s_getpc_b64 s[18:19]
; MUBUF-NEXT:   s_add_u32 s18, s18, external_void_func_void@rel32@lo+4
; MUBUF-NEXT:   s_addc_u32 s19, s19, external_void_func_void@rel32@hi+12
; FLATSCR:      s_getpc_b64 s[16:17]
; FLATSCR-NEXT: s_add_u32 s16, s16, external_void_func_void@rel32@lo+4
; FLATSCR-NEXT: s_addc_u32 s17, s17, external_void_func_void@rel32@hi+12
; GCN: s_mov_b32 s32, 0
; GCN: #ASMSTART
; GCN-NEXT: ; def s33
; GCN-NEXT: #ASMEND
; MUBUF:   s_swappc_b64 s[30:31], s[18:19]
; FLATSCR: s_swappc_b64 s[30:31], s[16:17]
; GCN: ;;#ASMSTART
; GCN-NEXT: ; use s33
; GCN-NEXT: ;;#ASMEND
; GCN-NOT: s33
; GCN-NEXT: s_endpgm
define amdgpu_kernel void @test_call_void_func_void_preserves_s33(i32 addrspace(1)* %out) #0 {
  %s33 = call i32 asm sideeffect "; def $0", "={s33}"()
  call void @external_void_func_void()
  call void asm sideeffect "; use $0", "{s33}"(i32 %s33)
  ret void
}

; GCN-LABEL: {{^}}test_call_void_func_void_preserves_s34: {{.*}}
; GCN-NOT: s34

; MUBUF:        s_getpc_b64 s[18:19]
; MUBUF-NEXT:   s_add_u32 s18, s18, external_void_func_void@rel32@lo+4
; MUBUF-NEXT:   s_addc_u32 s19, s19, external_void_func_void@rel32@hi+12
; FLATSCR:      s_getpc_b64 s[16:17]
; FLATSCR-NEXT: s_add_u32 s16, s16, external_void_func_void@rel32@lo+4
; FLATSCR-NEXT: s_addc_u32 s17, s17, external_void_func_void@rel32@hi+12
; GCN: s_mov_b32 s32, 0

; GCN-NOT: s34
; GCN: ;;#ASMSTART
; GCN-NEXT: ; def s34
; GCN-NEXT: ;;#ASMEND

; GCN-NOT: s34
; MUBUF:   s_swappc_b64 s[30:31], s[18:19]
; FLATSCR: s_swappc_b64 s[30:31], s[16:17]

; GCN-NOT: s34

; GCN-NEXT: ;;#ASMSTART
; GCN-NEXT: ; use s34
; GCN-NEXT: ;;#ASMEND
; GCN-NEXT: s_endpgm
define amdgpu_kernel void @test_call_void_func_void_preserves_s34(i32 addrspace(1)* %out) #0 {
  %s34 = call i32 asm sideeffect "; def $0", "={s34}"()
  call void @external_void_func_void()
  call void asm sideeffect "; use $0", "{s34}"(i32 %s34)
  ret void
}

; GCN-LABEL: {{^}}test_call_void_func_void_preserves_v40: {{.*}}

; GCN-NOT: v32
; MUBUF: s_getpc_b64 s[18:19]
; MUBUF-NEXT:   s_add_u32 s18, s18, external_void_func_void@rel32@lo+4
; MUBUF-NEXT:   s_addc_u32 s19, s19, external_void_func_void@rel32@hi+12
; FLATSCR:      s_getpc_b64 s[16:17]
; FLATSCR-NEXT: s_add_u32 s16, s16, external_void_func_void@rel32@lo+4
; FLATSCR-NEXT: s_addc_u32 s17, s17, external_void_func_void@rel32@hi+12
; GCN: s_mov_b32 s32, 0
; GCN-NOT: v40

; GCN: ;;#ASMSTART
; GCN-NEXT: ; def v40
; GCN-NEXT: ;;#ASMEND

; MUBUF:   s_swappc_b64 s[30:31], s[18:19]
; FLATSCR: s_swappc_b64 s[30:31], s[16:17]

; GCN-NOT: v40

; GCN: ;;#ASMSTART
; GCN-NEXT: ; use v40
; GCN-NEXT: ;;#ASMEND
; GCN-NEXT: s_endpgm
define amdgpu_kernel void @test_call_void_func_void_preserves_v40(i32 addrspace(1)* %out) #0 {
  %v40 = call i32 asm sideeffect "; def $0", "={v40}"()
  call void @external_void_func_void()
  call void asm sideeffect "; use $0", "{v40}"(i32 %v40)
  ret void
}

; GCN-LABEL: {{^}}void_func_void_clobber_s33:
; GCN: v_writelane_b32 v0, s33, 0
; GCN-NEXT: #ASMSTART
; GCN-NEXT: ; clobber
; GCN-NEXT: #ASMEND
; GCN-NEXT:	v_readlane_b32 s33, v0, 0
; GCN: s_setpc_b64
define hidden void @void_func_void_clobber_s33() #2 {
  call void asm sideeffect "; clobber", "~{s33}"() #0
  ret void
}

; GCN-LABEL: {{^}}void_func_void_clobber_s34:
; GCN: v_writelane_b32 v0, s34, 0
; GCN-NEXT: #ASMSTART
; GCN-NEXT: ; clobber
; GCN-NEXT: #ASMEND
; GCN-NEXT:	v_readlane_b32 s34, v0, 0
; GCN: s_setpc_b64
define hidden void @void_func_void_clobber_s34() #2 {
  call void asm sideeffect "; clobber", "~{s34}"() #0
  ret void
}

; GCN-LABEL: {{^}}test_call_void_func_void_clobber_s33:
; GCN: s_getpc_b64
; GCN-NEXT: s_add_u32
; GCN-NEXT: s_addc_u32
; GCN-NEXT: s_mov_b32 s32, 0
; GCN: s_swappc_b64
; GCN-NEXT: s_endpgm
define amdgpu_kernel void @test_call_void_func_void_clobber_s33() #0 {
  call void @void_func_void_clobber_s33()
  ret void
}

; GCN-LABEL: {{^}}test_call_void_func_void_clobber_s34:
; GCN: s_getpc_b64
; GCN-NEXT: s_add_u32
; GCN-NEXT: s_addc_u32
; GCN-NEXT: s_mov_b32 s32, 0
; GCN: s_swappc_b64
; GCN-NEXT: s_endpgm
define amdgpu_kernel void @test_call_void_func_void_clobber_s34() #0 {
  call void @void_func_void_clobber_s34()
  ret void
}

; GCN-LABEL: {{^}}callee_saved_sgpr_func:
; GCN-NOT: s40
; GCN: v_writelane_b32 v40, s40
; GCN: s_swappc_b64
; GCN-NOT: s40
; GCN: ; use s40
; GCN-NOT: s40
; GCN: v_readlane_b32 s40, v40
; GCN-NOT: s40
define void @callee_saved_sgpr_func() #2 {
  %s40 = call i32 asm sideeffect "; def s40", "={s40}"() #0
  call void @external_void_func_void()
  call void asm sideeffect "; use $0", "s"(i32 %s40) #0
  ret void
}

; GCN-LABEL: {{^}}callee_saved_sgpr_kernel:
; GCN-NOT: s40
; GCN: ; def s40
; GCN-NOT: s40
; GCN: s_swappc_b64
; GCN-NOT: s40
; GCN: ; use s40
; GCN-NOT: s40
define amdgpu_kernel void @callee_saved_sgpr_kernel() #2 {
  %s40 = call i32 asm sideeffect "; def s40", "={s40}"() #0
  call void @external_void_func_void()
  call void asm sideeffect "; use $0", "s"(i32 %s40) #0
  ret void
}

; First call preserved VGPR is used so it can't be used for SGPR spills.
; GCN-LABEL: {{^}}callee_saved_sgpr_vgpr_func:
; GCN-NOT: s40
; GCN: v_writelane_b32 v41, s40
; GCN: s_swappc_b64
; GCN-NOT: s40
; GCN: ; use s40
; GCN-NOT: s40
; GCN: v_readlane_b32 s40, v41
; GCN-NOT: s40
define void @callee_saved_sgpr_vgpr_func() #2 {
  %s40 = call i32 asm sideeffect "; def s40", "={s40}"() #0
  %v40 = call i32 asm sideeffect "; def v40", "={v40}"() #0
  call void @external_void_func_void()
  call void asm sideeffect "; use $0", "s"(i32 %s40) #0
  call void asm sideeffect "; use $0", "v"(i32 %v40) #0
  ret void
}

; GCN-LABEL: {{^}}callee_saved_sgpr_vgpr_kernel:
; GCN-NOT: s40
; GCN: ; def s40
; GCN-NOT: s40
; GCN: s_swappc_b64
; GCN-NOT: s40
; GCN: ; use s40
; GCN-NOT: s40
define amdgpu_kernel void @callee_saved_sgpr_vgpr_kernel() #2 {
  %s40 = call i32 asm sideeffect "; def s40", "={s40}"() #0
  %v32 = call i32 asm sideeffect "; def v32", "={v32}"() #0
  call void @external_void_func_void()
  call void asm sideeffect "; use $0", "s"(i32 %s40) #0
  call void asm sideeffect "; use $0", "v"(i32 %v32) #0
  ret void
}

attributes #0 = { nounwind }
attributes #1 = { nounwind readnone }
attributes #2 = { nounwind noinline }
