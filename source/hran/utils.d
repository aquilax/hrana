module hran.utils;

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
