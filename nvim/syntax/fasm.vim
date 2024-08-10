" Vim syntax file
" Language:    Flat Assembler (FASM)
" Maintainer: Leonid V. Fedorenchik <leonid@fedorenchik.com>
" Last Change: 2019 Jun 26
" FASM Home:   http://flatassembler.net/

if version < 600
    syntax clear
elseif exists("b:current_syntax")
    finish
endif

" We need nocompatible mode in order to continue lines with backslashes.
" Original setting will be restored.
let s:cpo_save = &cpo
set cpo&vim

setlocal iskeyword=a-z,A-Z,48-57,.,_
setlocal isident=a-z,A-Z,48-57,.,_

syn case ignore

syn keyword fasmRegister ah al bh bl ch cl dh dl spl bpl sil dil
syn keyword fasmRegister r8b r9b r10b r11b r12b r13b r14b r15b
syn keyword fasmRegister ax bx cx dx ip sp bp si di
syn keyword fasmRegister r8w r9w r10w r11w r12w r13w r14w r15w
syn keyword fasmRegister eax ebx ecx edx esp ebp esi edi eip
syn keyword fasmRegister r8d r9d r10d r11d r12d r13d r14d r15d
syn keyword fasmRegister es cs ss ds fs gs
syn keyword fasmRegister rax rbx rcx rdx rsi rdi rsp rbp
syn keyword fasmRegister r0 r1 r2 r3 r4 r5 r6 r7 r8 r9
syn keyword fasmRegister r10 r11 r12 r13 r14 r15
syn keyword fasmRegister cr0 cr1 cr2 cr3 cr4 cr5 cr6 cr7
syn keyword fasmRegister dr0 dr1 dr2 dr3 dr4 dr5 dr6 dr7
syn keyword fasmRegister mm0 mm1 mm2 mm3 mm4 mm5 mm6 mm7
syn keyword fasmRegister st0 st1 st2 st3 st4 st5 st6 st7
syn keyword fasmRegister tr0 tr1 tr3 tr4 tr5 tr6 tr7
" SSE registers
syn keyword fasmRegister xmm0 xmm1 xmm2 xmm3 xmm4 xmm5 xmm6 xmm7
syn keyword fasmRegister xmm8 xmm9 xmm10 xmm11 xmm12 xmm13 xmm14 xmm15
" AVX registers
syn keyword fasmRegister ymm0 ymm1 ymm2 ymm3 ymm4 ymm5 ymm6 ymm7
syn keyword fasmRegister ymm8 ymm9 ymm10 ymm11 ymm12 ymm13 ymm14 ymm15
" AVX-512 registers
syn keyword fasmRegister zmm0 zmm1 zmm2 zmm3 zmm4 zmm5 zmm6 zmm7
syn keyword fasmRegister zmm8 zmm9 zmm10 zmm11 zmm12 zmm13 zmm14 zmm15
syn keyword fasmRegister zmm16 zmm17 zmm18 zmm19 zmm20 zmm21 zmm22 zmm23
syn keyword fasmRegister zmm24 zmm25 zmm26 zmm27 zmm28 zmm29 zmm30 zmm31

syn keyword fasmAddressSizes byte dqword dword fword large pword qword qqword
syn keyword fasmAddressSizes short tword tbyte word yword xword

syn keyword fasmDataDirectives db dd df dp dq dt du dw file rb rd rf rp rq rt rw

