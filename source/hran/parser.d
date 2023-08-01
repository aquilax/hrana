module hran.parser;

import std.algorithm;
import std.conv;
import std.stdio;
import std.string;

import hran.meta;

enum CommentChar = '#';

struct ParsedItem
{
	string name;
	float value;
}

struct ParsedNode
{
	string header;
	ParsedItem[] items;
	MetaPair[] meta;
}

void parseFileName(string fileName, bool delegate(ParsedNode pn) callback) {
	File file = File(fileName, "r");
	parseFile(file, callback);
	file.close();
}

void parseFile(File file, bool delegate(ParsedNode pn) callback) {
	auto lineNumber = 0;
	ParsedNode node = ParsedNode();

	while (!file.eof()) {
		lineNumber++;
		string line = file.readln();
		string trimmedLine = line.strip();
		if (trimmedLine == "" || line[0] == CommentChar) {
			continue;
		}

		if (line[0] != ' ' && line[0] != '\t' && line[0] != '-') {
			if (node.header != "") {
				// flush complete node
				bool stop = callback(node);
				if (stop) return;
			}
			node = ParsedNode(trimmedLine.stripRight(": \t"));
			continue;
		}

		if (node.header != "") {
			if (trimmedLine[0] == CommentChar) {
				// Metadata
				node.meta ~= getMetadataPair(trimmedLine);
				continue;
			}
			auto separatorPos = lastIndexOfAny(trimmedLine, "\t ");
			if (separatorPos == -1) {
				throw new InvalidItemException("invalid item row", lineNumber);
			}
			string title = trimmedLine[0..separatorPos].stripRight(": \t");

			//get element value
			string sQty = trimmedLine[separatorPos..$].strip;
			float fQty = parse!float(sQty);
			node.items ~= ParsedItem(title, fQty);
		}
	}
	// push last node
	if (node.header != "") {
		callback(node);
	}
}

MetaPair getMetadataPair(string line)
{
	auto trimmedLine = line.stripLeft("# \t");
	auto separatorPos = indexOf(trimmedLine, ":");
	if (separatorPos > -1) {
		return MetaPair(
			trimmedLine[0..separatorPos],
			trimmedLine[separatorPos+1..$].strip
		);
	}
	return MetaPair("", trimmedLine);
}


class InvalidItemException : Exception
{
	int lineNumber;

    this(string msg, int lineNumber, string file = __FILE__, size_t line = __LINE__) {
        super(msg,  file, line);
		this.lineNumber = lineNumber;
    }
}
