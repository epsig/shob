
#include "test_topmenu.h"

#include <gtest/gtest.h>

#include "../shob.pages/topMenu.h"
#include "../shob.test.utils/testUtils.h"

namespace shob::pages::test
{
    using namespace readers::test;

    std::vector<std::string> testTopMenu::getArchive()
    {
        auto archive = std::vector<std::string>();
        for (int i = 2010; i < 2020; i++)
        {
            auto szn = general::season(i);
            archive.push_back("test_" + szn.to_part_filename() + ".csv");
        }
        return archive;
    }

    void testTopMenu::test_left()
    {
        auto archive = getArchive();
        auto menu = topMenu(archive, 6);
        auto tpmenu1 = menu.getMenu(general::season(2012));
        EXPECT_EQ(tpmenu1.data.size(), 8);
        EXPECT_EQ(tpmenu1.data[2], "12-13");
        EXPECT_EQ(tpmenu1.data[6], "...");
    }

    void testTopMenu::test_center()
    {
        auto archive = getArchive();
        auto menu = topMenu(archive, 6);
        auto tpmenu1 = menu.getMenu(general::season(2015));
        EXPECT_EQ(tpmenu1.data.size(), 9);
        EXPECT_EQ(tpmenu1.data[1], "...");
        EXPECT_EQ(tpmenu1.data[4], "15-16");
        EXPECT_EQ(tpmenu1.data[7], "...");
    }

    void testTopMenu::test_right()
    {
        auto archive = getArchive();
        auto menu = topMenu(archive, 6);
        auto tpmenu1 = menu.getMenu(general::season(2018));
        EXPECT_EQ(tpmenu1.data.size(), 8);
        EXPECT_EQ(tpmenu1.data[6], "18-19");
        EXPECT_EQ(tpmenu1.data[1], "...");
    }
}

