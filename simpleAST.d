module simpleAST;
import std.typetuple;
// example

static immutable string[] reserved_keywords = [ "module", "import"];
abstract class ASTNode
{
	ASTNode parent = null;
	this (ASTNode parent = null) {
		this.parent = parent;
	}
	//abstract TypeTuple childTypes;
	void add(ASTNode child) {
		//	static if (child)
	}
}

class AST {
	Module root;
}
class Module : ASTNode {
	Identifier!Module name;
	ASTNode[] childern;
	this(string module_name) {
		name = new module_name;
	}
}
class Import : ASTNode {
	this(ASTNode parent,Literal!string module_name) {
		
	}
}
class Variable : ASTNode {
	Type type;
	Identifier!Variable name;
	//Initializer = null;
}	
class Literal(T) if (is(T : string/*,Function,int,double*/)) : ASTNode {
	alias Type = T;
	this(ASTNode parent,T lit) {}
	//static if (is(typeof(parent) == Function ||  )
	Token tok;
}
class Function : ASTNode {
	Identifier!Function name;
	Overload[] overloads;
	class Overload {
		Type returnType;
		Type[] params;
	}
	
}
class Identifier(T) : ASTNode {
	alias Type = T;
	Token tok;
}
class Call : ASTNode {
	
	Identifier!Function func;
	Literal!string param; //ASTNode[] params;
}
class Type : ASTNode {
	Identifier!Type name; 
	ASTNode def; 
}

// alias Parameter = TypeTuple!(Literal,Variable)     
struct Token {
	ASTNode belongsTo = null;
	//	TranslationUnit from;
	char* start;
	uint length;
	@property string rep() {
		return cast(char[0 .. length]) start;
	}
	//auto ast = new AST();
	auto mod = new Module("example");
	//	ast.root.add!Import(new Import(root,"std.stdio"));
	// we should recursivly add ModuleSymbols here
	Function f_writeln = find!Function(root,"writeln");
	//		ast.root.add!Call!Function(root,f_writeln,new Literal!string ("Hello World"));
	// consider AST.root.add!Call!f_writeln(new Lieral!string ("Hello World");
	Type t_string = search!Type(root,"string");
	
	//	Function ghw = new Function(root,"getHelloWorld",t_string,[Type!void]);
	//	ghw._body = new Body!Function(ghw);
	//	ghw._body.add!
	
	
	//		ast.root.add!Function(new Function("getHelloWorld",t_string,[t_void],
	//		new Body!Function(new Variable(
	//			"hw",t_string,new Literal!string())
	//		                  ));
	
	//string example = `
	//module example // module declaration // "module" $module_name;
	//import std.stdio; // import Statement // "import" $module_name;
	//writeln(  // (free) function call // $function_name optional '(' optional $params[] ')'';'
	//	"Hello World" // string literal // '"' $value oftype (string) '"'
	//); 
	//is roughly equivalent to
	//string getHelloWorld() // function Definition // $return_type $function_name '(' optional ($param_type $para_name)[] ')' '{' $function_body '}'  
	//{
	//	string hw = "Hello World"; // variable declaration + variable assignment // ($type_name || "auto") $variable_name ($value oftype($type_name))
	//	return hw; // return statement // "return (optional value || '(' value ')' oftype(RetunType)); 
	//} 
	//`;