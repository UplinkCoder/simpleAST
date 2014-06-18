module simpleAST;

// example

static immutable string[] reserved_keywords = [ "module", "import"];
abstract class ASTNode //(parentType)
	//if (is(parentType : ASTNode) 
{
	ASTNode parent = void;
	this (ASTNode parent) {
		this.parent = parent;
	} 
}

class AST {
	Module root;
}
class Module : ASTNode {
	Identifier name;
	ASTNode[] childern;
}
class Import : ASTNode {
	this(ASTNode parent,Literal) {
		
	}
}
class Variable : ASTNode {
	Type type;
	Identifier/*!Variable*/ name;
	//Initializer = null;
}	
class Literal(T) if (is(T == string||Function||int||double)) : ASTNode {
	alias Type = T;
	this(ASTNode parent,Token t) {
		//static if (is(typeof(parent) == Function ||  )
	static enum LitType {function_literal,string_literal,integer_literal};
	Token t;
}
class Function : ASTNode {
	Identifier!Function name;
	Overload[] overloads;
	class Overload {
		Type returnType;
		Type[] params;
	}
	
}
class Identifier/*(PT)*/ : ASTNode {
	IdentType type;
	static enum IdentType {module_name,function_name,variable_name};
	Token tok;
}
class Call : ASTNode {
	CallType type;
	static enum CallType {function_call};
	Indentifier/*!Function*/ function;
	Literal param; //ASTNode[] params;
}
class Type : ASTNode {
	Identifier!Type name; 
	ASTNode def; 
}

// alias Parameter = TypeTuple!(Literal,Variable)     
struct Token {
	ASTNode belongsTo = null;
	TranslationUnit from;
	uint start;
	uint length;
}
ast = new AST();
ast.root = new Module("example");
ast.root.add!Import(new Import(root,"std.stdio"));
	// we should recursivly add ModuleSymbols here
Function f_writeln = find!Function(root,"writeln") 
ast.root.add!Call!Function(root,f_writeln,new Literal!string ("Hello World"));
// consider AST.root.add!Call!f_writeln(new Lieral!string ("Hello World");
Type t_string = search!Type(root,"string");

Function ghw = new Function(root,"getHelloWorld",t_string,[void]);
ghw.body = new Body!Function(ghw);
ghw.body.add!


ast.root.add!Function(new Function("getHelloWorld",t_string,[t_void],
	new Body!Function(new Variable(
		"hw",t_string,new Literal!string())
));

string example = `
module example // module declaration // "module" $module_name;
import std.stdio; // import Statement // "import" $module_name;
writeln(  // (free) function call // $function_name optional '(' optional $params[] ')'';'
	"Hello World" // string literal // '"' $value oftype (string) '"'
); 
//is roughly equivalent to
string getHelloWorld() // function Definition // $return_type $function_name '(' optional ($param_type $para_name)[] ')' '{' $function_body '}'  
{
	string hw = "Hello World"; // variable declaration + variable assignment // ($type_name || "auto") $variable_name ($value oftype($type_name))
	return hw; // return statement // "return (optional value || '(' value ')' oftype(RetunType)); 
}`