syn keyword fasmInstr aaa aad aam aas adc adcx add addpd addps addsd addss addsubpd addsubps adox
syn keyword fasmInstr aesdec aesdeclast aesenc aesenclast aesimc aeskeygenassist and andn andnpd
syn keyword fasmInstr andnps andpd andps arpl bextr blendpd blendps blendvpd blendvps blsi blsmsk blsr
syn keyword fasmInstr bound bsf bsr bswap bt btc btr bts bzhi call cbw cdq cdqe clac clc cld clflush
syn keyword fasmInstr cli clts cmc cmova cmovae cmovb cmovbe cmovc cmove cmovg cmovge cmovl cmovle
syn keyword fasmInstr cmovna cmovnae cmovnb cmovnbe cmovnc cmovne cmovng cmovnge cmovnl cmovnle cmovno
syn keyword fasmInstr cmovnp cmovns cmovnz cmovo cmovp cmovpe cmovpo cmovs cmovz cmp cmpeqpd cmpeqps
syn keyword fasmInstr cmpeqsd cmpeqss cmplepd cmpleps cmplesd cmpless cmpltps cmpltsd cmpltss cmpneqpd
syn keyword fasmInstr cmpneqps cmpneqsd cmpneqss cmpnleps cmpnlesd cmpnless cmpnltpd cmpnltps cmpnltsd
syn keyword fasmInstr cmpnltss cmpordps cmpordsd cmpordss cmppd cmpps cmps cmpsb cmpsd cmpsq cmpss
syn keyword fasmInstr cmpsw cmpunordpd cmpunordps cmpunordsd cmpunordss cmpxchg cmpxchg16b cmpxchg8b
syn keyword fasmInstr comisd comiss cpuid cqo crc32 cvtdq2pd cvtdq2ps cvtpd2dq cvtpd2pi cvtpd2ps cvtpi2pd
syn keyword fasmInstr cvtpi2ps cvtps2dq cvtps2pd cvtps2pi cvtsd2si cvtsd2ss cvtsi2sd cvtsi2ss cvtss2sd
syn keyword fasmInstr cvtss2si cvttpd2dq cvttpd2pi cvttps2dq cvttps2pi cvttsd2si cvttss2si cwd cwde
syn keyword fasmInstr daa das dec div divpd divps divsd divss dppd dpps emms enter extractps
syn keyword fasmInstr extrn extrq f2xm1 fabs fadd faddp fbld fbstp fchs fclex fcmovb fcmovbe fcmove
syn keyword fasmInstr fcmovnb fcmovnbe fcmovne fcmovnu fcmovu fcom fcomi fcomip fcomp fcompp fcos
syn keyword fasmInstr fdecstp fdisi fdiv fdivp fdivr fdivrp femms feni ffree ffreep fiadd ficom ficomp
syn keyword fasmInstr fidiv fidivr fild fimul fincstp finit fist fistp fisttp fisub fisubr fld fld1
syn keyword fasmInstr fldcw fldenv fldl2e fldl2t fldlg2 fldln2 fldpi fldz fmul fmulp fnclex fndisi
syn keyword fasmInstr fneni fninit fnop fnsave fnstcw fnstenv fnstsw fpatan fprem fprem1 fptan frndint
syn keyword fasmInstr frstor frstpm fsave fscale fsetpm fsin fsincos fsqrt fst fstcw fstenv fstp fstsw
syn keyword fasmInstr fsub fsubp fsubr fsubrp ftst fucom fucomi fucomip fucomp fucompp fwait fxam fxch
syn keyword fasmInstr fxrstor fxsave fxtract fyl2x fyl2xp1 getsec haddpd haddps heap hlt hsubpd hsubps
syn keyword fasmInstr idiv imul in inc ins insb insd insertps insertq insw int int1 int3 into invd invept
syn keyword fasmInstr invlpg invpcid invvpid iret iretd iretw ja jae jb jbe jc jcxz je jecxz jg jge jl
syn keyword fasmInstr jle jmp jna jnae jnb jnbe jnc jne jng jnge jnl jnle jno jnp jns jnz jo jp jpe
syn keyword fasmInstr jpo js jz lahf lar lddqu ldmxcsr lds lea leave les lfence lfs lgdt lgs lidt lldt
syn keyword fasmInstr lmsw load loadall286 loadall386 lock lods lodsb lodsd lodsq lodsw loop loopd
syn keyword fasmInstr loope looped loopew loopne loopned loopnz loopnzd loopnzw loopw loopz loopzd
syn keyword fasmInstr loopzw lsl lss ltr lzcnt maskmovdqu maskmovq maxpd maxps maxsd maxss mfence
syn keyword fasmInstr minpd minps minsd minss monitor mov movapd movaps movbe movd movddup movdq2q
syn keyword fasmInstr movdqa movdqu movhlps movhpd movhps movlhps movlpd movlps movmskpd movmskps
syn keyword fasmInstr movntdq movntdqa movnti movntpd movntps movntq movntsd movntss movq movq2dq movs
syn keyword fasmInstr movsb movsd movshdup movsldup movsq movss movsw movsx movsxd movupd movups movzx
syn keyword fasmInstr mpsadbw mul mulpd mulps mulsd mulss mulx mwait mxcsr neg nop not or org orpd
syn keyword fasmInstr orps out outs outsb outsd outsw pabsb pabsd pabsw packssdw packsswb packusdw
syn keyword fasmInstr packuswb paddb paddd paddq paddsb paddsw paddusb paddusw paddw palignr pand
syn keyword fasmInstr pandn pause pavgb pavgusb pavgw pblendvb pblendw pclmulqdq pcmpeqb pcmpeqd
syn keyword fasmInstr pcmpeqq pcmpeqw pcmpestri pcmpestrm pcmpgtb pcmpgtd pcmpgtq pcmpgtw pcmpistri
syn keyword fasmInstr pcmpistrm pdep pext pextrb pextrd pextrq pextrw pf2id pf2iw pfacc pfadd pfcmpeq
syn keyword fasmInstr pfcmpgt pfmax pfmin pfmul pfnacc pfpnacc pfrcp pfrcpit1 pfrcpit2 pfrsqrt pfsub
syn keyword fasmInstr pfsubr phaddd phaddsw phaddw phminposuw phsubd phsubsw phsubw pi2fd pi2fw pinsrb
syn keyword fasmInstr pinsrd pinsrq pinsrw pmaddubsw pmaddwd pmaxsb pmaxsd pmaxsw pmaxub pmaxud pmaxuw
syn keyword fasmInstr pminsb pminsd pminsw pminub pminud pminuw pmovmskb pmovsxbd pmovsxbq pmovsxbw
syn keyword fasmInstr pmovsxdq pmovsxwd pmovsxwq pmovzxbd pmovzxbq pmovzxbw pmovzxdq pmovzxwd pmovzxwq
syn keyword fasmInstr pmuldq pmulhrsw pmulhrw pmulhuw pmulhw pmulld pmullw pmuludq pop popa popad
syn keyword fasmInstr popaw popcnt popd popf popfd popfw popw por prefetch prefetchnta prefetcht1
syn keyword fasmInstr prefetcht2 prefetchw prefetchwt1 psadbw pshufb pshufd pshufhw pshuflw pshufw
syn keyword fasmInstr psignb pslld pslldq psllq psllw psrad psraw psrld psrldq psrlq psrlw psubb psubd
syn keyword fasmInstr psubq psubsb psubsw psubusb psubusw psubw pswapd ptest public punpckhbw
syn keyword fasmInstr punpckhdq punpckhqdq punpckhwd punpcklbw punpckldq punpcklqdq punpcklwd push
syn keyword fasmInstr pusha pushad pushaw pushd pushf pushfd pushfw pushw pxor rcl rcpps rcpss rcr
syn keyword fasmInstr rdfsbase rdgsbase rdmsr rdpmc rdrand rdseed rdtsc rdtscp rep repe repne
syn keyword fasmInstr repnz repz ret retd retf retfd retfw retn retnd retnw retw rol ror rorx roundpd
syn keyword fasmInstr roundps roundsd roundss rsm rsqrtps rsqrtss sahf sal salc sar sarx sbb scas
syn keyword fasmInstr scasb scasd scasq scasw seta setae setalc setb setbe setc setcs sete setg setge setl
syn keyword fasmInstr setle setna setnae setnb setnbe setnc setne setng setnge setnl setnle setno
syn keyword fasmInstr setnp setns setnz seto setp setpe setpo sets setz sfence sgdt shl shld shlx shr
syn keyword fasmInstr shrd shrx shufpd shufps sidt sldt smsw sqrtpd sqrtps sqrtsd sqrtss stac stack
syn keyword fasmInstr stc std sti stmxcsr stos stosb stosd stosq stosw str sub subpd subps subsd subss
syn keyword fasmInstr swapgs syscall sysenter sysexit sysret test times tzcnt ucomisd ucomiss ud1 ud2
syn keyword fasmInstr unpckhpd unpckhps unpcklpd unpcklps vaeskeygenassist vboardcastd vbroadcastf128
syn keyword fasmInstr vbroadcastss vcmpfalse_ospd vcmpfalse_osps vcmpfalse_ossd vcmpfalse_osss
syn keyword fasmInstr vcmptrue_uspd vcmptrue_usps vcmptrue_ussd vcmptrue_usss vcvtph2ps vcvtps2ph verr
syn keyword fasmInstr verw vex vextractf128 vfmadd132pd vfmadd132ps vfmadd132sd vfmadd132ss
syn keyword fasmInstr vfmadd213pd vfmadd213ps vfmadd213sd vfmadd213ss vfmadd231pd vfmadd231ps
syn keyword fasmInstr vfmadd231sd vfmadd231ss vfmaddsub132pd vfmaddsub132ps vfmaddsub213pd
syn keyword fasmInstr vfmaddsub213ps vfmaddsub231pd vfmaddsub231ps vfmsub132ps vfmsub132sd vfmsub132ss
syn keyword fasmInstr vfmsub213pd vfmsub213ps vfmsub213sd vfmsub213ss vfmsub231pd vfmsub231ps
syn keyword fasmInstr vfmsub231sd vfmsub231ss vfmsubadd132pd vfmsubadd132ps vfmsubadd213pd
syn keyword fasmInstr vfmsubadd213ps vfmsubadd231pd vfmsubadd231ps vfnmadd132pd vfnmadd132ps
syn keyword fasmInstr vfnmadd132sd vfnmadd132ss vfnmadd213pd vfnmadd213ps vfnmadd213sd vfnmadd213ss
syn keyword fasmInstr vfnmadd231pd vfnmadd231ps vfnmadd231sd vfnmadd231ss vfnmsub132pd vfnmsub132ps
syn keyword fasmInstr vfnmsub132sd vfnmsub132ss vfnmsub213pd vfnmsub213ps vfnmsub213sd vfnmsub213ss
syn keyword fasmInstr vfnmsub231pd vfnmsub231ps vfnmsub231sd vfnmsub231ss vgatherdd vgatherdpd
syn keyword fasmInstr vgatherdps vgatherqd vgatherqpd vgatherqps vinsertf128 vmaskmovpd vmaskmovps
syn keyword fasmInstr vmcall vmclear vmfsub132pd vmfunc vmlaunch vmontdqa vmpsadbw vmptrld vmptrst
syn keyword fasmInstr vmread vmresume vmwrite vmxoff vmxon vpabsb vpabsd vpabsw vpackssdw vpacksswb
syn keyword fasmInstr vpackusdw vpackuswb vpaddb vpaddd vpaddq vpaddsb vpaddusb vpaddusw vpaddw
syn keyword fasmInstr vpalignr vpand vpandn vpavgb vpavgw vpblendvb vpblendw vpclmulhqhdq
syn keyword fasmInstr vpclmulhqlqdq vpclmullqhdq vpclmullqlqdq vpcmpeqb vpcmpeqd vpcmpeqq vpcmpeqw
syn keyword fasmInstr vpcmpgtb vpcmpgtd vpcmpgtq vpcmpgtw vperm2f128 vpermd vpermilpd vpermilps
syn keyword fasmInstr vpermpd vpermps vpermq vpgatherdq vpgatherqq vphadd vphaddsw vphaddw vphminposuw
syn keyword fasmInstr vphsubd vphsubsw vphsubw vpmaddubsw vpmaddwd vpmaxsb vpmaxsd vpmaxsw vpmaxub
syn keyword fasmInstr vpmaxud vpmaxuw vpminsb vpminsd vpminsw vpminub vpminud vpminuw vpmovmskb
syn keyword fasmInstr vpmovsxbd vpmovsxbq vpmovsxbw vpmovsxdq vpmovsxwd vpmovsxwq vpmovzxbd vpmovzxbq
syn keyword fasmInstr vpmovzxbw vpmovzxdq vpmovzxwd vpmovzxwq vpmuldq vpmulhrsw vpmulhuw vpmulhw
syn keyword fasmInstr vpmulld vpmullw vpmuludq vpor vpsadbw vpshufb vpshufd vpshufhw vpshuflw vpsignb
syn keyword fasmInstr vpsignd vpsignw vpslld vpslldq vpsllq vpsllvd vpsllvq vpsllw vpsrad vpsravd
syn keyword fasmInstr vpsraw vpsrld vpsrldq vpsrlq vpsrlvd vpsrlvq vpsrlw vpsubb vpsubd vpsubq vpsubsb
syn keyword fasmInstr vpsubsw vpsubusb vpsubusw vpsubw vpunpckhbw vpunpckhdq vpunpckhqdq vpunpckhwd
syn keyword fasmInstr vpunpcklbw vpunpckldq vpunpcklwd vpunpckpqdq vpxor vzeroall vzeroupper wait
syn keyword fasmInstr wbinvd wrfsbase wrgsbase wrmsr xabort xacquire xadd xbegin xchg xend xgetbv xlat
syn keyword fasmInstr xlatb xor xorpd xorps xrelease xrstor xsave xsaveopt xsetbv xtest

