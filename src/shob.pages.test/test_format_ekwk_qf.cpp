
#include "test_format_ekwk_qf.h"

#include <gtest/gtest.h>

#include "../shob.pages/format_ekwk_qf_factory.h"
#include "../shob.test.utils/testUtils.h"

namespace shob::pages::test
{
    using namespace readers::test;

    const std::string dataMap = "../../data/sport/";
    const std::string dataFolder = testUtils::refFileWithPath(__FILE__, dataMap);
    const html::settings settings = html::settings();
    const auto fmt_ekwk_qf = format_ekwk_qf_factory::build(dataFolder, settings);

    void testFormatEkWkQf::test_ek_2000()
    {
        const auto lines = fmt_ekwk_qf.getPages(2000);
        ASSERT_EQ(lines.data.size(), 189);
        EXPECT_GE(lines.findString("Alle groepen:"), 0);
        EXPECT_GE(lines.findString("<tr><td>Andorra -</td><td>10</td>"), 0);
    }

    void testFormatEkWkQf::test_ek_2024()
    {
        const auto lines = fmt_ekwk_qf.getPages(2024);
        EXPECT_EQ(lines.data.size(), 131);
        EXPECT_GE(lines.findString("18 jun 2023 <b>Spanje</b> - Kroati&euml; 0-0 ns"), 0);
    }

}

