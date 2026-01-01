
#include "test_format_os.h"

#include <gtest/gtest.h>

#include "../shob.html/settings.h"
#include "../shob.pages/format_os_factory.h"
#include "../shob.test.utils/testUtils.h"

namespace shob::pages::test
{
    using namespace readers::test;

    const std::string dataMap = "../../data/sport/schaatsen/";
    const std::string dataFolder = testUtils::refFileWithPath(__FILE__, dataMap);
    const html::settings settings = html::settings();
    const auto fmt_os = format_os_factory::build(dataFolder, settings);

    void testFormatOS::test_os_2002()
    {
        const auto lines = fmt_os.get_pages(2002);
        ASSERT_EQ(lines.data.size(), 205);
        EXPECT_GE(lines.findString("Salt Lake City"), 0);
        EXPECT_GE(lines.findString("Jochem Uytdehaage"), 0);
        EXPECT_GE(lines.findString("Marianne Timmer"), 0);
    }

}

