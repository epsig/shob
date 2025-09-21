
#include <gtest/gtest.h>

#include "testFootballCompetition.h"
#include "testResults2standings.h"
#include "testTopscorers.h"
#include "testFilterResults.h"
#include "testFilterInput.h"

using namespace shob::football::test;

int main(int argc, char** argv)
{
    ::testing::InitGoogleTest(&argc, argv);
    //::testing::GTEST_FLAG(filter) = "unitTest.testStrafPoints";
    return RUN_ALL_TESTS();
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

TEST(unitTest, testResults2standingsWithMutualResults)
{
    testResults2standings::testMutualResults();
}

TEST(unitTest, testFootballCompetition)
{
    testFootballCompetition::test1();
}

TEST(unitTest, testStrafPoints)
{
    testFootballCompetition::testStrafPoints();
}

TEST(unitTest, testFiltered)
{
    testFootballCompetition::testFiltered();
}

TEST(unitTest, testPrepareTable)
{
    testFootballCompetition::testPrepareTable();
}

TEST(unitTest, testTopScorers)
{
    testTopscorers::test1();
}

TEST(unitTest, testFilterResults)
{
    testFilterResults::testFilterWithRoute2Finale();
}

TEST(unitTest, testGetReturns)
{
    testFilterResults::testGetReturns();
}

TEST(unitTest, testFilterEuropacup)
{
    testFilterResults::testFilterEuropacup();
}

TEST(unitTest, testFilterInput1)
{
    testFilterInput::test1();
}

TEST(unitTest, testFilterInput2)
{
    testFilterInput::test2();
}

TEST(unitTest, testFilterInput3)
{
    testFilterInput::test3();
}

TEST(unitTest, testFilterInput4)
{
    testFilterInput::test4();
}


