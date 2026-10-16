#include "KlaverjasTableTest.h"
#include "VersleutelTest.h"

#include <gtest/gtest.h>

using namespace shob::klaverjas::test;

int main(int argc, char** argv)
{
    ::testing::InitGoogleTest(&argc, argv);
    //::testing::GTEST_FLAG(filter) = "unitTest.testBuildTableGfx";
    return RUN_ALL_TESTS();
}

TEST(unitTest, testBuildTableGfx)
{
    KlaverjasTableTest::TestBuildGfx();
}

TEST(unitTest, testBuildTableTxt)
{
    KlaverjasTableTest::TestBuildTxt();
}

TEST(unitTest, testVersleutel)
{
    VersleutelTest::TestVersleutel();
}
