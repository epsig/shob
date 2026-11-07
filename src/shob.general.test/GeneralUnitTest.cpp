#include <gtest/gtest.h>

#include "TestDate.h"
#include "TestUniqueStrings.h"
#include "TestGlob.h"
#include "TestSeason.h"

using namespace shob::general::test;

int main(int argc, char** argv)
{
    ::testing::InitGoogleTest(&argc, argv);
    //::testing::GTEST_FLAG(filter) = "unitTest.testDate1";
    return RUN_ALL_TESTS();
}

TEST(unitTest, testItdateToString)
{
    TestDate::testItdateToString();
}

TEST(unitTest, testErrorHandling)
{
    TestDate::testErrorHandling();
}

TEST(unitTest, testErrorHandlingMaxDays)
{
    TestDate::testErrorHandlingMaxDays();
}

TEST(unitTest, testLeapYear)
{
    TestDate::testIsLeapYear();
}

TEST(unitTest, testMaxDaysPerMonth)
{
    TestDate::testMaxDays();
}

TEST(unitTest, TestUniqueStrings)
{
    TestUniqueStrings::test1();
}

TEST(unitTest, TestGlob)
{
    TestGlob::test1();
}

TEST(unitTest, testSeason1)
{
    TestSeason::test1();
}

TEST(unitTest, testSeason2)
{
    TestSeason::test2();
}

