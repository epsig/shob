
#include "TestTopMenu.h"

#include <gtest/gtest.h>

#include "../shob.pages/TopMenu.h"
#include "../shob.test.utils/testUtils.h"

namespace shob::pages::test
{
    using namespace readers::test;

    std::vector<std::string> TestTopMenu::getArchive()
    {
        auto archive = std::vector<std::string>();
        for (int i = 2010; i < 2020; i++)
        {
            const auto season = general::Season(i);
            archive.push_back("test_" + season.toPartFilename() + ".csv");
        }
        return archive;
    }

    void TestTopMenu::testLeft()
    {
        const auto archive = getArchive();
        const auto menu = TopMenu(archive, 'K', 6);
        const auto top_menu_1 = menu.getMenu(general::Season(2012));
        EXPECT_EQ(top_menu_1.data.size(), 8);
        EXPECT_EQ(top_menu_1.data[2], "12-13 |");
        EXPECT_EQ(top_menu_1.data[6], " ...  |");
    }

    void TestTopMenu::testCenter()
    {
        const auto archive = getArchive();
        const auto menu = TopMenu(archive, 'K',6);
        const auto top_menu_1 = menu.getMenu(general::Season(2015));
        EXPECT_EQ(top_menu_1.data.size(), 9);
        EXPECT_EQ(top_menu_1.data[1], " ...  |");
        EXPECT_EQ(top_menu_1.data[4], "15-16 |");
        EXPECT_EQ(top_menu_1.data[7], " ...  |");
    }

    void TestTopMenu::testRight()
    {
        const auto archive = getArchive();
        const auto menu = TopMenu(archive, 'K',6);
        const auto top_menu_1 = menu.getMenu(general::Season(2018));
        EXPECT_EQ(top_menu_1.data.size(), 8);
        EXPECT_EQ(top_menu_1.data[6], "18-19 |");
        EXPECT_EQ(top_menu_1.data[1], " ...  |");
    }
}

