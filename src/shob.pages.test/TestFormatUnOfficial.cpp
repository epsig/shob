
#include "TestFormatUnOfficial.h"

#include <gtest/gtest.h>

#include "../shob.html/settings.h"
#include "../shob.pages/FormatSemestersAndYearStandingsFactory.h"
#include "../shob.pages/FormatHomeAndAwayStandingsFactory.h"
#include "../shob.test.utils/testUtils.h"

namespace shob::pages::test
{
    using namespace readers::test;

    void TestFormatUnOfficial::testYearStanding2010()
    {
        const std::string dataMap = "../../data/sport/eredivisie/";
        const std::string dataFolder = testUtils::refFileWithPath(__FILE__, dataMap);
        const html::settings settings = html::settings();
        const auto fmt_un_off = FormatSemestersAndYearStandingsFactory().build(dataFolder, settings);
        const auto lines = fmt_un_off.getPages(2010);
        ASSERT_EQ(lines.data.size(), 105);
    }

    void TestFormatUnOfficial::testHomeAndAway2010()
    {
        const std::string dataMap = "../../data/sport/eredivisie/";
        const std::string dataFolder = testUtils::refFileWithPath(__FILE__, dataMap);
        const html::settings settings = html::settings();
        const auto fmt_home_away = FormatHomeAndAwayStandingsFactory::build(dataFolder, settings);
        auto season = general::Season(2010);
        const bool exists = fmt_home_away.isValidSeason(season);
        ASSERT_TRUE(exists);
        const auto lines = fmt_home_away.getSeason(season);
        ASSERT_EQ(lines.data.size(), 103);
    }

    void TestFormatUnOfficial::testYearStandingTestData1()
    {
        const std::string dataMap = "../testdata/yearstandings1/";
        const std::string dataFolder = testUtils::refFileWithPath(__FILE__, dataMap);
        const html::settings settings = html::settings();
        const auto fmt_un_off = FormatSemestersAndYearStandingsFactory().build(dataFolder, settings);
        const auto last_year = fmt_un_off.getLastYear();
        EXPECT_EQ(last_year, 2014);
        const auto lines = fmt_un_off.getPages(2011);
        ASSERT_EQ(lines.data.size(), 95);
    }

    void TestFormatUnOfficial::testYearStandingTestData2()
    {
        const std::string dataMap = "../testdata/yearstandings2/";
        const std::string dataFolder = testUtils::refFileWithPath(__FILE__, dataMap);
        const html::settings settings = html::settings();
        const auto fmt_un_off = FormatSemestersAndYearStandingsFactory().build(dataFolder, settings);
        const auto last_year = fmt_un_off.getLastYear();
        EXPECT_EQ(last_year, 2013);
        const auto lines = fmt_un_off.getPages(2011);
        ASSERT_EQ(lines.data.size(), 94);
    }

}

