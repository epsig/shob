#pragma once

namespace shob::main::test
{
	class TestCommandLine
	{
	public:
		static void testNoArgsKeepsDefaults();
		static void testOneYear();
		static void testTwoYears();
		static void testWithKlaverjasFlag();
		static void testInvalidOneArg();
		static void testInvalidTwoArgs();
	};
}
