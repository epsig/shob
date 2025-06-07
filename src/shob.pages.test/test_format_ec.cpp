
#include "test_format_ec.h"

#include <gtest/gtest.h>

#include "../shob.pages/format_ec_factory.h"
#include "../shob.test.utils/testUtils.h"

namespace shob::pages::test
{
    using namespace readers::test;

    void testFormatEc::test1()
    {
        const std::string dataMap = "../../data/sport/";
        const std::string dataFolder = testUtils::refFileWithPath(__FILE__, dataMap);
        auto fmt_ec = format_ec_factory::build(dataFolder);
        auto lines = fmt_ec.get_season("2023-2024");
        EXPECT_EQ(lines.size(), 84);
    }
}

