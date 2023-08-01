module hran.utils;

import std.array;
import std.conv;
import std.datetime.date : Date;
import std.format;
import std.stdio;

T[] reduceItems(T)(T[] input) pure nothrow
{
	string[] names;
	float[string] floatSum;

	foreach (i; input)
	{
		if ((i.name in floatSum) is null)
		{
			floatSum[i.name] = i.value;
			names ~= i.name;
		}
		else
			floatSum[i.name] += i.value;
	}

	T[] result;
	foreach (name; names)
	{
		result ~= T(name, floatSum[name]);
	}

	return result;
}

Date parseDate(string date)
{
	auto segments = date.split("/");
	if (segments.length < 3) {
		segments = date.split("-");
	}
	return Date(parse!int(segments[0]), parse!int(segments[1]), parse!int(segments[2]));
}

string formatDate(Date date)
{
	return format("%04d/%02d/%02d", date.year, date.month, date.day);
}
