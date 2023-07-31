module hran.parser;

import std.stdio;
import std.string;
import hran.meta;
import std.algorithm;
import std.conv;

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
				// // Metadata
				// mp, _ = getMetadataPair(trimmedLine)
				// if mp != nil {
				// 	if node.Metadata == nil {
				// 		node.Metadata = &shared.Metadata{*mp}
				// 	} else {
				// 		*node.Metadata = append(*node.Metadata, *mp)
				// 	}
				// }
				continue;
			}
			auto separatorPos = lastIndexOfAny(trimmedLine, "\t ");
			if (separatorPos == -1) {
				// if stop, err := callback(nil, NewErrorBadSyntax(lineNumber, line)); stop {
				// 	return err
				// }
				continue;
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
