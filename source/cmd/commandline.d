module cmd.commandline;

import std.stdio;
import hran.journal;
import hran.database;
import hran.meta;
import std.datetime.date : DateTime;
import commandr;
import cmd.config;
import cmd.commands.reg;

int runCommandLine(string[] args)
{
	auto a = new Program("hran", "1.0")
		.summary("A command line tool to keep log of diet and exercise in text files")
		.author("aquilax aquilax@gmail.com>")
		.add(new Command("reg"))
		.parse(args);

	a.on("reg", (args) {
		auto config = configFromArgs(args);
		commandReg(config);
	});

	return 0;
}

auto configFromArgs(ProgramArgs args)
{
	return Config();
}
