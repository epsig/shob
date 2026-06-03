
#include "TestFormatEkWk.h"

#include <gtest/gtest.h>

#include "../shob.pages/FormatEkWkFactory.h"
#include "../shob.test.utils/testUtils.h"

namespace shob::pages::test
{
    using namespace readers::test;

    const std::string dataMap = "../../data/sport/";
    const std::string dataFolder = testUtils::refFileWithPath(__FILE__, dataMap);
    const html::settings settings = html::settings();
    const auto fmt_ekwk = FormatEkWkFactory::build(dataFolder, settings);

    void TestFormatEkWk::test_wk_2022()
    {
        const auto lines = fmt_ekwk.getPages(2022);
        ASSERT_EQ(lines.data.size(), 0);
        //EXPECT_GE(lines.findString("Alle groepen:"), 0);
        //EXPECT_GE(lines.findString("<tr><td>Andorra -</td><td>10</td>"), 0);
    }

}

