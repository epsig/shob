
#include "test_format_ec.h"

#include <gtest/gtest.h>

#include "../shob.pages/format_ec_factory.h"
#include "../shob.test.utils/testUtils.h"

namespace shob::pages::test
{
    using namespace readers::test;

    const std::string dataMap = "../../data/sport/";
    const std::string dataFolder = testUtils::refFileWithPath(__FILE__, dataMap);
    const html::settings settings = html::settings();
    const auto fmt_ec = format_ec_factory::build(dataFolder, settings);

    void testFormatEc::test_2024_2025()
    {
        const auto lines = fmt_ec.get_season(general::season(2024));
        ASSERT_EQ(lines.data.size(), 287);
        EXPECT_GE(lines.findString("Atalanta Bergamo (Itali&euml;) +"), 0) << "check + after team name";
    }

    void testFormatEc::test_2023_2024()
    {
        const auto lines = fmt_ec.get_season(general::season(2023));
        EXPECT_EQ(lines.data.size(), 187);
    }

    void testFormatEc::test_1994_1995()
    {
        const auto lines = fmt_ec.get_season(general::season(1994));
        ASSERT_EQ(lines.data.size(), 126);
        EXPECT_GE(lines.findString("4 x w, 2 x g en 0 x v => 10 pnt"), 0) << "check 2 points for a win";
    }

    void testFormatEc::test_2019_2020_UK()
    {
        const html::settings settingsUK = html::settings(html::language::English);
        const auto fmt_ec_uk = format_ec_factory::build(dataFolder, settingsUK);
        const auto lines = fmt_ec_uk.get_season(general::season(2019));
        ASSERT_EQ(lines.data.size(), 173);
        EXPECT_GE(lines.findString("Due to the Covid-19 pandemic, the tournament was suspended"), 0) << "check reading comma between quotes";
        EXPECT_GE(lines.findString("<br>Sevilla wins the Europa League with two goals of Luuk de Jong."), 0) << "check UK summary";
        EXPECT_GE(lines.findString("<b>F I N A L:</b>"), 0) << "check language in route2final";
    }
}

