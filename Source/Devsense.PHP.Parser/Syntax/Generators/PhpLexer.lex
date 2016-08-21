/*

 Copyright (c) 2016 Michal Brabec

 The use and distribution terms for this software are contained in the file named License.txt, 
 which can be found in the root of the Phalanger distribution. By using this software 
 in any fashion, you are agreeing to be bound by the terms of this license.
 
 You must not remove this notice from this software.

*/

using System;
using System.Collections.Generic;

%%

%namespace Devsense.PHP.Syntax
%type Tokens
%class Lexer
%eofval Tokens.EOF
%errorval Tokens.T_ERROR
%attributes public partial
%function NextToken
%ignorecase
%charmap Map
%char

%x INITIAL
%x ST_IN_SCRIPTING
%x ST_DOUBLE_QUOTES
%x ST_SINGLE_QUOTES
%x ST_BACKQUOTE
%x ST_HEREDOC
%x ST_NEWDOC
%x ST_LOOKING_FOR_PROPERTY
%x ST_LOOKING_FOR_VARNAME
%x ST_DOC_COMMENT
%x ST_COMMENT
%x ST_ONE_LINE_COMMENT
%x ST_VAR_OFFSET
%x ST_END_HEREDOC
%x ST_NOWDOC

re2c:yyfill:check = 0;
LNUM	[0-9]+
DNUM	([0-9]*"."[0-9]+)|([0-9]+"."[0-9]*)
EXPONENT_DNUM	(({LNUM}|{DNUM})[eE][+-]?{LNUM})
HNUM	"0x"[0-9a-fA-F]+
BNUM	"0b"[01]+
LABEL	[a-zA-Z_][a-zA-Z0-9_]* //[a-zA-Z_\x80-\xff][a-zA-Z0-9_\x80-\xff]* // support of unicode
WHITESPACE [ \n\r\t]+
TABS_AND_SPACES [ \t]*
TOKENS [;:,.\[\]()|^&+-/*=%!~$<>?@]
ANY_CHAR [^]
NEWLINE ("\r"|"\n"|"\r\n"|\x2028|\x2029)

NonVariableStart        [^a-zA-Z_{]

/* compute yyleng before each rule */
<!*> := yyleng = YYCURSOR - SCNG(yy_text);

%%

<ST_IN_SCRIPTING>"exit" { 
	this._tokenSemantics.Object = GetTokenString();
	return (Tokens.T_EXIT); 
}

<ST_IN_SCRIPTING>"die" {
	this._tokenSemantics.Object = GetTokenString();
	return (Tokens.T_EXIT);
}

<ST_IN_SCRIPTING>"function" {
	this._tokenSemantics.Object = GetTokenString();
	return (Tokens.T_FUNCTION);
}

<ST_IN_SCRIPTING>"const" {
	this._tokenSemantics.Object = GetTokenString();
	return (Tokens.T_CONST);
}

<ST_IN_SCRIPTING>"return" {
	this._tokenSemantics.Object = GetTokenString();
	return (Tokens.T_RETURN);
}

<ST_IN_SCRIPTING>"yield"{WHITESPACE}"from" {
	//HANDLE_NEWLINES(yytext, yyleng);
	return (Tokens.T_YIELD_FROM);
}

<ST_IN_SCRIPTING>"yield" {
	this._tokenSemantics.Object = GetTokenString();
	return (Tokens.T_YIELD);
}

<ST_IN_SCRIPTING>"try" {
	this._tokenSemantics.Object = GetTokenString();
	return (Tokens.T_TRY);
}

<ST_IN_SCRIPTING>"catch" {
	this._tokenSemantics.Object = GetTokenString();
	return (Tokens.T_CATCH);
}

<ST_IN_SCRIPTING>"finally" {
	this._tokenSemantics.Object = GetTokenString();
	return (Tokens.T_FINALLY);
}

<ST_IN_SCRIPTING>"throw" {
	this._tokenSemantics.Object = GetTokenString();
	return (Tokens.T_THROW);
}

<ST_IN_SCRIPTING>"if" {
	this._tokenSemantics.Object = GetTokenString();
	return (Tokens.T_IF);
}

<ST_IN_SCRIPTING>"elseif" {
	this._tokenSemantics.Object = GetTokenString();
	return (Tokens.T_ELSEIF);
}

<ST_IN_SCRIPTING>"endif" {
	this._tokenSemantics.Object = GetTokenString();
	return (Tokens.T_ENDIF);
}

<ST_IN_SCRIPTING>"else" {
	this._tokenSemantics.Object = GetTokenString();
	return (Tokens.T_ELSE);
}

<ST_IN_SCRIPTING>"while" {
	this._tokenSemantics.Object = GetTokenString();
	return (Tokens.T_WHILE);
}

<ST_IN_SCRIPTING>"endwhile" {
	this._tokenSemantics.Object = GetTokenString();
	return (Tokens.T_ENDWHILE);
}

<ST_IN_SCRIPTING>"do" {
	this._tokenSemantics.Object = GetTokenString();
	return (Tokens.T_DO);
}

<ST_IN_SCRIPTING>"for" {
	this._tokenSemantics.Object = GetTokenString();
	return (Tokens.T_FOR);
}

<ST_IN_SCRIPTING>"endfor" {
	this._tokenSemantics.Object = GetTokenString();
	return (Tokens.T_ENDFOR);
}

<ST_IN_SCRIPTING>"foreach" {
	this._tokenSemantics.Object = GetTokenString();
	return (Tokens.T_FOREACH);
}

<ST_IN_SCRIPTING>"endforeach" {
	this._tokenSemantics.Object = GetTokenString();
	return (Tokens.T_ENDFOREACH);
}

<ST_IN_SCRIPTING>"declare" {
	this._tokenSemantics.Object = GetTokenString();
	return (Tokens.T_DECLARE);
}

<ST_IN_SCRIPTING>"enddeclare" {
	this._tokenSemantics.Object = GetTokenString();
	return (Tokens.T_ENDDECLARE);
}

<ST_IN_SCRIPTING>"instanceof" {
	this._tokenSemantics.Object = GetTokenString();
	return (Tokens.T_INSTANCEOF);
}

<ST_IN_SCRIPTING>"as" {
	this._tokenSemantics.Object = GetTokenString();
	return (Tokens.T_AS);
}

<ST_IN_SCRIPTING>"switch" {
	this._tokenSemantics.Object = GetTokenString();
	return (Tokens.T_SWITCH);
}

<ST_IN_SCRIPTING>"endswitch" {
	this._tokenSemantics.Object = GetTokenString();
	return (Tokens.T_ENDSWITCH);
}

<ST_IN_SCRIPTING>"case" {
	this._tokenSemantics.Object = GetTokenString();
	return (Tokens.T_CASE);
}

<ST_IN_SCRIPTING>"default" {
	this._tokenSemantics.Object = GetTokenString();
	return (Tokens.T_DEFAULT);
}

<ST_IN_SCRIPTING>"break" {
	this._tokenSemantics.Object = GetTokenString();
	return (Tokens.T_BREAK);
}

<ST_IN_SCRIPTING>"continue" {
	this._tokenSemantics.Object = GetTokenString();
	return (Tokens.T_CONTINUE);
}

<ST_IN_SCRIPTING>"goto" {
	this._tokenSemantics.Object = GetTokenString();
	return (Tokens.T_GOTO);
}

<ST_IN_SCRIPTING>"echo" {
	this._tokenSemantics.Object = GetTokenString();
	return (Tokens.T_ECHO);
}

<ST_IN_SCRIPTING>"print" {
	this._tokenSemantics.Object = GetTokenString();
	return (Tokens.T_PRINT);
}

<ST_IN_SCRIPTING>"class" {
	this._tokenSemantics.Object = GetTokenString();
	return (Tokens.T_CLASS);
}

<ST_IN_SCRIPTING>"interface" {
	this._tokenSemantics.Object = GetTokenString();
	return (Tokens.T_INTERFACE);
}

<ST_IN_SCRIPTING>"trait" {
	this._tokenSemantics.Object = GetTokenString();
	return (Tokens.T_TRAIT);
}

<ST_IN_SCRIPTING>"extends" {
	this._tokenSemantics.Object = GetTokenString();
	return (Tokens.T_EXTENDS);
}

<ST_IN_SCRIPTING>"implements" {
	this._tokenSemantics.Object = GetTokenString();
	return (Tokens.T_IMPLEMENTS);
}

<ST_IN_SCRIPTING>"->" {
	yy_push_state(LexicalStates.ST_LOOKING_FOR_PROPERTY);
	return (Tokens.T_OBJECT_OPERATOR);
}

<ST_IN_SCRIPTING,ST_LOOKING_FOR_PROPERTY>{WHITESPACE}+ {
	//HANDLE_NEWLINES(yytext, yyleng);
	return (Tokens.T_WHITESPACE);
}

<ST_LOOKING_FOR_PROPERTY>"->" {
	return (Tokens.T_OBJECT_OPERATOR);
}

<ST_LOOKING_FOR_PROPERTY>{LABEL} {
	yy_pop_state();
	return ProcessLabel();
}

<ST_LOOKING_FOR_PROPERTY>{ANY_CHAR} {
	yyless(0);
	if (!yy_pop_state()) return Tokens.T_ERROR;
	break;
}

<ST_IN_SCRIPTING>"::" {
	return (Tokens.T_DOUBLE_COLON);
}

<ST_IN_SCRIPTING>"\\" {
	return (Tokens.T_NS_SEPARATOR);
}

<ST_IN_SCRIPTING>"..." {
	return (Tokens.T_ELLIPSIS);
}

<ST_IN_SCRIPTING>"??" {
	return (Tokens.T_COALESCE);
}

<ST_IN_SCRIPTING>"new" {
	this._tokenSemantics.Object = GetTokenString();
	return (Tokens.T_NEW);
}

<ST_IN_SCRIPTING>"clone" {
	this._tokenSemantics.Object = GetTokenString();
	return (Tokens.T_CLONE);
}

<ST_IN_SCRIPTING>"var" {
	this._tokenSemantics.Object = GetTokenString();
	return (Tokens.T_VAR);
}

<ST_IN_SCRIPTING>"("{TABS_AND_SPACES}("int"|"integer"){TABS_AND_SPACES}")" {
	return (Tokens.T_INT_CAST);
}

<ST_IN_SCRIPTING>"("{TABS_AND_SPACES}("real"|"double"|"float"){TABS_AND_SPACES}")" {
	return (Tokens.T_DOUBLE_CAST);
}

<ST_IN_SCRIPTING>"("{TABS_AND_SPACES}("string"|"binary"){TABS_AND_SPACES}")" {
	return (Tokens.T_STRING_CAST);
}

<ST_IN_SCRIPTING>"("{TABS_AND_SPACES}"array"{TABS_AND_SPACES}")" {
	return (Tokens.T_ARRAY_CAST);
}

<ST_IN_SCRIPTING>"("{TABS_AND_SPACES}"object"{TABS_AND_SPACES}")" {
	return (Tokens.T_OBJECT_CAST);
}

<ST_IN_SCRIPTING>"("{TABS_AND_SPACES}("bool"|"boolean"){TABS_AND_SPACES}")" {
	return (Tokens.T_BOOL_CAST);
}

<ST_IN_SCRIPTING>"("{TABS_AND_SPACES}("unset"){TABS_AND_SPACES}")" {
	return (Tokens.T_UNSET_CAST);
}

<ST_IN_SCRIPTING>"eval" {
	this._tokenSemantics.Object = GetTokenString();
	return (Tokens.T_EVAL);
}

<ST_IN_SCRIPTING>"include" {
	this._tokenSemantics.Object = GetTokenString();
	return (Tokens.T_INCLUDE);
}

<ST_IN_SCRIPTING>"include_once" {
	this._tokenSemantics.Object = GetTokenString();
	return (Tokens.T_INCLUDE_ONCE);
}

<ST_IN_SCRIPTING>"require" {
	this._tokenSemantics.Object = GetTokenString();
	return (Tokens.T_REQUIRE);
}

<ST_IN_SCRIPTING>"require_once" {
	this._tokenSemantics.Object = GetTokenString();
	return (Tokens.T_REQUIRE_ONCE);
}

<ST_IN_SCRIPTING>"namespace" {
	this._tokenSemantics.Object = GetTokenString();
	return (Tokens.T_NAMESPACE);
}

<ST_IN_SCRIPTING>"use" {
	this._tokenSemantics.Object = GetTokenString();
	return (Tokens.T_USE);
}

<ST_IN_SCRIPTING>"insteadof" {
	this._tokenSemantics.Object = GetTokenString();
    return (Tokens.T_INSTEADOF);
}

<ST_IN_SCRIPTING>"global" {
	this._tokenSemantics.Object = GetTokenString();
	return (Tokens.T_GLOBAL);
}

<ST_IN_SCRIPTING>"isset" {
	this._tokenSemantics.Object = GetTokenString();
	return (Tokens.T_ISSET);
}

<ST_IN_SCRIPTING>"empty" {
	this._tokenSemantics.Object = GetTokenString();
	return (Tokens.T_EMPTY);
}

<ST_IN_SCRIPTING>"__halt_compiler" {
	return (Tokens.T_HALT_COMPILER);
}

<ST_IN_SCRIPTING>"static" {
	this._tokenSemantics.Object = GetTokenString();
	return (Tokens.T_STATIC);
}

<ST_IN_SCRIPTING>"abstract" {
	this._tokenSemantics.Object = GetTokenString();
	return (Tokens.T_ABSTRACT);
}

<ST_IN_SCRIPTING>"final" {
	this._tokenSemantics.Object = GetTokenString();
	return (Tokens.T_FINAL);
}

<ST_IN_SCRIPTING>"private" {
	this._tokenSemantics.Object = GetTokenString();
	return (Tokens.T_PRIVATE);
}

<ST_IN_SCRIPTING>"protected" {
	this._tokenSemantics.Object = GetTokenString();
	return (Tokens.T_PROTECTED);
}

<ST_IN_SCRIPTING>"public" {
	this._tokenSemantics.Object = GetTokenString();
	return (Tokens.T_PUBLIC);
}

<ST_IN_SCRIPTING>"unset" {
	this._tokenSemantics.Object = GetTokenString();
	return (Tokens.T_UNSET);
}

<ST_IN_SCRIPTING>"=>" {
	return (Tokens.T_DOUBLE_ARROW);
}

<ST_IN_SCRIPTING>"list" {
	this._tokenSemantics.Object = GetTokenString();
	return (Tokens.T_LIST);
}

<ST_IN_SCRIPTING>"array" {
	this._tokenSemantics.Object = GetTokenString();
	return (Tokens.T_ARRAY);
}

<ST_IN_SCRIPTING>"callable" {
	this._tokenSemantics.Object = GetTokenString();
	return (Tokens.T_CALLABLE);
}

<ST_IN_SCRIPTING>"++" {
	return (Tokens.T_INC);
}

<ST_IN_SCRIPTING>"--" {
	return (Tokens.T_DEC);
}

<ST_IN_SCRIPTING>"===" {
	return (Tokens.T_IS_IDENTICAL);
}

<ST_IN_SCRIPTING>"!==" {
	return (Tokens.T_IS_NOT_IDENTICAL);
}

<ST_IN_SCRIPTING>"==" {
	return (Tokens.T_IS_EQUAL);
}

<ST_IN_SCRIPTING>"!="|"<>" {
	return (Tokens.T_IS_NOT_EQUAL);
}

<ST_IN_SCRIPTING>"<=>" {
	return (Tokens.T_SPACESHIP);
}

<ST_IN_SCRIPTING>"<=" {
	return (Tokens.T_IS_SMALLER_OR_EQUAL);
}

<ST_IN_SCRIPTING>">=" {
	return (Tokens.T_IS_GREATER_OR_EQUAL);
}

<ST_IN_SCRIPTING>"+=" {
	return (Tokens.T_PLUS_EQUAL);
}

<ST_IN_SCRIPTING>"-=" {
	return (Tokens.T_MINUS_EQUAL);
}

<ST_IN_SCRIPTING>"*=" {
	return (Tokens.T_MUL_EQUAL);
}

<ST_IN_SCRIPTING>"*\*" {
	return (Tokens.T_POW);
}

<ST_IN_SCRIPTING>"*\*=" {
	return (Tokens.T_POW_EQUAL);
}

<ST_IN_SCRIPTING>"/=" {
	return (Tokens.T_DIV_EQUAL);
}

<ST_IN_SCRIPTING>".=" {
	return (Tokens.T_CONCAT_EQUAL);
}

<ST_IN_SCRIPTING>"%=" {
	return (Tokens.T_MOD_EQUAL);
}

<ST_IN_SCRIPTING>"<<=" {
	return (Tokens.T_SL_EQUAL);
}

<ST_IN_SCRIPTING>">>=" {
	return (Tokens.T_SR_EQUAL);
}

<ST_IN_SCRIPTING>"&=" {
	return (Tokens.T_AND_EQUAL);
}

<ST_IN_SCRIPTING>"|=" {
	return (Tokens.T_OR_EQUAL);
}

<ST_IN_SCRIPTING>"^=" {
	return (Tokens.T_XOR_EQUAL);
}

<ST_IN_SCRIPTING>"||" {
	return (Tokens.T_BOOLEAN_OR);
}

<ST_IN_SCRIPTING>"&&" {
	return (Tokens.T_BOOLEAN_AND);
}

<ST_IN_SCRIPTING>"OR" {
	return (Tokens.T_LOGICAL_OR);
}

<ST_IN_SCRIPTING>"AND" {
	return (Tokens.T_LOGICAL_AND);
}

<ST_IN_SCRIPTING>"XOR" {
	return (Tokens.T_LOGICAL_XOR);
}

<ST_IN_SCRIPTING>"<<" {
	return (Tokens.T_SL);
}

<ST_IN_SCRIPTING>">>" {
	return (Tokens.T_SR);
}

<ST_IN_SCRIPTING>{TOKENS} {
	return (Tokens)GetTokenChar(0);
}


<ST_IN_SCRIPTING>"{" {
	yy_push_state(LexicalStates.ST_IN_SCRIPTING); 
	return (Tokens.T_LBRACE);
}


<ST_DOUBLE_QUOTES,ST_BACKQUOTE,ST_HEREDOC>"${" {
	yy_push_state(LexicalStates.ST_LOOKING_FOR_VARNAME);
	return (Tokens.T_DOLLAR_OPEN_CURLY_BRACES);
}


<ST_IN_SCRIPTING>"}" {
	ResetDocBlock();
	if (!yy_pop_state()) 
		return Tokens.T_ERROR; 
	return (Tokens.T_RBRACE);
}


<ST_LOOKING_FOR_VARNAME>{LABEL}[[}] {
	yyless(TokenLength - 1);
	this._tokenSemantics.Object = GetTokenString();
	yy_pop_state();
	yy_push_state(LexicalStates.ST_IN_SCRIPTING);
	return (Tokens.T_STRING_VARNAME);
}


<ST_LOOKING_FOR_VARNAME>{ANY_CHAR} {
	yyless(0);
	if (!yy_pop_state()) return Tokens.T_ERROR;
	yy_push_state(LexicalStates.ST_IN_SCRIPTING);
	break;
}

<ST_IN_SCRIPTING>{BNUM} {
	return ProcessBinaryNumber();
}

<ST_IN_SCRIPTING>{LNUM} {
	return ProcessDecimalNumber();
}

<ST_IN_SCRIPTING>{HNUM} {
	return ProcessHexadecimalNumber();
}

<ST_VAR_OFFSET>[0]|([1-9][0-9]*) { /* Offset could be treated as a long */
	return ProcessVariableOffsetNumber();
}

<ST_VAR_OFFSET>{LNUM}|{HNUM}|{BNUM} { /* Offset must be treated as a string */
	return ProcessVariableOffsetString();
}

<ST_IN_SCRIPTING>{DNUM}|{EXPONENT_DNUM} {
	return ProcessRealNumber();
}

<ST_IN_SCRIPTING>"__CLASS__" {
	this._tokenSemantics.Object = GetTokenString();
	return (Tokens.T_CLASS_C);
}

<ST_IN_SCRIPTING>"__TRAIT__" {
	this._tokenSemantics.Object = GetTokenString();
	return (Tokens.T_TRAIT_C);
}

<ST_IN_SCRIPTING>"__FUNCTION__" {
	this._tokenSemantics.Object = GetTokenString();
	return (Tokens.T_FUNC_C);
}

<ST_IN_SCRIPTING>"__METHOD__" {
	this._tokenSemantics.Object = GetTokenString();
	return (Tokens.T_METHOD_C);
}

<ST_IN_SCRIPTING>"__LINE__" {
	this._tokenSemantics.Object = GetTokenString();
	return (Tokens.T_LINE);
}

<ST_IN_SCRIPTING>"__FILE__" {
	this._tokenSemantics.Object = GetTokenString();
	return (Tokens.T_FILE);
}

<ST_IN_SCRIPTING>"__DIR__" {
	this._tokenSemantics.Object = GetTokenString();
	return (Tokens.T_DIR);
}

<ST_IN_SCRIPTING>"__NAMESPACE__" {
	this._tokenSemantics.Object = GetTokenString();
	return (Tokens.T_NS_C);
}

<INITIAL>(([^<]|<[^?<])+)|< { 
    this._tokenSemantics.Object = GetTokenString();
	return Tokens.T_INLINE_HTML; 
}

<INITIAL>"<?=" {
	BEGIN(LexicalStates.ST_IN_SCRIPTING);
	return (Tokens.T_OPEN_TAG_WITH_ECHO);
}


<INITIAL>"<?php"([ \t]|{NEWLINE}) {
	//HANDLE_NEWLINE(yytext[yyleng-1]);
	BEGIN(LexicalStates.ST_IN_SCRIPTING);
	return (Tokens.T_OPEN_TAG);
}


<INITIAL>"<?" {
	if (this._allowShortTags) {
		BEGIN(LexicalStates.ST_IN_SCRIPTING);
		return (Tokens.T_OPEN_TAG);
	} else {
		yymore(); break;//return Tokens.T_INLINE_HTML;
	}
}

<INITIAL>{ANY_CHAR} {
	
	return Tokens.T_ERROR;
}

<ST_DOUBLE_QUOTES,ST_HEREDOC,ST_BACKQUOTE>"$"{LABEL}"->"[a-zA-Z_\x80-\xff] {
	yyless(TokenLength - 3);
	yy_push_state(LexicalStates.ST_LOOKING_FOR_PROPERTY);
	return ProcessVariable();
}

<ST_DOUBLE_QUOTES,ST_HEREDOC,ST_BACKQUOTE>"$"{LABEL}"[" {
	yyless(TokenLength - 1);
	yy_push_state(LexicalStates.ST_VAR_OFFSET);
	return ProcessVariable();
}

<ST_IN_SCRIPTING,ST_DOUBLE_QUOTES,ST_HEREDOC,ST_BACKQUOTE,ST_VAR_OFFSET>"$"{LABEL} {
	return ProcessVariable();
}

<ST_VAR_OFFSET>"]" {
	yy_pop_state();
	return (Tokens.T_RBRACKET);
}

<ST_VAR_OFFSET>{TOKENS}|[{}"`] {
	/* Only '[' can be valid, but returning other tokens will allow a more explicit parse error */
	return (Tokens)GetTokenChar(0);
}

<ST_VAR_OFFSET>[ \n\r\t\\'#] {
	/* Invalid rule to return a more explicit parse error with proper line number */
	yyless(0);
	yy_pop_state();
	return (Tokens.T_ENCAPSED_AND_WHITESPACE);
}

<ST_IN_SCRIPTING,ST_VAR_OFFSET>{LABEL} {
	return ProcessLabel();
}


<ST_IN_SCRIPTING>"#"|"//" {
	BEGIN(LexicalStates.ST_ONE_LINE_COMMENT); 
	yymore(); 
	break;
}

<ST_IN_SCRIPTING>"/*"              	{ BEGIN(LexicalStates.ST_COMMENT); yymore(); break; }
<ST_COMMENT>[^*]+       { yymore(); break; }
<ST_COMMENT>"*/"        { BEGIN(LexicalStates.ST_IN_SCRIPTING); return Tokens.T_COMMENT; }
<ST_COMMENT>"*"         { yymore(); break; }

<ST_IN_SCRIPTING>"/**"{WHITESPACE} 	{ BEGIN(LexicalStates.ST_DOC_COMMENT); yymore(); ResetDocBlock(); break; }
<ST_DOC_COMMENT>[^*]+   { yymore(); break; }
<ST_DOC_COMMENT>"*/"    { BEGIN(LexicalStates.ST_IN_SCRIPTING); SetDocBlock(); return Tokens.T_DOC_COMMENT; }
<ST_DOC_COMMENT>"*"     { yymore(); break; }

<ST_IN_SCRIPTING>"?>"{NEWLINE}? {
	BEGIN(LexicalStates.INITIAL);
	return (Tokens.T_CLOSE_TAG);  /* implicit ';' at php-end tag */
}

<ST_IN_SCRIPTING>(b?[']([^'\\]|("\\".)|("\\"{NEWLINE}))*['])  { return ProcessSingleQuotedString(); }
<ST_IN_SCRIPTING>b?['] 
{ 
	// Gets here only in the case of unterminated singly-quoted string. That leads usually to an error token,
	// however when the source code is parsed per-line (as in Visual Studio colorizer) it is important to remember
	// that we are in the singly-quoted string at the end of the line.
	BEGIN(LexicalStates.ST_SINGLE_QUOTES); 
	yymore(); 
	break; 
}
<ST_SINGLE_QUOTES>([^'\\]|("\\".)|("\\"{NEWLINE}))+ { yymore(); break; }
<ST_SINGLE_QUOTES>"'"                               { BEGIN(LexicalStates.ST_IN_SCRIPTING); return ProcessSingleQuotedString(); }

<ST_IN_SCRIPTING>b?["]([^"\{$\\]*(\\.|\{[^$])?)*["] {
	return ProcessDoubleQuotedString();
}

<ST_IN_SCRIPTING>b?["] {
	BEGIN(LexicalStates.ST_DOUBLE_QUOTES);
	return (Tokens.T_DOUBLE_QUOTES);
}


<ST_IN_SCRIPTING>b?"<<<"{TABS_AND_SPACES}({LABEL}|([']{LABEL}['])|(["]{LABEL}["])){NEWLINE} {
	int bprefix = (GetTokenChar(0) != '<') ? 1 : 0;
	int s = bprefix + 3;
    int length = TokenLength - bprefix - 3 - 1 - (GetTokenChar(TokenLength-2) == '\r' ? 1 : 0);
    string tokenString = GetTokenString();
    while ((tokenString[s] == ' ') || (tokenString[s] == '\t')) {
		s++;
        length--;

    }
	if (tokenString[s] == '\'') {
		s++;
        length -= 2;

        BEGIN(LexicalStates.ST_NOWDOC);
	} else {
		if (tokenString[s] == '"') {
			s++;
            length -= 2;
        }
		BEGIN(LexicalStates.ST_HEREDOC);
	}
    this._hereDocLabel = GetTokenSubstring(s, length);
    return (Tokens.T_START_HEREDOC);
}


<ST_IN_SCRIPTING>[`] {
	BEGIN(LexicalStates.ST_BACKQUOTE); 
	return (Tokens.T_BACKQUOTE);
}


<ST_END_HEREDOC>{ANY_CHAR} {
	BEGIN(LexicalStates.ST_IN_SCRIPTING);
	this._tokenSemantics.Object = this._hereDocLabel;
	return (Tokens.T_END_HEREDOC);
}


<ST_DOUBLE_QUOTES,ST_BACKQUOTE,ST_HEREDOC>"{$" {
	//Z_LVAL_P(zendlval) = (zend_long) '{';
	yy_push_state(LexicalStates.ST_IN_SCRIPTING);
	yyless(1);
	return (Tokens.T_CURLY_OPEN);
}



<ST_DOUBLE_QUOTES>["] {
	BEGIN(LexicalStates.ST_IN_SCRIPTING);
	return (Tokens.T_DOUBLE_QUOTES);
}

<ST_BACKQUOTE>[`] {
	BEGIN(LexicalStates.ST_IN_SCRIPTING);
	return (Tokens.T_BACKQUOTE);
}

<ST_NOWDOC>^{LABEL}(";")?{NEWLINE} {
    if(GetTokenString().Contains(this._hereDocLabel))
		return ProcessEndNowDoc(s => s);
    yymore(); break;
}

<ST_HEREDOC>^{LABEL}(";")?{NEWLINE} {
    if(GetTokenString().Contains(this._hereDocLabel))
		return ProcessEndNowDoc(s => (string)ProcessEscapedString(s, _encoding, false));
    yymore(); break;
}

<ST_NOWDOC>{ANY_CHAR}         { yymore(); break; }

<ST_DOUBLE_QUOTES>([^"\{$\\]*(\\.|\{[^$])?)* {
    this._tokenSemantics.Object = ProcessEscapedString(GetTokenString(), _encoding, false);
    return (Tokens.T_ENCAPSED_AND_WHITESPACE);
}

<ST_BACKQUOTE>([^`\{$\\]*(\\.|\{[^$])?)* {
    this._tokenSemantics.Object = ProcessEscapedString(GetTokenString(), _encoding, false);
    return (Tokens.T_ENCAPSED_AND_WHITESPACE);
}

<ST_HEREDOC>([^\n\r\x2028\x2029\{$\\]*(\\.|\{[^$])?)*{NEWLINE} { yymore(); break; }

<ST_HEREDOC>([^\n\r\x2028\x2029\{$\\]*(\\.|\{[^$])?)* {
    this._tokenSemantics.Object = ProcessEscapedString(GetTokenString(), _encoding, false);
    return (Tokens.T_ENCAPSED_AND_WHITESPACE);
}


<ST_IN_SCRIPTING,ST_VAR_OFFSET>{ANY_CHAR} {
	//zend_error(E_COMPILE_WARNING,"Unexpected character in input:  '%c' (ASCII=%d) state=%d", yytext[0], yytext[0], YYSTATE);
	return Tokens.T_ERROR;
}


<ST_ONE_LINE_COMMENT>"?"|"%"|">" { yymore(); break; }
<ST_ONE_LINE_COMMENT>[^\n\r?%>]+ { yymore(); break; }
<ST_ONE_LINE_COMMENT>{NEWLINE}   { BEGIN(LexicalStates.ST_IN_SCRIPTING); return Tokens.T_COMMENT; }

<ST_ONE_LINE_COMMENT>"?>"|"%>"   { yymore(); break; }