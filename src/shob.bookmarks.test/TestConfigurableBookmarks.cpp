#include "TestConfigurableBookmarks.h"
#include "../shob.test.utils/testUtils.h"
#include "../shob.bookmarks/ConfigurableBookmarks.h"
#include <gtest/gtest.h>

namespace shob::bookmarks::test
{
    using namespace readers::test;

    const std::string data_map = "../../data/bookmarks/";
    const std::string data_folder = testUtils::refFileWithPath(__FILE__, data_map);

    void TestConfigurableBookmarks::test1()
    {
        ConfigurableBookmarks bookmarks(data_folder);
        // Add assertions to test the behavior of ConfigurableBookmarks
    }
}
