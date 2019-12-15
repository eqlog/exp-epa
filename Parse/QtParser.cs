//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by a tool.
//     ANTLR Version: 4.7.2
//
//     Changes to this file may cause incorrect behavior and will be lost if
//     the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

// Generated from .\Qt.g4 by ANTLR 4.7.2

// Unreachable code detected
#pragma warning disable 0162
// The variable '...' is assigned but its value is never used
#pragma warning disable 0219
// Missing XML comment for publicly visible type or member '...'
#pragma warning disable 1591
// Ambiguous reference in cref attribute
#pragma warning disable 419

using System;
using System.IO;
using System.Text;
using System.Diagnostics;
using System.Collections.Generic;
using Antlr4.Runtime;
using Antlr4.Runtime.Atn;
using Antlr4.Runtime.Misc;
using Antlr4.Runtime.Tree;
using DFA = Antlr4.Runtime.Dfa.DFA;

[System.CodeDom.Compiler.GeneratedCode("ANTLR", "4.7.2")]
[System.CLSCompliant(false)]
public partial class QtParser : Parser {
	protected static DFA[] decisionToDFA;
	protected static PredictionContextCache sharedContextCache = new PredictionContextCache();
	public const int
		T__0=1, T__1=2, T__2=3, T__3=4, T__4=5, T__5=6, T__6=7, ID=8, WS=9;
	public const int
		RULE_unit = 0, RULE_def = 1, RULE_param = 2, RULE_ty = 3, RULE_expr = 4, 
		RULE_letExpr = 5, RULE_idExpr = 6;
	public static readonly string[] ruleNames = {
		"unit", "def", "param", "ty", "expr", "letExpr", "idExpr"
	};

	private static readonly string[] _LiteralNames = {
		null, "'def'", "':'", "':='", "'('", "')'", "'let'", "'in'"
	};
	private static readonly string[] _SymbolicNames = {
		null, null, null, null, null, null, null, null, "ID", "WS"
	};
	public static readonly IVocabulary DefaultVocabulary = new Vocabulary(_LiteralNames, _SymbolicNames);

	[NotNull]
	public override IVocabulary Vocabulary
	{
		get
		{
			return DefaultVocabulary;
		}
	}

	public override string GrammarFileName { get { return "Qt.g4"; } }

	public override string[] RuleNames { get { return ruleNames; } }

	public override string SerializedAtn { get { return new string(_serializedATN); } }

	static QtParser() {
		decisionToDFA = new DFA[_ATN.NumberOfDecisions];
		for (int i = 0; i < _ATN.NumberOfDecisions; i++) {
			decisionToDFA[i] = new DFA(_ATN.GetDecisionState(i), i);
		}
	}

		public QtParser(ITokenStream input) : this(input, Console.Out, Console.Error) { }

		public QtParser(ITokenStream input, TextWriter output, TextWriter errorOutput)
		: base(input, output, errorOutput)
	{
		Interpreter = new ParserATNSimulator(this, _ATN, decisionToDFA, sharedContextCache);
	}

	public partial class UnitContext : ParserRuleContext {
		public DefContext[] def() {
			return GetRuleContexts<DefContext>();
		}
		public DefContext def(int i) {
			return GetRuleContext<DefContext>(i);
		}
		public UnitContext(ParserRuleContext parent, int invokingState)
			: base(parent, invokingState)
		{
		}
		public override int RuleIndex { get { return RULE_unit; } }
		public override void EnterRule(IParseTreeListener listener) {
			IQtListener typedListener = listener as IQtListener;
			if (typedListener != null) typedListener.EnterUnit(this);
		}
		public override void ExitRule(IParseTreeListener listener) {
			IQtListener typedListener = listener as IQtListener;
			if (typedListener != null) typedListener.ExitUnit(this);
		}
		public override TResult Accept<TResult>(IParseTreeVisitor<TResult> visitor) {
			IQtVisitor<TResult> typedVisitor = visitor as IQtVisitor<TResult>;
			if (typedVisitor != null) return typedVisitor.VisitUnit(this);
			else return visitor.VisitChildren(this);
		}
	}

