#include "TestOwnSportPages.h"
#include "../shob.test.utils/testUtils.h"
#include "../shob.bookmarks/OwnSportPages.h"
#include <gtest/gtest.h>

namespace shob::bookmarks::test
{
    using namespace readers::test;

    const std::string data_map = "../../data/bookmarks/";
    const std::string data_folder = testUtils::refFileWithPath(__FILE__, data_map);

    void TestOwnSportPages::test1()
    {
        const auto result = OwnSportPages::getOlympicIceSkating();
        EXPECT_EQ(result.size(), 9);
    }

    void TestOwnSportPages::test2()
    {
        const auto result = OwnSportPages::getDutchSoccer();
        EXPECT_EQ(result.size(), 34);
    }

    void TestOwnSportPages::test3()
    {
        const auto result = OwnSportPages::getEuropacupSoccer();
        EXPECT_EQ(result.size(), 33);
    }

    void TestOwnSportPages::test4()
    {
        const auto result = OwnSportPages::getEkWkSoccer();
        EXPECT_EQ(result.size(), 16);
    }
}
