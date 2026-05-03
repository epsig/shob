
#include "TestFormatStatsEredivisie.h"

#include <gtest/gtest.h>

#include "../shob.pages/FormatStatsEredivisieFactory.h"
#include "../shob.test.utils/testUtils.h"
#include "../shob.html/settings.h"

namespace shob::pages::test
{
    using namespace readers::test;

    void TestFormatStatsEredivisie::test1()
    {
        const std::string dataMap = "../../data/sport/eredivisie/";
        const std::string dataFolder = testUtils::refFileWithPath(__FILE__, dataMap);
        constexpr auto settings = html::settings();
        const auto fmt_stats_eredivisie = FormatStatsEredivisieFactory::build(dataFolder, settings);
        const auto lines = fmt_stats_eredivisie.getStats(false);
        EXPECT_GE(lines.findString("Klaas-Jan Huntelaar"), 0);
        EXPECT_EQ(lines.findString("Marco van Basten"), -1);
    }

    void TestFormatStatsEredivisie::test2()
    {
        const std::string dataMap = "../../data/sport/eredivisie";
        const std::string dataFolder = testUtils::refFileWithPath(__FILE__, dataMap);
        constexpr auto settings = html::settings();
        const auto fmt_stats_eredivisie = FormatStatsEredivisieFactory::build(dataFolder, settings);
        const auto lines = fmt_stats_eredivisie.getStats(true);
        EXPECT_GE(lines.findString("Marco van Basten"), 0);
    }

    void TestFormatStatsEredivisie::test3()
    {
        const std::string dataMap = "../testdata/yearstandings1/";
        const std::string dataFolder = testUtils::refFileWithPath(__FILE__, dataMap);
        constexpr auto settings = html::settings();
        const auto fmt_stats_eredivisie = FormatStatsEredivisieFactory::build(dataFolder, settings);
        const auto lines = fmt_stats_eredivisie.getStats(false);
        EXPECT_EQ(lines.data.size(), 91);
    }

    void TestFormatStatsEredivisie::test4()
    {
        const std::string dataMap = "../testdata/yearstandings2/";
        const std::string dataFolder = testUtils::refFileWithPath(__FILE__, dataMap);
        constexpr auto settings = html::settings();
        const auto fmt_stats_eredivisie = FormatStatsEredivisieFactory::build(dataFolder, settings);
        const auto lines = fmt_stats_eredivisie.getStats(false);
        EXPECT_EQ(lines.data.size(), 89);
    }

    void TestFormatStatsEredivisie::test5()
    {
        const std::string dataMap = "../testdata/yearstandings2/";
        const std::string dataFolder = testUtils::refFileWithPath(__FILE__, dataMap);
        constexpr auto settings = html::settings();
        const auto fmt_stats_eredivisie = FormatStatsEredivisieFactory::build(dataFolder, settings);
        const auto lines = fmt_stats_eredivisie.getStats(true);
        EXPECT_EQ(lines.data.size(), 96);
    }
}

