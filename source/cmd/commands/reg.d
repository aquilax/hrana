module cmd.commands.reg;

import cmd.config;
import hran.journal;
import hran.database;
import hran.meta;
import hran.parser;
import std.stdio;
import std.datetime;
import std.algorithm;
import std.array;


int commandReg(Config c)
{
	auto db = getDb("./examples/food.yaml");
	auto rdb = resolveDatabase(db);
	string journalFileName = "./examples/log.yaml";
	//auto journal = getJournal(, );
	parseFileName(journalFileName, (ParsedNode pn) {
		Day day = {
			date: Date(2018, 1, 1),
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
	writefln("%s:",  d.date.toISOExtString);
	foreach(item; d.items)
	{
		writefln("\t%s: %.2f", item.name, item.value);
	}
	writeln("");
}

auto getDb(string fileName)
{
	Record[] db;
	// auto collector = ;
	parseFileName(fileName, (ParsedNode pn) {
		db ~= Record(pn.header, pn.items.map!(pni=>Ingredient(pni.name, pni.value)).array, pn.meta);
		return false;
	});
	// Record[] db = [
	// 	{
	// 		name: "soup/potato/100g",
	// 		ingredients: [
	// 			Ingredient("soup/potato/meal", 0.01),
	// 		],
	// 		meta: [],
	// 	},
	// 	{
	// 		name: "soup/potato/meal",
	// 		ingredients: [
	// 			Ingredient("vegetables/potato/100g", 3),
	// 			Ingredient("oil/sunflower/100g", 0.30),
	// 		],
	// 		meta: [],
	// 	},
	// 	{
	// 		name: "vegetables/potato/100g",
	// 		ingredients: [
	// 			Ingredient("kcal", 77),
	// 			Ingredient("fat", 0.1),
	// 			Ingredient("carbs", 17),
	// 			Ingredient("protein", 2),
	// 		],
	// 		meta: [MetaPair("version", "v1")]
	// 	}
	// ];
	return db;
}

auto getJournal()
{
	Day[] journal = [
		{
			date: Date(2018, 1, 1),
			items: [Item("vegetables/potato/100g", 2.00)],
			meta: [MetaPair("version", "v1")]
		}
	];
	return journal;
}
