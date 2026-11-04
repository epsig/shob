
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
    //::testing::GTEST_FLAG(filter) = "unitTest.testSortOnResultsOpponents2Matches";
    return RUN_ALL_TESTS();
}

TEST(unitTest, TestResults2standings)
{
    TestResults2standings::test1();
}

TEST(unitTest, testResults2standingsWithTeams)
{
    TestResults2standings::test2();
}

TEST(unitTest, testResults2standingsWithExtras)
{
    TestResults2standings::test3();
}

TEST(unitTest, testResults2standingsWithMutualResults)
{
    TestResults2standings::testMutualResults();
}

TEST(unitTest, testSortOnResultsOpponents)
{
    TestResults2standings::testSortOnResultsOpponents();
}

TEST(unitTest, testSortOnResultsOpponents2Matches)
{
    TestResults2standings::testSortOnResultsOpponent2Matches();
}

TEST(unitTest, TestFootballCompetition)
{
    TestFootballCompetition::test1();
}

TEST(unitTest, testStrafPoints)
{
    TestFootballCompetition::testStrafPoints();
}

TEST(unitTest, testFiltered)
{
    TestFootballCompetition::testFiltered();
}

TEST(unitTest, testPrepareTable)
{
    TestFootballCompetition::testPrepareTable();
}

TEST(unitTest, testTopScorers)
{
    TestTopscorers::test1();
}

TEST(unitTest, TestFilterResults)
{
    TestFilterResults::testFilterWithRoute2Finale();
}

TEST(unitTest, testGetReturns)
{
    TestFilterResults::testGetReturns();
}

TEST(unitTest, testFilterEuropacup)
{
    TestFilterResults::testFilterEuropacup();
}

TEST(unitTest, testFilterInput1)
{
    TestFilterInput::test1();
}

TEST(unitTest, testFilterInput2)
{
    TestFilterInput::test2();
}

TEST(unitTest, testFilterInput3)
{
    TestFilterInput::test3();
}

TEST(unitTest, testFilterInput4)
{
    TestFilterInput::test4();
}


