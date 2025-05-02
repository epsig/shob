
#include <gtest/gtest.h>

#include "testFootballCompetition.h"
#include "testResults2standings.h"

using namespace shob::football::test;

int main(int argc, char** argv)
{
    ::testing::InitGoogleTest(&argc, argv);
    //::testing::GTEST_FLAG(filter) = "unitTest.testStrafPoints";
    return RUN_ALL_TESTS();
}

TEST(unitTest, testFootballCompetition)
{
    testFootballCompetition::test1();
}

TEST(unitTest, testResults2standings)
{
    testResults2standings::test1();
}

TEST(unitTest, testResults2standingsWithTeams)
{
    testResults2standings::test2();
}

TEST(unitTest, testResults2standingsWithExtras)
{
    testResults2standings::test3();
}

TEST(unitTest, testStrafPoints)
{
    testFootballCompetition::testStrafPoints();
}

