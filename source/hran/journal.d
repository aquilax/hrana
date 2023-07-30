module hran.journal;

import std.datetime.date : DateTime;
import hran.meta;
import hran.database;
import std.algorithm;
import std.array;
import hran.utils;

struct Item
{
	string name;
	float value;
}

struct Day
{
	DateTime dateTime;
	Item[] items;
	MetaPair[] meta;
}


Day resolveDay(Record[] db, Day day)
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
		dateTime: day.dateTime,
		meta: day.meta,
		items: reduceItems(i),
	};
	return d;
}
