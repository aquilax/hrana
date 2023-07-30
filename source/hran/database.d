module hran.database;

import std.functional;
import std.stdio;
import std.algorithm;
import std.array;
import std.range;
import hran.meta;

enum MaxDepth = 10;

struct Ingredient
{
	string name;
	float value;
}

struct Record
{
	string name;
	Ingredient[] ingredients;
	MetaPair[] meta;
}

Record[] resolveDatabase(Record[] db)
{
	return map!(r => resolveRecord(r, db, MaxDepth))(db).array;
}

Record resolveRecord(Record r, Record[] db,  int depth) {
	if (depth == 0) {
		return r;
	}

	auto getIngredients = (Ingredient i)
	{
			auto index = db.countUntil!(rc => rc.name == i.name);
			if (index == -1) {
				return [i];
			}
			return memoize!resolveRecord(db[index], db, depth-1).ingredients
				.map!(fi=> Ingredient(fi.name, fi.value * i.value)).array;
	};

	auto i = joiner(r.ingredients.map!(getIngredients)).array;

	Record ret = {
		name: r.name,
		meta: r.meta,
		ingredients: reduceIngredients(i)
	};
	return ret;
}

Ingredient[] reduceIngredients(Ingredient[] input)
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

	Ingredient[] result;
	foreach (name; names)
	{
		result ~= Ingredient(name, floatSum[name]);
	}

	return result;
}

///
unittest {
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

	Record[] expected = [
		{
			name: "soup/potato/100g",
			ingredients: [
				Ingredient("kcal", 2.31),
				Ingredient("fat", 0.003),
				Ingredient("carbs", 0.51),
				Ingredient("protein", 0.06),
				Ingredient("oil/sunflower/100g", 0.003)
			],
			meta: [],
		},
		{
			name: "soup/potato/meal",
			ingredients: [
				Ingredient("kcal", 231),
				Ingredient("fat", 0.3),
				Ingredient("carbs", 51),
				Ingredient("protein", 6),
				Ingredient("oil/sunflower/100g", 0.3)],
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

	assert(resolveDatabase(db) == expected);
}
