
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

    void testFormatEc::test_2023_2024()
    {
        const auto lines = fmt_ec.get_season("2023-2024");
        EXPECT_EQ(lines.data.size(), 154);
    }

    void testFormatEc::test_1994_1995()
    {
        const auto lines = fmt_ec.get_season("1994-1995");
        EXPECT_EQ(lines.data.size(), 86);
    }
}

