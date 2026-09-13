#include "TestFormatBookmarks.h"

#include <gtest/gtest.h>

#include "../shob.pages/FormatBookmarks.h"
#include "../shob.test.utils/testUtils.h"

namespace shob::pages::test
{
    using namespace readers::test;

    const std::string data_map = "../../data/bookmarks/";
    const std::string data_folder = testUtils::refFileWithPath(__FILE__, data_map);

    void TestFormatBookmarks::test_1()
    {
        const auto format_bookmarks = FormatBookmarks(data_folder, 20260913);

        const auto lines = format_bookmarks.getBookmarks("media", false);
        ASSERT_EQ(lines.data.size(), 91);
        EXPECT_GE(lines.findString("US Open"), 0) << "check event US Open is found";
        EXPECT_GE(lines.findString("Prinsjesdag"), 0) << "check event Prinsjesdag is found";
        EXPECT_GE(lines.findString("Vuelta"), 0) << "check event Vuelta is found";
    }

    void TestFormatBookmarks::test_2()
    {
        const auto lines = FormatBookmarks::getOwnSportLinks();
        ASSERT_EQ(lines.data.size(), 125);
    }

    void TestFormatBookmarks::test_3()
    {
        const auto lines = FormatBookmarks::getOverzicht();
        ASSERT_EQ(lines.data.size(), 138);
    }

}
