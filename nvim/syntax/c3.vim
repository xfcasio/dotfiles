if exists("b:current_syntax")
  finish
endif

syn match c3Identifier  display "\v<_*[a-z][A-Za-z0-9_]*>"
syn match c3Function    display "\zs\(\w*\)*\s*\ze("
syn match c3Macro       display "@\zs\(\w*\)*\s*\ze("
syn match c3UserType    display "_*[A-Z][a-zA-Z0-9_]\+"
syn match c3UserAttr    display "@_*[A-Z][a-zA-Z0-9_]\+"
syn match c3GlobalConst display "_*[A-Z][A-Z0-9_]\+"
syn match c3Label       display "^\s*_*[A-Z][A-Z0-9_]\+:"
syn match c3ComptimeId  display "\v\$<_*[a-z][A-Za-z0-9_]*>"

syn match c3Number display "\v<0[Xx][0-9A-Fa-f](_*[0-9A-Fa-f])*>"
syn match c3Number display "\v<0[Oo][0-7](_*[0-7])*>"
syn match c3Number display "\v<0[Bb][01](_*[01])*>"
syn match c3Number display "\v<[0-9](_*[0-9])*([iu](8|16|32|64|128)|([Uu][Ll]?|[Ll]))?>"

syn match c3Float display "\v<[0-9](_*[0-9])*[Ee][+-]?[0-9]+(f(8|16|32|64|128))?>"
syn match c3Float display "\v<0[Xx][0-9A-Fa-f](_*[0-9A-Fa-f])*[Pp][+-]?[0-9]+(f(8|16|32|64|128))?>"
syn match c3Float display "\v<[0-9](_*[0-9])*\.[0-9](_*[0-9])*([Ee][+-]?[0-9]+)?(f(8|16|32|64|128))?>"
syn match c3Float display "\v<0[Xx][0-9A-Fa-f](_*[0-9A-Fa-f])*\.[0-9A-Fa-f](_*[0-9A-Fa-f])*([Pp][+-]?[0-9]+)?(f(8|16|32|64|128))?>"

syn match c3Operator display "\v\.\.\.?"
syn match c3Operator display "\v(\<\<|\>\>|[<>=!+*/%&~^|-])\=?"
syn match c3Operator display "\v\+\+|--|\&\&|\|\||\?\?|::|\?:|\=>|[\[]<|>[\]]|\$\$"

syn match c3Delimiter display "\v[;,:\{\}\(\)\[\].?]"

syn match c3HexBytes display "\v<x'([ \f\n\t\v]?[0-9A-Fa-f][ \f\n\t\v0-9A-Fa-f]+)+'"
syn match c3HexBytes display "\v<x\"([ \f\n\t\v]?[0-9A-Fa-f][ \f\n\t\v0-9A-Fa-f]+)+\""
syn match c3HexBytes display "\v<x`([ \f\n\t\v]?[0-9A-Fa-f][ \f\n\t\v0-9A-Fa-f]+)+`"

syn match c3Base64 display "\v<b64'([ \f\n\t\v]?[A-Za-z0-9+/][ \f\n\t\vA-Za-z0-9+/]+)+(\=|\=\=)?'"
syn match c3Base64 display "\v<b64\"([ \f\n\t\v]?[A-Za-z0-9+/][ \f\n\t\vA-Za-z0-9+/]+)+(\=|\=\=)?\""
syn match c3Base64 display "\v<b64`([ \f\n\t\v]?[A-Za-z0-9+/][ \f\n\t\vA-Za-z0-9+/]+)+(\=|\=\=)?`"

syn match c3String display "\v\"(\\.|[^\\\"])*\""
syn match c3String display "\v`(``|.)*`"

syn region c3Comment display start="\v/\*"   end="\v\*/" contains=c3Comment,c3Todo
syn region c3Comment display start="\v//"    end="\v$"   contains=c3Todo
syn region c3Comment display start="\v/\*\*" end="\v\*/" contains=c3Contract,c3Todo

syn match c3Contract contained "\v<\@require>"
syn match c3Contract contained "\v<\@ensure>"
syn match c3Contract contained "\v<\@param\s+\[(in|out|inout)\]"
syn match c3Contract contained "\v<\@pure>"

syn keyword c3Todo todo Todo TODO contained

" TODO: Comment nesting

syn keyword c3Keyword
      \ if else
      \ try catch
      \ defer return
      \ switch case nextcase default
      \ cast asm
      \ def fn enum macro fault struct bitstruct interface
      \ module import

syn keyword c3Repeat
      \ do while while 
      \ for foreach foreach_r
      \ continue break

