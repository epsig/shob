#include <gtest/gtest.h>

#include "TestClubTeams.h"
#include "TestNationalTeams.h"

using namespace shob::teams::test;

int main(int argc, char** argv)
{
    ::testing::InitGoogleTest(&argc, argv);
    //::testing::GTEST_FLAG(filter) = "unitTest.testClubs";
    return RUN_ALL_TESTS();
}

TEST(unitTest, testClubs)
{
    TestClubTeams::test1();
}

TEST(unitTest, testLandcodes)
{
    TestNationalTeams::test1();
}
