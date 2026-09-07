#include "TestConfigurableBookmarks.h"
#include "../shob.test.utils/testUtils.h"
#include "../shob.bookmarks/ConfigurableBookmarks.h"
#include <gtest/gtest.h>

namespace shob::bookmarks::test
{
    using namespace readers::test;

    const std::string data_map = "../../data/bookmarks/";
    const std::string data_folder = testUtils::refFileWithPath(__FILE__, data_map);

    void TestConfigurableBookmarks::testGetProperties()
    {
        ConfigurableBookmarks bookmarks(data_folder);
        PageProperties props;
        auto result = bookmarks.getProperties(props, "media");
        ASSERT_TRUE(result);
        ASSERT_EQ(props.title, "Bookmarks: media");
        ASSERT_EQ(props.dd, 0);
    }

    void TestConfigurableBookmarks::testGetAllParts()
    {
        ConfigurableBookmarks bookmarks(data_folder);
        auto result = bookmarks.getAllParts("media");
        ASSERT_EQ(result.size(), 6);
    }

    void TestConfigurableBookmarks::testGetEventsForBlock()
    {
        ConfigurableBookmarks bookmarks(data_folder);
        auto result = bookmarks.getEventsForBlock("radio");
        ASSERT_EQ(result.size(), 8);
    }
}
