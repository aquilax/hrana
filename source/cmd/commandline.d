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
		.add(new Option("d", null, "database file path").name("database"))
		.add(new Option("l", null, "journal file path").name("log"))

		.add(new Command("reg"))
		.parse(args);

	a.on("reg", (args) {
		writeln();
		auto config = configFromArgs(args);
		commandReg(config);
	});

	return 0;
}

auto configFromArgs(ProgramArgs args)
{
	Config c = {
		databaseFileName: args.option("database"),
		journalFileName: args.option("log"),
	};
	return c;
}
