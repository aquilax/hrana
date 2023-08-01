module cmd.commands.reg;

import cmd.config;
import std.algorithm;
import std.array;
import std.datetime;
import std.stdio;

import hran.database;
import hran.journal;
import hran.meta;
import hran.parser;
import hran.utils;

int commandReg(Config c)
{
	auto db = getDb(c.databaseFileName);
	auto rdb = resolveDatabase(db);
	parseFileName(c.journalFileName, (ParsedNode pn) {
		Day day = {
			date: parseDate(pn.header),
			items: pn.items.map!(pni => Item(pni.name, pni.value)).array,
			meta: pn.meta,
		};
		auto rday = resolveDay(rdb, day);
		printDay(rday);
		return false;
	});
	return 0;
}

void printDay(Day d)
{
	writefln("%s:",  formatDate(d.date));
	foreach(item; d.items)
	{
		writefln("\t%s: %.2f", item.name, item.value);
	}
	writeln("");
}

auto getDb(string fileName)
{
	Record[] db;
	parseFileName(fileName, (ParsedNode pn) {
		db ~= Record(pn.header, pn.items.map!(pni=>Ingredient(pni.name, pni.value)).array, pn.meta);
		return false;
	});
	return db;
}
