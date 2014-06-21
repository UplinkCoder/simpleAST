module simpleAST;
import std.typetuple;
import std.typelist;
import std.typecons;
import std.uni;
// example

final string generateChildFields (T,childtypes ...)  ()
	if (is(T:ASTNode) && allSatisfy!(x => is(x : ASTNode),childtypes))
{
	string fieldDecls;
	string methodDecls;
	foreach(type;childtypes) {
		immutable string i = __traits(identifier,type);
		fieldDecls~=i~"[]  "~i.toLower~"s;\n";

		methodDecls ~= "void add ("~i~" _"~i.toLower~") {\n";
		methodDecls ~= i.toLower~"s ~=" "_"~i.toLower~";\n}\n"; 
	}
	return fieldDecls~"\n"~methodDecls;
}

interface addable(childtypes ...) if (allSatisfy!(T => is(T:ASTNode),childtypes)) {
	void add (T)(T child) ;
}

bool isChildless(T)(T t) {
	return isChildless!T;
}

static immutable string[] reserved_keywords = [ "module", "import"];
abstract class ASTNode
{
	ASTNode parent = null;
//	this (ASTNode parent = null) {
//		this.parent = parent;
//	}
	//abstract TypeTuple childTypes;
}
Nullable!T find (T) (Module m,string name) {
	foreach (c;m.childern)
		if (true) return T;
}

class AST {
	Module root;
}
class Module : ASTNode {
	mixin (generateChildFields!(Module,Function,Import,Call));
	//pragma(msg,generateChildFields!(Module,Function,Import));

	Identifier!Module name;
	this(string module_name) {
		name = new Identifier!Module(this,module_name);
	}
}
class Import : ASTNode {
	this(ASTNode parent,string module_name) {
		this.parent = parent; 
	}
}
class Variable : ASTNode {
	Type type;
	Identifier!Variable name;
	//Initializer = null;
}	
class Literal(T) if (is(T : string/*,Function,int,double*/)) : ASTNode {
	alias Type = T;
	T literal;
	this(ASTNode parent,T lit) {}
	//static if (is(typeof(parent) == Function ||  )
	//Token tok;
}
class Function : ASTNode {
	mixin (generateChildFields!(Function,Overload));
	this(ASTNode parent,string name,Type ret, Type[] params) {
		this.parent = parent;
		this.name = name;
		this.overloads ~= new Overload(this,ret,params);
	}
	string name;
	static class Overload {
		//mixin (generateChildFields!(Overload,Function,Struct,Class,Call));
		this (Function parent,Type returnType,Type[] params) {
			this.params = params;
			this.returnType = returnType;
			this.parent = parent;
		}
		Function parent;
		Type returnType;
		Type[] params;
	}
}
class Identifier(T) : ASTNode {
	alias Type = T;
	string value;
	this(ASTNode parent,string name) {
		value = name;
	}
	//Token tok;
}
class Call : ASTNode {
	this(ASTNode parent,Function f,Literal!string p) {
		this.parent = parent;
		this.func = f; 
		this.param = p;
	}
	Function func;
	Literal!string param; //ASTNode[] params;
}
Type bulitinType(T)() {
	static if (is(T==void))
		return new Type(null,"void");
}
class Type : ASTNode {
	this(ASTNode parent,string name,ASTNode def = null) {
		this.parent = parent;
		this.name = name;
		this.def = def;
	}
	string name;
	ASTNode def; 
}

// alias Parameter = TypeTuple!(Literal,Variable)     
struct Token {
	ASTNode belongsTo = null;
	//	TranslationUnit from;
	char* start;
	uint length;
//	@property string rep() {
//		return cast(char[0 .. length]) start;
//	}
}

void main() {
import std.stdio;
auto ast = new AST();
auto mod = new Module("example");

	auto impo = new Import(mod,"std.stdio");
	mod.add(impo);
	// we should recursivly add ModuleSymbols here
	Function f_writeln /*= find!Function(root,"writeln")*/;
	auto call = new Call(mod,f_writeln,new Literal!string (mod,"Hello World"));
	//mod.add(mod,f_writeln,new Literal!string ("Hello World"));
	// consider AST.root.add!Call!f_writeln(new Lieral!string ("Hello World");
	Type t_string /*= find!Type(root,"string")*/;
	
		Function ghw = new Function(mod,"getHelloWorld",t_string,[bulitinType!void]);
	//	ghw._body = new Body!Function(ghw);
	//	ghw._body.add!
	
	
	//		ast.root.add!Function(new Function("getHelloWorld",t_string,[t_void],
	//		new Body!Function(new Variable(
	//			"hw",t_string,new Literal!string())
	//		                  ));
}
	string example = `
	module example // module declaration // "module" $module_name;
	import std.stdio; // import Statement // "import" $module_name;
	writeln(  // (free) function call // $function_name optional '(' optional $params[] ')'';'
		"Hello World" // string literal // '"' $value oftype (string) '"'
	); 
	is roughly equivalent to
	string getHelloWorld() // function Definition // $return_type $function_name '(' optional ($param_type $para_name)[] ')' '{' $function_body '}'  
	{
		string hw = "Hello World"; // variable declaration + variable assignment // ($type_name || "auto") $variable_name ($value oftype($type_name))
		return hw; // return statement // "return (optional value || '(' value ')' oftype(RetunType)); 
	} 
	`;