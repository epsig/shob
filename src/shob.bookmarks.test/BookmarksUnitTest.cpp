#include <gtest/gtest.h>
#include "TestCurrentEvents.h"

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
