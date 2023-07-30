module hran.journal;

import std.datetime.date : DateTime;
import hran.meta;

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
