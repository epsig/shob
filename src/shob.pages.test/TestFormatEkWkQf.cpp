
#include "TestFormatEkWkQf.h"

#include <gtest/gtest.h>

#include "../shob.pages/FormatEkWkQfFactory.h"
#include "../shob.test.utils/testUtils.h"

namespace shob::pages::test
{
    using namespace readers::test;

    const std::string data_map = "../../data/sport/";
    const std::string data_folder = testUtils::refFileWithPath(__FILE__, data_map);
    constexpr auto settings = html::settings();
    const auto format_ek_wk_qf = FormatEkWkQfFactory::build(data_folder, settings);

    void TestFormatEkWkQf::test_ek_2000()
    {
        const auto lines = format_ek_wk_qf.getPages(2000);
        ASSERT_EQ(lines.data.size(), 183);
        EXPECT_GE(lines.findString("Alle groepen:"), 0);
        EXPECT_GE(lines.findString("<tr><td>Andorra -</td><td>10</td>"), 0);
    }

    void TestFormatEkWkQf::test_ek_2024()
    {
        const auto lines = format_ek_wk_qf.getPages(2024);
        EXPECT_EQ(lines.data.size(), 123);
        EXPECT_GE(lines.findString("18 jun 2023 <b>Spanje</b> - Kroati&euml; 0-0 ns"), 0);
    }

}

