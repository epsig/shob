#include <gtest/gtest.h>

#include "TestFootballCompetition.h"
#include "TestResultsToStandings.h"
#include "TestTopscorers.h"
#include "TestFilterResults.h"
#include "TestFilterInput.h"

using namespace shob::football::test;

int main(int argc, char** argv)
{
    ::testing::InitGoogleTest(&argc, argv);
    //::testing::GTEST_FLAG(filter) = "unitTest.testSortOnResultsOpponents2Matches";
    return RUN_ALL_TESTS();
}

TEST(unitTest, TestResultsToStandings)
{
    TestResultsToStandings::test1();
}

TEST(unitTest, testResults2standingsWithTeams)
{
    TestResultsToStandings::test2();
}

TEST(unitTest, testResults2standingsWithExtras)
{
    TestResultsToStandings::test3();
}

TEST(unitTest, testResults2standingsWithMutualResults)
{
    TestResultsToStandings::testMutualResults();
}

TEST(unitTest, testSortOnResultsOpponents)
{
    TestResultsToStandings::testSortOnResultsOpponents();
}

TEST(unitTest, testSortOnResultsOpponents2Matches)
{
    TestResultsToStandings::testSortOnResultsOpponent2Matches();
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


