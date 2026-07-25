
#include "TestFormatEkWk.h"

#include <gtest/gtest.h>

#include "../shob.pages/FormatEkWkFactory.h"
#include "../shob.pages/FormatEkWkDFactory.h"
#include "../shob.test.utils/testUtils.h"

namespace shob::pages::test
{
    using namespace readers::test;

    const std::string data_map = "../../data/sport/";
    const std::string data_folder = testUtils::refFileWithPath(__FILE__, data_map);
    constexpr auto settings = html::settings();

    void TestFormatEkWk::test_wk_2022()
    {
        const auto format_ek_wk = FormatEkWkFactory::build(data_folder, settings);
        const auto lines = format_ek_wk.getPages(2022);
        ASSERT_EQ(lines.data.size(), 233);
        EXPECT_GE(lines.findString("Scheidsrechter: Ghorbal (DZ). </br>"), 0);
        EXPECT_GE(lines.findString("81' 3-1 Denzel Dumfries<br/>"), 0);
        EXPECT_GE(lines.findString("Na 64 wedstrijden: 3.45 miljoen toeschouwers; gemiddeld = 54 duizend."), 0);
        EXPECT_GE(lines.findString("<tr><td>&nbsp;Spanje - Costa Rica&nbsp;</td><td class=c>&nbsp;7-0&nbsp;</td><td>&nbsp;Spanje - Costa Rica&nbsp;</td><td class=c>&nbsp;7-0&nbsp;</td><td>&nbsp;Engeland - Iran&nbsp;</td><td class=c>&nbsp;6-2&nbsp;</td></tr>"), 0);
        EXPECT_GE(lines.findString("Strafschoppenserie: 3-4"), 0);
    }

    void TestFormatEkWk::test_ekD_2022()
    {
        const auto format_ek_wk_d = FormatEkWkDFactory::build(data_folder, settings);
        const auto lines = format_ek_wk_d.getPages(2022);
        ASSERT_EQ(lines.data.size(), 126);
    }

}

