
#include <gtest/gtest.h>

#include "test_format_nl.h"
#include "test_format_ec.h"
#include "test_format_ekwk_qf.h"
#include "TestFormatOs.h"
#include "TestTopMenu.h"

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

TEST(unitTest, testFormatEc_2024_2025)
{
    testFormatEc::test_2024_2025();
}

TEST(unitTest, testFormatEc_2023_2024)
{
    testFormatEc::test_2023_2024();
}

TEST(unitTest, testFormatEc_1994_1995)
{
    testFormatEc::test_1994_1995();
}

TEST(unitTest, test_2019_2020_UK)
{
    testFormatEc::test_2019_2020_UK();
}

TEST(unitTest, test_top_menu_left)
{
    TestTopMenu::testLeft();
}

TEST(unitTest, test_top_menu_center)
{
    TestTopMenu::testCenter();
}

TEST(unitTest, test_top_menu_right)
{
    TestTopMenu::testRight();
}

TEST(unitTest, test_voorr_ek_2000)
{
    testFormatEkWkQf::test_ek_2000();
}

TEST(unitTest, test_voorr_ek_2024)
{
    testFormatEkWkQf::test_ek_2024();
}

TEST(unitTest, test_os_schaatsen)
{
    TestFormatOs::testOs2002();
}

TEST(unitTest, test_os_print_result_points)
{
    TestFormatOs::testPrintResultPoints();
}

TEST(unitTest, test_os_print_with_colon)
{
    TestFormatOs::testPrintResultWithColon();
}

TEST(unitTest, test_os_print_two_runs)
{
    TestFormatOs::testPrintResultWithTwoRuns();
}

TEST(unitTest, test_os_print_happy_flow)
{
    TestFormatOs::testPrintResultHappyFlow();
}
