module hran.journal;

import std.algorithm;
import std.array;
import std.datetime.date : Date;

import hran.database;
import hran.meta;
import hran.utils;

struct Item
{
	string name;
	float value;
}

struct Day
{
	Date date;
	Item[] items;
	MetaPair[] meta;
}

Day resolveDay(Record[] db, Day day) pure nothrow
{
	auto getItems = (Item i)
	{
			auto index = db.countUntil!(rc => rc.name == i.name);
			if (index == -1) {
				return [i];
			}
			return db[index].ingredients.map!(ing => Item(ing.name, ing.value * i.value)).array;
	};

	auto i = joiner(day.items.map!(getItems)).array;

	Day d = {
		date: day.date,
		meta: day.meta,
		items: reduceItems(i),
	};
	return d;
}
