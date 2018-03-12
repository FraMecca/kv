module kv;

import std.json, std.file, std.stdio, std.getopt, std.conv, std.string, std.exception, std.algorithm;

alias writeText = std.file.write;
string incorrectUsage = "Usage: kv [filename] [OPTIONS]...\nTry 'kv --help' for more information.";

int main(string[] args)
{
	int retvalue;
	string filename, key, value, formatSpec;
	bool listB, delB;
	auto arguments = getopt(
    		args,
    		"k|key",  "display value of this key or update the key if --value is specified", &key,   
    		"v|value", "update or set a key in the database", &value,
    		"d|delete", "delete a key in the database", &delB,
    		"l|list", "list couples of key and values", &listB,
    		"f|format", "specify a format string; %k and %v are placeholders for key and value respectively", &formatSpec,
			);

  	if(arguments.helpWanted){
		  //printArgs();
		defaultGetoptPrinter("Usage: kv [filename] [OPTIONS]...\nKey Value storage for shell script\n", arguments.options);
		return 0;
  	}


  	if(args.length != 2){  		
  		stderr.writeln(incorrectUsage);
  		return 2;
  	}

  	filename = args[1];
  	if(!value && !filename.exists){
  		stderr.writeln("Database \"", filename, "\" not found.");
  		return 2;
  	}

  	scope(failure) { 
  		stderr.writeln("Error during execution, check exception message."); 
  		retvalue = 1;
  	}
  	if(!key && !listB){
  		// could be more complete instead of ignoring parameters that are not used
  		stderr.writeln(incorrectUsage);
  		return 2;
  	} else if(listB){
  		auto res = listKeys(filename);
  		printFormat(res, formatSpec);
	} else if(value){
		enforce!InvalidValueException(value.length > 0, "value is an empty line");
		addKey(filename, key, value);
  	} else if(delB){
  		deleteKey(filename, key);
	} else {
		auto res = getKey(filename, key);
		writeln(res.replace("\"", ""));
	}

  	return retvalue;
}

JSONValue getContent(string filename)
{
	string content = filename.readText;
	JSONValue j = parseJSON(content);
	enforce!NotJSONObjectException(j.type == JSON_TYPE.OBJECT, "Database content is not a valid JSON Object");
	return j;
}

JSONValue listKeys(string filename)
{
	auto j = getContent(filename);
	return j;
}

void addKey(string filename, string key, string value)
{
	JSONValue j;
	if(filename.exists) j = getContent(filename);
	j[key] = value;
	filename.writeText(j.toPrettyString);
}

string getKey(string filename, string key)
{
	auto j = getContent(filename);
	string v = to!string(j[key]).stripJSONDelimiters;
	return v;
}

void deleteKey(string filename, string key)
{
	auto old = getContent(filename);
	JSONValue j;
	foreach(string k, v; old){
		if(k != key) j[k] = v;
	}
	if(!j.isNull) filename.writeText(j.toPrettyString);
	else remove(filename);
}


string stripJSONDelimiters(string v)
{
	return v.replace("\"", "").replace("\\", "");
}

void printFormat(JSONValue j, string formatSpec)
{

	if(formatSpec == ""){
		// default:
		// k: v
		writeln(j.toString[1 .. $ -1].replace(":", ": ")
				.replace(",", "\n")
				.stripJSONDelimiters);
	} else if(formatSpec == "pretty"){
		writeln(j.toPrettyString);
	} else if(formatSpec == "raw"){
		writeln(j.toString);
	} else {
		enforce!FormatStringException(formatSpec.canFind("%k"), "No %k specifier in format string");
		enforce!FormatStringException(formatSpec.canFind("%v"), "No %v specifier in format string");
		foreach(string k, v; j){
			auto vs = to!string(v).stripJSONDelimiters;
			
			writeln(formatSpec
					.replace("%k", k.stripJSONDelimiters)
					.replace("%v", vs));
		}
	}
}

class NotJSONObjectException : Exception
{
    this(string msg, string file = __FILE__, size_t line = __LINE__) {
    	super(msg, file, line);
    }
}

class FormatStringException : Exception
{
    this(string msg, string file = __FILE__, size_t line = __LINE__) {
    	super(msg, file, line);
    }
}

class InvalidValueException : Exception
{
    this(string msg, string file = __FILE__, size_t line = __LINE__) {
    	super(msg, file, line);
    }
}
