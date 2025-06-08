
#include <gtest/gtest.h>

#include "testDate.h"
#include "testUniqueStrings.h"

using namespace shob::general::test;

int main(int argc, char** argv)
{
    ::testing::InitGoogleTest(&argc, argv);
    //::testing::GTEST_FLAG(filter) = "unitTest.testDate1";
    return RUN_ALL_TESTS();
}

TEST(unitTest, testItdateToString)
{
    testDate::testItdateToString();
}

TEST(unitTest, testErrorHandling)
{
    testDate::testErrorHandling();
}

TEST(unitTest, testErrorHandlingMaxDays)
{
    testDate::testErrorHandlingMaxDays();
}

TEST(unitTest, testLeapYear)
{
    testDate::testIsLeapYear();
}

TEST(unitTest, testMaxDaysPerMonth)
{
    testDate::testMaxDays();
}

TEST(unitTest, testUniqueStrings)
{
    testUniqueStrings::test1();
}

