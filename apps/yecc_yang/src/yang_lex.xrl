Definitions.
O	= [0-7]
D	= [0-9]
H	= [0-9a-fA-F]
U	= [A-Z]
L	= [a-z]
A	= ({U}|{L}|{D}|_|-|'.'|:|/)
AU  = ({U}|{L}|_|/)
WS	= ([\000-\s]|%.*)
Rules.
% reserved_word(TokenChars) of
%true -> {atom, TokenLine, list_to_atom(TokenChars)};
%false -> {TokenLine, TokenChars}
%
%% here we skip this...
%%An identifier MUST NOT start with (('X'|'x') ('M'|'m') ('L'|'l'))
/\*(\\\^.|\\.|[^\*]|(\*[^/]))*\*/ : skip_token.
{D}+\.{D}+((E|e)(\+|\-)?{D}+)? :
			{token,{float,TokenLine,list_to_float(TokenChars)}}.
"(\\\^.|\\.|[^"])*" : %% Strip quotes.
			S = lists:sublist(TokenChars, 2, TokenLen - 2),
			{token,{string,TokenLine,string_gen(S)}}.
{D}+		:	{token,{integer,TokenLine,list_to_integer(TokenChars)}}.
{AU}{A}*		:	Atom = list_to_atom(TokenChars),
			{token,case reserved_word(Atom) of
				   true -> {Atom,TokenLine};
				   false -> {ident,TokenLine,Atom}
			       end}.
'(\\\^.|\\.|[^'])*' : {token, {string_pattern, TokenLine, TokenChars}}.
\.{WS}		:	{end_token,{dot,TokenLine}}.
{WS}+		:	skip_token.
/\*(\\\^.|\\.|[^(\*/)])*" : skip_token.
%% ABS path
%4DIGIT "-" 2DIGIT "-" 2DIGIT
{D}{D}{D}{D}-{D}{D}-{D}{D} : {token, {date, TokenLine, TokenChars}}.
[]()[}{|!?;,.*+#<>=-] :
			{token,{list_to_atom(TokenChars),TokenLine}}.

Erlang code.
%% statement keywords
reserved_word(anyxml) -> true;
reserved_word(argument) -> true;
reserved_word(augment) -> true;
reserved_word(base) -> true;
reserved_word('belongs-to') -> true;
reserved_word(bit) -> true;
reserved_word('case') -> true;
reserved_word(choice) -> true;
reserved_word(config) -> true;
reserved_word(contact) -> true;
reserved_word(container) -> true;
reserved_word(default) -> true;
reserved_word(description) -> true;
reserved_word(enum) -> true;
reserved_word('error-app-tag') -> true;
reserved_word('error-message') -> true;
reserved_word(extension) -> true;
reserved_word(deviation) -> true;
reserved_word(deviate) -> true;
reserved_word(feature) -> true;
reserved_word('fraction-digits') -> true;
reserved_word(grouping) -> true;
reserved_word(identity) -> true;
reserved_word('if-feature') -> true;
reserved_word(import) -> true;
reserved_word(include) -> true;
reserved_word(input) -> true;
reserved_word(key) -> true;
reserved_word(leaf) -> true;
reserved_word('leaf-list') -> true;
reserved_word(length) -> true;
reserved_word(list) -> true;
reserved_word(mandatory) -> true;
reserved_word('max-elements') -> true;
reserved_word('min-elements') -> true;
reserved_word(module) -> true;
reserved_word(must) -> true;
reserved_word(namespace) -> true;
reserved_word(notification) -> true;
reserved_word('ordered-by') -> true;
reserved_word(organization) -> true;
reserved_word(output) -> true;
reserved_word(path) -> true;
reserved_word(pattern) -> true;
reserved_word(position) -> true;
reserved_word(prefix) -> true;
reserved_word(presence) -> true;
reserved_word(range) -> true;
reserved_word(reference) -> true;
reserved_word(refine) -> true;
reserved_word('require-instance') -> true;
reserved_word('revision') -> true;
reserved_word('revision-date') -> true;
reserved_word(rpc) -> true;
reserved_word(status) -> true;
reserved_word(submodule) -> true;
reserved_word(type) -> true;
reserved_word(typedef) -> true;
reserved_word(unique) -> true;
reserved_word(units) -> true;
reserved_word(uses) -> true;
reserved_word(value) -> true;
reserved_word('when') -> true;
reserved_word('yang-version') -> true;
reserved_word('yin-element') -> true;
reserved_word(add) -> true;
reserved_word(current) -> true;
reserved_word(delete) -> true;
reserved_word(deprecated) -> true;
reserved_word(false) -> true;
reserved_word(max) -> true;
reserved_word(min) -> true;
reserved_word('not-supported') -> true;
reserved_word('obsolete') -> true;
reserved_word(replace) -> true;
reserved_word(system) -> true;
reserved_word(true) -> true;
reserved_word(unbounded) -> true;
reserved_word(user) -> true;
reserved_word(_) -> false.


string_gen([$\\|Cs]) ->
    string_escape(Cs);
string_gen([C|Cs]) ->
    [C|string_gen(Cs)];
string_gen([]) -> [].
string_escape([O1,O2,O3|S]) when
  O1 >= $0, O1 =< $7, O2 >= $0, O2 =< $7, O3 >= $0, O3 =< $7 ->
    [(O1*8 + O2)*8 + O3 - 73*$0|string_gen(S)];
string_escape([$^,C|Cs]) ->
    [C band 31|string_gen(Cs)];
string_escape([C|Cs]) when C >= $\000, C =< $\s ->
    string_gen(Cs);
string_escape([C|Cs]) ->
    [escape_char(C)|string_gen(Cs)].

escape_char($n) -> $\n;				%\n = LF
escape_char($r) -> $\r;				%\r = CR
escape_char($t) -> $\t;				%\t = TAB
escape_char($v) -> $\v;				%\v = VT
escape_char($b) -> $\b;				%\b = BS
escape_char($f) -> $\f;				%\f = FF
escape_char($e) -> $\e;				%\e = ESC
escape_char($s) -> $\s;				%\s = SPC
escape_char($d) -> $\d;				%\d = DEL
escape_char(C) -> C.