syn keyword fasmMacros         addr cinvoke endf endl endp ends feature frame invoke local locals proc stdcall struct uses
syn keyword fasmMacroDirective common forward local reverse
syn keyword fasmPreprocess     define equ fix forward include irp irps
syn keyword fasmPreprocess     local macro match purge rept restore restruc struc
syn keyword fasmDirective      assert binary code coff console data display discardable dll dynamic elf elf64 else end
syn keyword fasmDirective      entry executable efiboot err far fixups format gui if import interpreter label library linkinfo
syn keyword fasmDirective      ms ms64 mz native near needed notpageable pe pe64 resource readable repeat section
syn keyword fasmDirective      shareable static segment use16 use32 use64 virtual wdm writable writeable
syn keyword fasmOperator       align as at defined eq eqtype from mod on ptr rva relativeto used

syn match   fasmNumericOperator "[+-/*]"
syn match   fasmLogicalOperator "[=|&~<>]\|<=\|>=\|<>"
syn match   fasmBinaryNumber    "\<[01]\+b\>"
syn match   fasmHexNumber       "\<\d\x*h\>"
syn match   fasmHexNumber       "\<\(0x\|$\)\x*\>"
syn match   fasmFPUNumber       "\<\d\+\(\.\d*\)\=\(e[-+]\=\d*\)\=\>"
syn match   fasmOctalNumber     "\<\(0\o\+o\=\|\o\+o\)\>"
syn match   fasmDecimalNumber   "\<\(0\|[1-9]\d*\)\>"
syn region  fasmComment         start=";" end="$"
syn region  fasmString          start="\"" end="\"\|$"
syn region  fasmString          start="'" end="'\|$"
syn match   fasmSymbol          "[()|\[\]:]"
syn match   fasmSpecial         "[#?%$,]"
syn match   fasmLabel           "^\s*[^; \t]\+:"

hi def link fasmAddressSizes    type
hi def link fasmNumericOperator fasmOperator
hi def link fasmLogicalOperator fasmOperator

hi def link fasmBinaryNumber    fasmNumber
hi def link fasmHexNumber       fasmNumber
hi def link fasmFPUNumber       fasmNumber
hi def link fasmOctalNumber     fasmNumber
hi def link fasmDecimalNumber   fasmNumber

hi def link fasmSymbols         fasmRegister
hi def link fasmPreprocess      fasmDirective
hi def link fasmMacroDirective  fasmDirective

hi def link fasmInstr           Keyword
hi def link fasmRegister        Type
hi def link fasmNumber          Constant
hi def link fasmString          String
hi def link fasmComment         Comment
hi def link fasmOperator        Special
hi def link fasmLabel           Underlined
hi def link fasmSymbol          Structure
hi def link fasmSpecial         Special
hi def link fasmMacros          Identifier
hi def link fasmDirective       PreProc
hi def link fasmDataDirectives  rubyDefine

let b:current_syntax = "fasm"

let &cpo = s:cpo_save
unlet s:cpo_save
