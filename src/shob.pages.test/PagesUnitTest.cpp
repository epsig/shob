
#include <gtest/gtest.h>

#include "test_format_nl.h"
#include "test_format_ec.h"
#include "test_format_ekwk_qf.h"
#include "TestFormatOs.h"
#include "TestFormatUnOfficial.h"
#include "TestTopMenu.h"

using namespace shob::pages::test;

int main(int argc, char** argv)
{
    ::testing::InitGoogleTest(&argc, argv);
    //::testing::GTEST_FLAG(filter) = "unitTest.testFormatNL";
    return RUN_ALL_TESTS();
}

TEST(IntegrationTest, testFormatNL)
{
    testFormatNL::test1();
}

TEST(IntegrationTest, testFormatEc_2024_2025)
{
    testFormatEc::test_2024_2025();
}

TEST(IntegrationTest, testFormatEc_2023_2024)
{
    testFormatEc::test_2023_2024();
}

TEST(IntegrationTest, testFormatEc_1994_1995)
{
    testFormatEc::test_1994_1995();
}

TEST(IntegrationTest, test_2019_2020_UK)
{
    testFormatEc::test_2019_2020_UK();
}

TEST(UnitTest, testTopMenuLeft)
{
    TestTopMenu::testLeft();
}

TEST(UnitTest, testTopMenuCenter)
{
    TestTopMenu::testCenter();
}

TEST(UnitTest, testTopMenuRight)
{
    TestTopMenu::testRight();
}

TEST(IntegrationTest, testEkQf2000)
{
    testFormatEkWkQf::test_ek_2000();
}

TEST(IntegrationTest, testEkQf2024)
{
    testFormatEkWkQf::test_ek_2024();
}

TEST(IntegrationTest, testOsSchaatsen)
{
    TestFormatOs::testOs2002();
}

TEST(UnitTest, testOsPrintResultPoints)
{
    TestFormatOs::testPrintResultPoints();
}

TEST(UnitTest, testOsPrintWithColon)
{
    TestFormatOs::testPrintResultWithColon();
}

TEST(UnitTest, testOsPrintTwoRuns)
{
    TestFormatOs::testPrintResultWithTwoRuns();
}

TEST(UnitTest, testOsPrintHappyFlow)
{
    TestFormatOs::testPrintResultHappyFlow();
}

TEST(IntegrationTest, testHomeAndAway)
{
    TestFormatUnOfficial::testHomeAndAway2010();
}

TEST(IntegrationTest, testYearStandings)
{
    TestFormatUnOfficial::testYearStanding2010();
}

TEST(IntegrationTest, testYearStandingsExtra1)
{
    TestFormatUnOfficial::testYearStandingTestData1();
}

TEST(IntegrationTest, testYearStandingsExtra2)
{
    TestFormatUnOfficial::testYearStandingTestData2();
}
