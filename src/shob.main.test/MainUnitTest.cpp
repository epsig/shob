#include <gtest/gtest.h>

#include "TestCommandLine.h"

using namespace shob::main::test;

int main(int argc, char** argv)
{
    ::testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();
}

TEST(UnitTest, testCommandLineNoArgs)
{
    TestCommandLine::testNoArgsKeepsDefaults();
}

TEST(UnitTest, testCommandLineOneYear)
{
    TestCommandLine::testOneYear();
}

TEST(UnitTest, testCommandLineTwoYears)
{
    TestCommandLine::testTwoYears();
}

TEST(UnitTest, testCommandLineWithKlaverjasFlag)
{
    TestCommandLine::testWithKlaverjasFlag();
}

TEST(UnitTest, testCommandLineInvalidOneArg)
{
    TestCommandLine::testInvalidOneArg();
}

TEST(UnitTest, testCommandLineInvalidTwoArgs)
{
    TestCommandLine::testInvalidTwoArgs();
}