syn keyword c3Specifier extern inline static tlocal
syn keyword c3Specifier var const

syn keyword c3BuiltinType typeid errtype void any anyfault bool
syn keyword c3BuiltinType ichar short  int  long  int128  isz iptr
syn keyword c3BuiltinType char  ushort uint ulong uint128 usz uptr
syn keyword c3BuiltinType float16 float double float128

syn keyword c3Null null
syn keyword c3Boolean true false

syn match c3BuiltinAttr display "\v\@align"
syn match c3BuiltinAttr display "\v\@benchmark"
syn match c3BuiltinAttr display "\v\@bigendian"
syn match c3BuiltinAttr display "\v\@builtin"
syn match c3BuiltinAttr display "\v\@callconv"
syn match c3BuiltinAttr display "\v\@deprecated"
syn match c3BuiltinAttr display "\v\@dynamic"
syn match c3BuiltinAttr display "\v\@export"
syn match c3BuiltinAttr display "\v\@extern"
syn match c3BuiltinAttr display "\v\@if"
syn match c3BuiltinAttr display "\v\@inline"
syn match c3BuiltinAttr display "\v\@interface"
syn match c3BuiltinAttr display "\v\@littleendian"
syn match c3BuiltinAttr display "\v\@local"
syn match c3BuiltinAttr display "\v\@maydiscard"
syn match c3BuiltinAttr display "\v\@naked"
syn match c3BuiltinAttr display "\v\@nodiscard"
syn match c3BuiltinAttr display "\v\@noinit"
syn match c3BuiltinAttr display "\v\@noreturn"
syn match c3BuiltinAttr display "\v\@nostrip"
syn match c3BuiltinAttr display "\v\@obfuscate"
syn match c3BuiltinAttr display "\v\@operator"
syn match c3BuiltinAttr display "\v\@optional"
syn match c3BuiltinAttr display "\v\@overlap"
syn match c3BuiltinAttr display "\v\@priority"
syn match c3BuiltinAttr display "\v\@private"
syn match c3BuiltinAttr display "\v\@public"
syn match c3BuiltinAttr display "\v\@pure"
syn match c3BuiltinAttr display "\v\@reflect"
syn match c3BuiltinAttr display "\v\@section"
syn match c3BuiltinAttr display "\v\@test"
syn match c3BuiltinAttr display "\v\@used"
syn match c3BuiltinAttr display "\v\@unused"

syn match c3ComptimeKw display "\$and"
syn match c3ComptimeKw display "\$assert"
syn match c3ComptimeKw display "\$case"
syn match c3ComptimeKw display "\$default"
syn match c3ComptimeKw display "\$echo"
syn match c3ComptimeKw display "\$else"
syn match c3ComptimeKw display "\$error"
syn match c3ComptimeKw display "\$endfor"
syn match c3ComptimeKw display "\$endforeach"
syn match c3ComptimeKw display "\$endif"
syn match c3ComptimeKw display "\$endswitch"
syn match c3ComptimeKw display "\$for"
syn match c3ComptimeKw display "\$foreach"
syn match c3ComptimeKw display "\$if"
syn match c3ComptimeKw display "\$switch"
syn match c3ComptimeKw display "\$typef"
syn match c3ComptimeKw display "\$vaarg"
syn match c3ComptimeKw display "\$vaconst"
syn match c3ComptimeKw display "\$vacount"
syn match c3ComptimeKw display "\$varef"
syn match c3ComptimeKw display "\$vatype"

hi def link c3Number       Number
hi def link c3Float        Number
hi def link c3Identifier   Identifier
hi def link c3ComptimeId   Identifier

if hlexists('@namespace')
  hi def link c3UserAttr     @namespace
  hi def link c3BuiltinAttr  @namespace
else
  hi def link c3UserAttr     Special
  hi def link c3BuiltinAttr  Special
endif

hi def link c3Function     Function
hi def link c3Function     Macro
hi def link c3BuiltinType  Type
hi def link c3Label        Label
hi def link c3UserType     Type
hi def link c3Keyword      Keyword
hi def link c3ComptimeKw   Keyword
hi def link c3Specifier    StorageClass
hi def link c3Repeat       Repeat
hi def link c3Boolean      Boolean
hi def link c3Null         Boolean
hi def link c3GlobalConst  Constant
hi def link c3String       String
hi def link c3HexBytes     String
hi def link c3Base64       String
hi def link c3Operator     Operator
hi def link c3Delimiter    Delimiter
hi def link c3Comment      Comment
hi def link c3Contract     Comment

let b:current_syntax = "c3"

