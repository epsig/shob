
#include "TestFormatNL.h"

#include <gtest/gtest.h>

#include "../shob.pages/FormatNL_Factory.h"
#include "../shob.test.utils/testUtils.h"

namespace shob::pages::test
{
    using namespace readers::test;

    void TestFormatNL::test1()
    {
        const std::string dataMap = "../../data/sport/";
        const std::string dataFolder = testUtils::refFileWithPath(__FILE__, dataMap);
        auto fmt_nl = format_nl_factory::build(dataFolder);
        auto lines = fmt_nl.get_season(general::Season(2023));
        EXPECT_EQ(lines.data.size(), 128);
    }
}

