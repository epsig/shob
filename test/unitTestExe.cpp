
#include <gtest/gtest.h>

#include "testCsvReader.h"

using namespace shob::readers::test;

int main(int argc, char** argv)
{
    ::testing::InitGoogleTest(&argc, argv);
    //::testing::GTEST_FLAG(filter) = "unitTest.testCsvReader";
    return RUN_ALL_TESTS();
}

TEST(unitTest, testCsvReader)
{
    testCsvReader::test1();
}

