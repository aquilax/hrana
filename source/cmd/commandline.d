module cmd.commandline;

import cmd.commands.reg;
import cmd.config;
import std.datetime.date : DateTime;
import std.stdio;

import commandr;

import hran.database;
import hran.journal;
import hran.meta;

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
