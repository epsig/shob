
#include "TestFormatEkWk.h"

#include <gtest/gtest.h>

#include "../shob.pages/FormatEkWkFactory.h"
#include "../shob.test.utils/testUtils.h"

namespace shob::pages::test
{
    using namespace readers::test;

    const std::string data_map = "../../data/sport/";
    const std::string data_folder = testUtils::refFileWithPath(__FILE__, data_map);
    constexpr auto settings = html::settings();
    const auto format_ek_wk = FormatEkWkFactory::build(data_folder, settings);

    void TestFormatEkWk::test_wk_2022()
    {
        const auto lines = format_ek_wk.getPages(2022);
        ASSERT_EQ(lines.data.size(), 205);
        EXPECT_GE(lines.findString("Scheidsrechter:  Ghorbal (DZ) . </br>"), 0);
        EXPECT_GE(lines.findString("81 min 3-1 Denzel Dumfries<br/>"), 0);
        EXPECT_GE(lines.findString( "Na 63 wedstrijden: 3.41 miljoen toeschouwers; gemiddeld = 54 duizend."), 0);
        EXPECT_GE(lines.findString("<tr><td>Spanje - Costa Rica</td><td class=c>7-0</td><td>Spanje - Costa Rica</td><td class=c>7-0</td><td>Engeland - Iran</td><td class=c>6-2</td></tr>"), 0);
    }

}

