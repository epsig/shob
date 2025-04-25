
#include <gtest/gtest.h>

#include "testTable.h"

using namespace shob::html::test;

int main(int argc, char** argv)
{
    ::testing::InitGoogleTest(&argc, argv);
    //::testing::GTEST_FLAG(filter) = "unitTest.testTable1";
    return RUN_ALL_TESTS();
}

TEST(unitTest, testTable1)
{
    testTable::test1();
}

