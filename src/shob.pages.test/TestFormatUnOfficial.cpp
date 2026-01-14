
#include "TestFormatUnOfficial.h"

#include <gtest/gtest.h>

#include "../shob.html/settings.h"
#include "../shob.pages/FormatUnOfficialStandingsFactory.h"
#include "../shob.test.utils/testUtils.h"

namespace shob::pages::test
{
    using namespace readers::test;

    const std::string dataMap = "../../data/sport/eredivisie/";
    const std::string dataFolder = testUtils::refFileWithPath(__FILE__, dataMap);
    const html::settings settings = html::settings();
    const auto fmt_un_off = FormatUnOfficialStandingsFactory::build(dataFolder, settings);

    void TestFormatUnOfficial::testYearStanding2010()
    {
        const auto lines = fmt_un_off.getPages(2010);
        ASSERT_EQ(lines.data.size(), 105);
    }

    void TestFormatUnOfficial::testHomeAndAway2010()
    {
        auto season = general::Season(2010);
        const auto lines = fmt_un_off.getSeason(season);
        ASSERT_EQ(lines.data.size(), 103);
    }

}

