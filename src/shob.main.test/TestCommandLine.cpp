#include "TestCommandLine.h"

#include <array>
#include <gtest/gtest.h>

#include "../shob.main/CommandLine.h"
#include "../shob.general/ShobException.h"

namespace shob::main::test
{
    void TestCommandLine::testNoArgsKeepsDefaults()
    {
        int yr1 = 1993;
        int yr2 = 2026;
        bool skip_kj = true;

        std::array<char, 5> arg0 = { 's', 'h', 'o', 'b', '\0' };
        char* argv[] = { arg0.data() };

        CommandLine::readCommandLine(1, argv, yr1, yr2, skip_kj);

        EXPECT_EQ(yr1, 1993);
        EXPECT_EQ(yr2, 2026);
        EXPECT_TRUE(skip_kj);
    }

    void TestCommandLine::testOneYear()
    {
        int yr1 = 1993;
        int yr2 = 2026;
        bool skip_kj = true;

        std::array<char, 5> arg0 = { 's', 'h', 'o', 'b', '\0' };
        std::array<char, 5> arg1 = { '2', '0', '2', '4', '\0' };
        char* argv[] = { arg0.data(), arg1.data() };

        CommandLine::readCommandLine(2, argv, yr1, yr2, skip_kj);

        EXPECT_EQ(yr1, 2024);
        EXPECT_EQ(yr2, 2024);
        EXPECT_TRUE(skip_kj);
    }

    void TestCommandLine::testTwoYears()
    {
        int yr1 = 1993;
        int yr2 = 2026;
        bool skip_kj = true;

        std::array<char, 5> arg0 = { 's', 'h', 'o', 'b', '\0' };
        std::array<char, 5> arg1 = { '2', '0', '2', '0', '\0' };
        std::array<char, 5> arg2 = { '2', '0', '2', '5', '\0' };
        char* argv[] = { arg0.data(), arg1.data(), arg2.data() };

        CommandLine::readCommandLine(3, argv, yr1, yr2, skip_kj);

        EXPECT_EQ(yr1, 2020);
        EXPECT_EQ(yr2, 2025);
        EXPECT_TRUE(skip_kj);
    }

    void TestCommandLine::testWithKlaverjasFlag()
    {
        int yr1 = 1993;
        int yr2 = 2026;
        bool skip_kj = true;

        std::array<char, 5> arg0 = { 's', 'h', 'o', 'b', '\0' };
        std::array<char, 5> arg1 = { '2', '0', '2', '0', '\0' };
        std::array<char, 5> arg2 = { '2', '0', '2', '5', '\0' };
        std::array<char, 8> arg3 = { 'w', 'i', 't', 'h', '_', 'k', 'j', '\0' };
        char* argv[] = { arg0.data(), arg1.data(), arg2.data(), arg3.data() };

        CommandLine::readCommandLine(4, argv, yr1, yr2, skip_kj);

        EXPECT_EQ(yr1, 2020);
        EXPECT_EQ(yr2, 2025);
        EXPECT_FALSE(skip_kj);
    }

    void TestCommandLine::testInvalidOneArg()
    {
        int yr1 = 1993;
        int yr2 = 2026;
        bool skip_kj = true;

        std::array<char, 5> arg0 = { 's', 'h', 'o', 'b', '\0' };
        std::array<char, 4> arg1 = { 'a', 'b', 'c', '\0' };
        char* argv[] = { arg0.data(), arg1.data() };

        try
        {
            CommandLine::readCommandLine(2, argv, yr1, yr2, skip_kj);
            FAIL() << "Expected ShobException";
        }
        catch (const shob::general::ShobException& e)
        {
            EXPECT_STREQ(e.what(), "first command line argument must be a year");
        }
    }

    void TestCommandLine::testInvalidTwoArgs()
    {
        int yr1 = 1993;
        int yr2 = 2026;
        bool skip_kj = true;

        std::array<char, 5> arg0 = { 's', 'h', 'o', 'b', '\0' };
        std::array<char, 5> arg1 = { '2', '0', '2', '4', '\0' };
        std::array<char, 4> arg2 = { 'x', 'x', 'x', '\0' };
        char* argv[] = { arg0.data(), arg1.data(), arg2.data() };

        try
        {
            CommandLine::readCommandLine(3, argv, yr1, yr2, skip_kj);
            FAIL() << "Expected ShobException";
        }
        catch (const shob::general::ShobException& e)
        {
            EXPECT_STREQ(e.what(), "first two command line arguments must be years");
        }
    }
}
