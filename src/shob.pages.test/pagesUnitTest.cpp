
#include <gtest/gtest.h>

#include "test_format_nl.h"
#include "test_format_ec.h"

using namespace shob::pages::test;

int main(int argc, char** argv)
{
    ::testing::InitGoogleTest(&argc, argv);
    //::testing::GTEST_FLAG(filter) = "unitTest.testFormatNL";
    return RUN_ALL_TESTS();
}

TEST(unitTest, testFormatNL)
{
    testFormatNL::test1();
}

TEST(unitTest, testFormatEc_2023_2024)
{
    testFormatEc::test_2023_2024();
}

TEST(unitTest, testFormatEc_1994_1995)
{
    testFormatEc::test_1994_1995();
}

