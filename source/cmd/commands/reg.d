module cmd.commands.reg;

import cmd.config;
import hran.journal;
import hran.database;
import hran.meta;
import std.stdio;
import std.datetime;


int commandReg(Config c)
{
	auto db = getDb();
	auto rdb = resolveDatabase(db);
	auto journal = getJournal();
	foreach (day; journal)
	{
		auto rday = resolveDay(rdb, day);
		printDay(rday);
	}
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

auto getDb()
{
	Record[] db = [
		{
			name: "soup/potato/100g",
			ingredients: [
				Ingredient("soup/potato/meal", 0.01),
			],
			meta: [],
		},
		{
			name: "soup/potato/meal",
			ingredients: [
				Ingredient("vegetables/potato/100g", 3),
				Ingredient("oil/sunflower/100g", 0.30),
			],
			meta: [],
		},
		{
			name: "vegetables/potato/100g",
			ingredients: [
				Ingredient("kcal", 77),
				Ingredient("fat", 0.1),
				Ingredient("carbs", 17),
				Ingredient("protein", 2),
			],
			meta: [MetaPair("version", "v1")]
		}
	];
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
