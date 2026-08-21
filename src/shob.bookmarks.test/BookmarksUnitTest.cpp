#include <gtest/gtest.h>
#include "TestCurrentEvents.h"
#include "TestOwnSportPages.h"

using namespace shob::bookmarks::test;

int main(int argc, char** argv)
{
    ::testing::InitGoogleTest(&argc, argv);
    //::testing::GTEST_FLAG(filter) = "unitTest.testCurrentEvents1";
    return RUN_ALL_TESTS();
}

TEST(unitTest, testCurrentEvents1)
{
    TestCurrentEvent::test1();
}

TEST(unitTest, testOwnSportPages1)
{
    TestOwnSportPages::test1();
}

TEST(unitTest, testOwnSportPages2)
{
    TestOwnSportPages::test2();
}

TEST(unitTest, testOwnSportPages3)
{
    TestOwnSportPages::test3();
}

TEST(unitTest, testOwnSportPages4)
{
    TestOwnSportPages::test4();
}

TEST(unitTest, testOwnSportPages5)
{
    TestOwnSportPages::test5();
}
