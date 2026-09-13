#include "TestFormatHomePage.h"

#include <gtest/gtest.h>

#include "../shob.pages/FormatHomePage.h"
#include "../shob.test.utils/testUtils.h"

namespace shob::pages::test
{
    using namespace readers::test;

    const std::string data_map = "../../data/bookmarks/";
    const std::string data_folder = testUtils::refFileWithPath(__FILE__, data_map);

    void TestFormatHomePage::test_1()
    {
        const auto format_home_page = FormatHomePage(data_folder);

        const auto lines = format_home_page.getHomePage(20260913);
        ASSERT_EQ(lines.data.size(), 74);
        EXPECT_GE(lines.findString("US Open"), 0) << "check event US Open is found";
        EXPECT_GE(lines.findString("Prinsjesdag"), 0) << "check event Prinsjesdag is found";
        EXPECT_GE(lines.findString("Vuelta"), 0) << "check event Vuelta is found";
    }
}
