module hran.database;

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
            return resolveRecord(db[index], db, depth-1).ingredients
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
    float* p;

    foreach (i; input)
    {
        p = i.name in floatSum;
        if (p is null)
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