
#include "test_format_nl.h"

#include <gtest/gtest.h>

#include "../shob.pages/format_nl.h"
#include "../shob.general.test/testUtils.h"

namespace shob::pages::test
{
    void testFormatNL::test1()
    {
        const std::string dataFolder = readers::test::testUtils::refFileWithPath(__FILE__, "../../data/sport/");
        auto fmt_nl = shob::pages::format_nl(dataFolder);
        auto lines = fmt_nl.get_season("2023-2024");
        EXPECT_EQ(lines.size(), 23);
    }
}

