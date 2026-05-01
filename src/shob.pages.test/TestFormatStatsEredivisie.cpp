
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
        const std::string dataMap = "../../data/sport/";
        const std::string dataFolder = testUtils::refFileWithPath(__FILE__, dataMap);
        constexpr auto settings = html::settings();
        const auto fmt_stats_eredivisie = FormatStatsEredivisieFactory::build(dataFolder, settings);
        const auto lines = fmt_stats_eredivisie.getStats(false);
        EXPECT_GE(lines.findString("Klaas-Jan Huntelaar"), 0);
        EXPECT_EQ(lines.findString("Marco van Basten"), -1);
    }

    void TestFormatStatsEredivisie::test2()
    {
        const std::string dataMap = "../../data/sport/";
        const std::string dataFolder = testUtils::refFileWithPath(__FILE__, dataMap);
        constexpr auto settings = html::settings();
        const auto fmt_stats_eredivisie = FormatStatsEredivisieFactory::build(dataFolder, settings);
        const auto lines = fmt_stats_eredivisie.getStats(true);
        EXPECT_GE(lines.findString("Marco van Basten"), 0);
    }
}