	[RuleVersion(0)]
	public UnitContext unit() {
		UnitContext _localctx = new UnitContext(Context, State);
		EnterRule(_localctx, 0, RULE_unit);
		int _la;
		try {
			EnterOuterAlt(_localctx, 1);
			{
			State = 17;
			ErrorHandler.Sync(this);
			_la = TokenStream.LA(1);
			while (_la==T__0) {
				{
				{
				State = 14; def();
				}
				}
				State = 19;
				ErrorHandler.Sync(this);
				_la = TokenStream.LA(1);
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			ErrorHandler.ReportError(this, re);
			ErrorHandler.Recover(this, re);
		}
		finally {
			ExitRule();
		}
		return _localctx;
	}

	public partial class DefContext : ParserRuleContext {
		public IToken name;
		public TyContext retTy;
		public ExprContext body;
		public ITerminalNode ID() { return GetToken(QtParser.ID, 0); }
		public TyContext ty() {
			return GetRuleContext<TyContext>(0);
		}
		public ExprContext expr() {
			return GetRuleContext<ExprContext>(0);
		}
		public ParamContext[] param() {
			return GetRuleContexts<ParamContext>();
		}
		public ParamContext param(int i) {
			return GetRuleContext<ParamContext>(i);
		}
		public DefContext(ParserRuleContext parent, int invokingState)
			: base(parent, invokingState)
		{
		}
		public override int RuleIndex { get { return RULE_def; } }
		public override void EnterRule(IParseTreeListener listener) {
			IQtListener typedListener = listener as IQtListener;
			if (typedListener != null) typedListener.EnterDef(this);
		}
		public override void ExitRule(IParseTreeListener listener) {
			IQtListener typedListener = listener as IQtListener;
			if (typedListener != null) typedListener.ExitDef(this);
		}
		public override TResult Accept<TResult>(IParseTreeVisitor<TResult> visitor) {
			IQtVisitor<TResult> typedVisitor = visitor as IQtVisitor<TResult>;
			if (typedVisitor != null) return typedVisitor.VisitDef(this);
			else return visitor.VisitChildren(this);
		}
	}

	[RuleVersion(0)]
	public DefContext def() {
		DefContext _localctx = new DefContext(Context, State);
		EnterRule(_localctx, 2, RULE_def);
		int _la;
		try {
			EnterOuterAlt(_localctx, 1);
			{
			State = 20; Match(T__0);
			State = 21; _localctx.name = Match(ID);
			State = 25;
			ErrorHandler.Sync(this);
			_la = TokenStream.LA(1);
			while (_la==T__3) {
				{
				{
				State = 22; param();
				}
				}
				State = 27;
				ErrorHandler.Sync(this);
				_la = TokenStream.LA(1);
			}
			State = 28; Match(T__1);
			State = 29; _localctx.retTy = ty();
			State = 30; Match(T__2);
			State = 31; _localctx.body = expr();
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			ErrorHandler.ReportError(this, re);
			ErrorHandler.Recover(this, re);
		}
		finally {
			ExitRule();
		}
		return _localctx;
	}

	public partial class ParamContext : ParserRuleContext {
		public IToken names;
		public TyContext ty() {
			return GetRuleContext<TyContext>(0);
		}
		public ITerminalNode[] ID() { return GetTokens(QtParser.ID); }
		public ITerminalNode ID(int i) {
			return GetToken(QtParser.ID, i);
		}
		public ParamContext(ParserRuleContext parent, int invokingState)
			: base(parent, invokingState)
		{
		}
		public override int RuleIndex { get { return RULE_param; } }
		public override void EnterRule(IParseTreeListener listener) {
			IQtListener typedListener = listener as IQtListener;
			if (typedListener != null) typedListener.EnterParam(this);
		}
		public override void ExitRule(IParseTreeListener listener) {
			IQtListener typedListener = listener as IQtListener;
			if (typedListener != null) typedListener.ExitParam(this);
		}
		public override TResult Accept<TResult>(IParseTreeVisitor<TResult> visitor) {
			IQtVisitor<TResult> typedVisitor = visitor as IQtVisitor<TResult>;
			if (typedVisitor != null) return typedVisitor.VisitParam(this);
			else return visitor.VisitChildren(this);
		}
	}

	[RuleVersion(0)]
	public ParamContext param() {
		ParamContext _localctx = new ParamContext(Context, State);
		EnterRule(_localctx, 4, RULE_param);
		int _la;
		try {
			EnterOuterAlt(_localctx, 1);
			{
			State = 33; Match(T__3);
			State = 35;
			ErrorHandler.Sync(this);
			_la = TokenStream.LA(1);
			do {
				{
				{
				State = 34; _localctx.names = Match(ID);
				}
				}
				State = 37;
				ErrorHandler.Sync(this);
				_la = TokenStream.LA(1);
			} while ( _la==ID );
			State = 39; Match(T__1);
			State = 40; ty();
			State = 41; Match(T__4);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			ErrorHandler.ReportError(this, re);
			ErrorHandler.Recover(this, re);
		}
		finally {
			ExitRule();
		}
		return _localctx;
	}

	public partial class TyContext : ParserRuleContext {
		public ITerminalNode ID() { return GetToken(QtParser.ID, 0); }
		public TyContext(ParserRuleContext parent, int invokingState)
			: base(parent, invokingState)
		{
		}
		public override int RuleIndex { get { return RULE_ty; } }
		public override void EnterRule(IParseTreeListener listener) {
			IQtListener typedListener = listener as IQtListener;
			if (typedListener != null) typedListener.EnterTy(this);
		}
		public override void ExitRule(IParseTreeListener listener) {
			IQtListener typedListener = listener as IQtListener;
			if (typedListener != null) typedListener.ExitTy(this);
		}
		public override TResult Accept<TResult>(IParseTreeVisitor<TResult> visitor) {
			IQtVisitor<TResult> typedVisitor = visitor as IQtVisitor<TResult>;
			if (typedVisitor != null) return typedVisitor.VisitTy(this);
			else return visitor.VisitChildren(this);
		}
	}

	[RuleVersion(0)]
	public TyContext ty() {
		TyContext _localctx = new TyContext(Context, State);
		EnterRule(_localctx, 6, RULE_ty);
		try {
			EnterOuterAlt(_localctx, 1);
			{
			State = 43; Match(ID);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			ErrorHandler.ReportError(this, re);
			ErrorHandler.Recover(this, re);
		}
		finally {
			ExitRule();
		}
		return _localctx;
	}

	public partial class ExprContext : ParserRuleContext {
		public LetExprContext letExpr() {
			return GetRuleContext<LetExprContext>(0);
		}
		public IdExprContext idExpr() {
			return GetRuleContext<IdExprContext>(0);
		}
		public ExprContext(ParserRuleContext parent, int invokingState)
			: base(parent, invokingState)
		{
		}
		public override int RuleIndex { get { return RULE_expr; } }
		public override void EnterRule(IParseTreeListener listener) {
			IQtListener typedListener = listener as IQtListener;
			if (typedListener != null) typedListener.EnterExpr(this);
		}
		public override void ExitRule(IParseTreeListener listener) {
			IQtListener typedListener = listener as IQtListener;
			if (typedListener != null) typedListener.ExitExpr(this);
		}
		public override TResult Accept<TResult>(IParseTreeVisitor<TResult> visitor) {
			IQtVisitor<TResult> typedVisitor = visitor as IQtVisitor<TResult>;
			if (typedVisitor != null) return typedVisitor.VisitExpr(this);
			else return visitor.VisitChildren(this);
		}
	}

	[RuleVersion(0)]
	public ExprContext expr() {
		ExprContext _localctx = new ExprContext(Context, State);
		EnterRule(_localctx, 8, RULE_expr);
		try {
			State = 47;
			ErrorHandler.Sync(this);
			switch (TokenStream.LA(1)) {
			case T__5:
				EnterOuterAlt(_localctx, 1);
				{
				State = 45; letExpr();
				}
				break;
			case ID:
				EnterOuterAlt(_localctx, 2);
				{
				State = 46; idExpr();
				}
				break;
			default:
				throw new NoViableAltException(this);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			ErrorHandler.ReportError(this, re);
			ErrorHandler.Recover(this, re);
		}
		finally {
			ExitRule();
		}
		return _localctx;
	}

	public partial class LetExprContext : ParserRuleContext {
		public IToken varName;
		public ExprContext val;
		public ExprContext body;
		public TyContext ty() {
			return GetRuleContext<TyContext>(0);
		}
		public ITerminalNode ID() { return GetToken(QtParser.ID, 0); }
		public ExprContext[] expr() {
			return GetRuleContexts<ExprContext>();
		}
		public ExprContext expr(int i) {
			return GetRuleContext<ExprContext>(i);
		}
		public LetExprContext(ParserRuleContext parent, int invokingState)
			: base(parent, invokingState)
		{
		}
		public override int RuleIndex { get { return RULE_letExpr; } }
		public override void EnterRule(IParseTreeListener listener) {
			IQtListener typedListener = listener as IQtListener;
			if (typedListener != null) typedListener.EnterLetExpr(this);
		}
		public override void ExitRule(IParseTreeListener listener) {
			IQtListener typedListener = listener as IQtListener;
			if (typedListener != null) typedListener.ExitLetExpr(this);
		}
		public override TResult Accept<TResult>(IParseTreeVisitor<TResult> visitor) {
			IQtVisitor<TResult> typedVisitor = visitor as IQtVisitor<TResult>;
			if (typedVisitor != null) return typedVisitor.VisitLetExpr(this);
			else return visitor.VisitChildren(this);
		}
	}

	[RuleVersion(0)]
	public LetExprContext letExpr() {
		LetExprContext _localctx = new LetExprContext(Context, State);
		EnterRule(_localctx, 10, RULE_letExpr);
		try {
			EnterOuterAlt(_localctx, 1);
			{
			State = 49; Match(T__5);
			State = 50; _localctx.varName = Match(ID);
			State = 51; Match(T__1);
			State = 52; ty();
			State = 53; Match(T__2);
			State = 54; _localctx.val = expr();
			State = 55; Match(T__6);
			State = 56; _localctx.body = expr();
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			ErrorHandler.ReportError(this, re);
			ErrorHandler.Recover(this, re);
		}
		finally {
			ExitRule();
		}
		return _localctx;
	}

	public partial class IdExprContext : ParserRuleContext {
		public ITerminalNode ID() { return GetToken(QtParser.ID, 0); }
		public IdExprContext(ParserRuleContext parent, int invokingState)
			: base(parent, invokingState)
		{
		}
		public override int RuleIndex { get { return RULE_idExpr; } }
		public override void EnterRule(IParseTreeListener listener) {
			IQtListener typedListener = listener as IQtListener;
			if (typedListener != null) typedListener.EnterIdExpr(this);
		}
		public override void ExitRule(IParseTreeListener listener) {
			IQtListener typedListener = listener as IQtListener;
			if (typedListener != null) typedListener.ExitIdExpr(this);
		}
		public override TResult Accept<TResult>(IParseTreeVisitor<TResult> visitor) {
			IQtVisitor<TResult> typedVisitor = visitor as IQtVisitor<TResult>;
			if (typedVisitor != null) return typedVisitor.VisitIdExpr(this);
			else return visitor.VisitChildren(this);
		}
	}

	[RuleVersion(0)]
	public IdExprContext idExpr() {
		IdExprContext _localctx = new IdExprContext(Context, State);
		EnterRule(_localctx, 12, RULE_idExpr);
		try {
			EnterOuterAlt(_localctx, 1);
			{
			State = 58; Match(ID);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			ErrorHandler.ReportError(this, re);
			ErrorHandler.Recover(this, re);
		}
		finally {
			ExitRule();
		}
		return _localctx;
	}

	private static char[] _serializedATN = {
		'\x3', '\x608B', '\xA72A', '\x8133', '\xB9ED', '\x417C', '\x3BE7', '\x7786', 
		'\x5964', '\x3', '\v', '?', '\x4', '\x2', '\t', '\x2', '\x4', '\x3', '\t', 
		'\x3', '\x4', '\x4', '\t', '\x4', '\x4', '\x5', '\t', '\x5', '\x4', '\x6', 
		'\t', '\x6', '\x4', '\a', '\t', '\a', '\x4', '\b', '\t', '\b', '\x3', 
		'\x2', '\a', '\x2', '\x12', '\n', '\x2', '\f', '\x2', '\xE', '\x2', '\x15', 
		'\v', '\x2', '\x3', '\x3', '\x3', '\x3', '\x3', '\x3', '\a', '\x3', '\x1A', 
		'\n', '\x3', '\f', '\x3', '\xE', '\x3', '\x1D', '\v', '\x3', '\x3', '\x3', 
		'\x3', '\x3', '\x3', '\x3', '\x3', '\x3', '\x3', '\x3', '\x3', '\x4', 
		'\x3', '\x4', '\x6', '\x4', '&', '\n', '\x4', '\r', '\x4', '\xE', '\x4', 
		'\'', '\x3', '\x4', '\x3', '\x4', '\x3', '\x4', '\x3', '\x4', '\x3', '\x5', 
		'\x3', '\x5', '\x3', '\x6', '\x3', '\x6', '\x5', '\x6', '\x32', '\n', 
		'\x6', '\x3', '\a', '\x3', '\a', '\x3', '\a', '\x3', '\a', '\x3', '\a', 
		'\x3', '\a', '\x3', '\a', '\x3', '\a', '\x3', '\a', '\x3', '\b', '\x3', 
		'\b', '\x3', '\b', '\x2', '\x2', '\t', '\x2', '\x4', '\x6', '\b', '\n', 
		'\f', '\xE', '\x2', '\x2', '\x2', ';', '\x2', '\x13', '\x3', '\x2', '\x2', 
		'\x2', '\x4', '\x16', '\x3', '\x2', '\x2', '\x2', '\x6', '#', '\x3', '\x2', 
		'\x2', '\x2', '\b', '-', '\x3', '\x2', '\x2', '\x2', '\n', '\x31', '\x3', 
		'\x2', '\x2', '\x2', '\f', '\x33', '\x3', '\x2', '\x2', '\x2', '\xE', 
		'<', '\x3', '\x2', '\x2', '\x2', '\x10', '\x12', '\x5', '\x4', '\x3', 
		'\x2', '\x11', '\x10', '\x3', '\x2', '\x2', '\x2', '\x12', '\x15', '\x3', 
		'\x2', '\x2', '\x2', '\x13', '\x11', '\x3', '\x2', '\x2', '\x2', '\x13', 
		'\x14', '\x3', '\x2', '\x2', '\x2', '\x14', '\x3', '\x3', '\x2', '\x2', 
		'\x2', '\x15', '\x13', '\x3', '\x2', '\x2', '\x2', '\x16', '\x17', '\a', 
		'\x3', '\x2', '\x2', '\x17', '\x1B', '\a', '\n', '\x2', '\x2', '\x18', 
		'\x1A', '\x5', '\x6', '\x4', '\x2', '\x19', '\x18', '\x3', '\x2', '\x2', 
		'\x2', '\x1A', '\x1D', '\x3', '\x2', '\x2', '\x2', '\x1B', '\x19', '\x3', 
		'\x2', '\x2', '\x2', '\x1B', '\x1C', '\x3', '\x2', '\x2', '\x2', '\x1C', 
		'\x1E', '\x3', '\x2', '\x2', '\x2', '\x1D', '\x1B', '\x3', '\x2', '\x2', 
		'\x2', '\x1E', '\x1F', '\a', '\x4', '\x2', '\x2', '\x1F', ' ', '\x5', 
		'\b', '\x5', '\x2', ' ', '!', '\a', '\x5', '\x2', '\x2', '!', '\"', '\x5', 
		'\n', '\x6', '\x2', '\"', '\x5', '\x3', '\x2', '\x2', '\x2', '#', '%', 
		'\a', '\x6', '\x2', '\x2', '$', '&', '\a', '\n', '\x2', '\x2', '%', '$', 
		'\x3', '\x2', '\x2', '\x2', '&', '\'', '\x3', '\x2', '\x2', '\x2', '\'', 
		'%', '\x3', '\x2', '\x2', '\x2', '\'', '(', '\x3', '\x2', '\x2', '\x2', 
		'(', ')', '\x3', '\x2', '\x2', '\x2', ')', '*', '\a', '\x4', '\x2', '\x2', 
		'*', '+', '\x5', '\b', '\x5', '\x2', '+', ',', '\a', '\a', '\x2', '\x2', 
		',', '\a', '\x3', '\x2', '\x2', '\x2', '-', '.', '\a', '\n', '\x2', '\x2', 
		'.', '\t', '\x3', '\x2', '\x2', '\x2', '/', '\x32', '\x5', '\f', '\a', 
		'\x2', '\x30', '\x32', '\x5', '\xE', '\b', '\x2', '\x31', '/', '\x3', 
		'\x2', '\x2', '\x2', '\x31', '\x30', '\x3', '\x2', '\x2', '\x2', '\x32', 
		'\v', '\x3', '\x2', '\x2', '\x2', '\x33', '\x34', '\a', '\b', '\x2', '\x2', 
		'\x34', '\x35', '\a', '\n', '\x2', '\x2', '\x35', '\x36', '\a', '\x4', 
		'\x2', '\x2', '\x36', '\x37', '\x5', '\b', '\x5', '\x2', '\x37', '\x38', 
		'\a', '\x5', '\x2', '\x2', '\x38', '\x39', '\x5', '\n', '\x6', '\x2', 
		'\x39', ':', '\a', '\t', '\x2', '\x2', ':', ';', '\x5', '\n', '\x6', '\x2', 
		';', '\r', '\x3', '\x2', '\x2', '\x2', '<', '=', '\a', '\n', '\x2', '\x2', 
		'=', '\xF', '\x3', '\x2', '\x2', '\x2', '\x6', '\x13', '\x1B', '\'', '\x31',
	};

	public static readonly ATN _ATN =
		new ATNDeserializer().Deserialize(_serializedATN);


}
