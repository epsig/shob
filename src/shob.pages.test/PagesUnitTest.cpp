
#include <gtest/gtest.h>

#include "TestFormatNL.h"
#include "TestFormatEC.h"
#include "TestFormatEkWk.h"
#include "TestFormatEkWkQf.h"
#include "TestFormatOs.h"
#include "TestFormatUnOfficial.h"
#include "TestTopMenu.h"
#include "TestFormatStatsEredivisie.h"
#include "TestFormatBookmarks.h"
#include "TestFormatHomePage.h"
#include "../shob.pages/FormatRest.h"

using namespace shob::pages::test;

int main(int argc, char** argv)
{
    ::testing::InitGoogleTest(&argc, argv);
    //::testing::GTEST_FLAG(filter) = "unitTest.testFormatNL";
    return RUN_ALL_TESTS();
}

TEST(IntegrationTest, testFormatNL)
{
    TestFormatNL::test1();
}

TEST(IntegrationTest, testFormatNlDate)
{
    TestFormatNL::test_last_dd();
}

TEST(IntegrationTest, testFormatEc_2024_2025)
{
    TestFormatEC::test_2024_2025();
}

TEST(IntegrationTest, testFormatEc_2023_2024)
{
    TestFormatEC::test_2023_2024();
}

TEST(IntegrationTest, testFormatEc_1994_1995)
{
    TestFormatEC::test_1994_1995();
}

TEST(IntegrationTest, test_2019_2020_UK)
{
    TestFormatEC::test_2019_2020_UK();
}

TEST(IntegrationTest, test_ec_last_dd)
{
    TestFormatEC::test_last_dd();
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

TEST(IntegrationTest, testWk2022)
{
    TestFormatEkWk::test_wk_2022();
}

TEST(IntegrationTest, testEkD2022)
{
    TestFormatEkWk::test_ekD_2022();
}

TEST(IntegrationTest, testEkQf2000)
{
    TestFormatEkWkQf::test_ek_2000();
}

TEST(IntegrationTest, testEkQf2024)
{
    TestFormatEkWkQf::test_ek_2024();
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

TEST(IntegrationTest, testStatsEredivisieCompact)
{
    TestFormatStatsEredivisie::test1();
}

TEST(IntegrationTest, testStatsEredivisieExtra)
{
    TestFormatStatsEredivisie::test2();
}

TEST(IntegrationTest, testStatsEredivisieCompactVirtualData)
{
    TestFormatStatsEredivisie::test3();
}

TEST(IntegrationTest, testStatsEredivisieCompactVirtualDataHalfSeason)
{
    TestFormatStatsEredivisie::test4();
}

TEST(IntegrationTest, testStatsEredivisieExtraVirtualDataHalfSeason)
{
    TestFormatStatsEredivisie::test5();
}

TEST(IntegrationTest, testBookmarks)
{
    TestFormatBookmarks::test_1();
}

TEST(IntegrationTest, testOwnSportLinks)
{
    TestFormatBookmarks::test_2();
}

TEST(IntegrationTest, testOverzicht)
{
    TestFormatBookmarks::test_3();
}

TEST(IntegrationTest, testHomePage)
{
    TestFormatHomePage::test_1();
}

TEST(UnitTest, testLettersPage)
{
    const auto page = shob::pages::FormatRest("").getLetters().toString();
    EXPECT_NE(page.find("<title>Te bekijken met elke browser</title>"), std::string::npos);
    EXPECT_NE(page.find("<h1>Te bekijken met elke browser</h1>"), std::string::npos);
    EXPECT_NE(page.find("20 mei 2006"), std::string::npos);
    EXPECT_NE(page.find("href=\"reactie.html\""), std::string::npos);
    EXPECT_NE(page.find("include/anybrowser_coffee.gif"), std::string::npos);
    EXPECT_NE(page.find("Windows, Linux en Mac/Apple"), std::string::npos);
    EXPECT_NE(page.find("&lt;sup&gt;TM&lt;/sup&gt; = <sup>TM</sup>"), std::string::npos);
    EXPECT_NE(page.find("CH&lt;sub&gt;2&lt;/sub&gt;O = CH<sub>2</sub>O"), std::string::npos);
    for (const auto entity : { "amp", "euro", "micro", "gt", "pound", "para", "lt", "yen",
        "sect", "quot", "curren", "deg", "pi", "cent", "plusmn", "nbsp", "copy", "reg",
        "szlig", "aelig", "ccedil" })
    {
        EXPECT_NE(page.find(std::string("&amp;") + entity + "; = &" + entity + ";"), std::string::npos)
            << entity;
    }
    EXPECT_NE(page.find("</body></html>"), std::string::npos);
}

TEST(UnitTest, testLettersEntityRows)
{
    const auto page = shob::pages::FormatRest("").getLetters().toString();
    const std::vector<std::vector<std::string>> expected = {
        { "Aacute", "Acirc", "Agrave", "Atilde", "Auml", "Aring" },
        { "aacute", "acirc", "agrave", "atilde", "auml", "aring" },
        { "Eacute", "Ecirc", "Egrave", "", "Euml", "" },
        { "eacute", "ecirc", "egrave", "", "euml", "" },
        { "Iacute", "Icirc", "Igrave", "", "Iuml", "" },
        { "iacute", "icirc", "igrave", "", "iuml", "" },
        { "", "", "", "Ntilde", "", "" },
        { "", "", "", "ntilde", "", "" },
        { "Oacute", "Ocirc", "Ograve", "Otilde", "Ouml", "Oslash" },
        { "oacute", "ocirc", "ograve", "otilde", "ouml", "oslash" },
        { "Uacute", "Ucirc", "Ugrave", "", "Uuml", "" },
        { "uacute", "ucirc", "ugrave", "", "uuml", "" },
        { "Yacute", "", "", "", "Yuml", "" },
        { "yacute", "", "", "", "yuml", "" }
    };

    auto position = page.find("<tr><td> &amp;Aacute;");
    ASSERT_NE(position, std::string::npos);
    for (const auto& entities : expected)
    {
        std::string row = "<tr>";
        for (const auto& entity : entities)
        {
            row += entity.empty() ? "<td>&nbsp;</td>"
                : "<td> &amp;" + entity + "; = &" + entity + "; </td>";
        }
        row += "</tr>";
        EXPECT_EQ(page.substr(position, row.size()), row);
        position += row.size();
        position = page.find_first_not_of("\r\n", position);
        ASSERT_NE(position, std::string::npos);
    }
    EXPECT_EQ(page.substr(position, 8), "</table>");
}
