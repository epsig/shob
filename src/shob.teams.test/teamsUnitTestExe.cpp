
#include <gtest/gtest.h>

#include "testClubTeams.h"
#include "testNationalTeams.h"

using namespace shob::teams::test;

int main(int argc, char** argv)
{
    ::testing::InitGoogleTest(&argc, argv);
    //::testing::GTEST_FLAG(filter) = "unitTest.testClubs";
    return RUN_ALL_TESTS();
}

TEST(unitTest, testClubs)
{
    testClubTeams::test1();
}

TEST(unitTest, testLandcodes)
{
    testNationalTeams::test1();
}

