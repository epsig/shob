
#include "test_format_ec.h"

#include <gtest/gtest.h>

#include "../shob.pages/format_ec_factory.h"
#include "../shob.test.utils/testUtils.h"

namespace shob::pages::test
{
    using namespace readers::test;

    const std::string dataMap = "../../data/sport/";
    const std::string dataFolder = testUtils::refFileWithPath(__FILE__, dataMap);
    const auto fmt_ec = format_ec_factory::build(dataFolder);

    void testFormatEc::test_2024_2025()
    {
        const auto lines = fmt_ec.get_season("2024-2025");
        ASSERT_EQ(lines.data.size(), 244);
        EXPECT_EQ(lines.data[16], "<tr><td>Atalanta Bergamo +</td><td>8</td><td>15</td><td>14</td></tr>") << "check + after team name";
    }

    void testFormatEc::test_2023_2024()
    {
        const auto lines = fmt_ec.get_season("2023-2024");
        EXPECT_EQ(lines.data.size(), 154);
    }

    void testFormatEc::test_1994_1995()
    {
        const auto lines = fmt_ec.get_season("1994-1995");
        ASSERT_EQ(lines.data.size(), 95);
        EXPECT_EQ(lines.data[12], "<tr><td>Ajax</td><td>6</td><td>10</td><td>7</td></tr>") << "check 2 points for a win";
    }
}

