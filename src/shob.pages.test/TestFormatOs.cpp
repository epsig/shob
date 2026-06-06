
#include "TestFormatOs.h"

#include <gtest/gtest.h>

#include "../shob.html/settings.h"
#include "../shob.pages/FormatOsFactory.h"
#include "../shob.test.utils/testUtils.h"

namespace shob::pages::test
{
    using namespace readers::test;

    const std::string data_map = "../../data/sport/schaatsen/";
    const std::string data_folder = testUtils::refFileWithPath(__FILE__, data_map);
    constexpr auto settings = html::settings();
    const auto format_os = FormatOsFactory::build(data_folder, settings);

    void TestFormatOs::testOs2002()
    {
        const auto lines = format_os.getPages(2002);
        ASSERT_EQ(lines.data.size(), 202);
        EXPECT_GE(lines.findString("Salt Lake City"), 0);
        EXPECT_GE(lines.findString("Jochem Uytdehaage"), 0);
        EXPECT_GE(lines.findString("Marianne Timmer"), 0);
    }

    void TestFormatOs::testPrintResultPoints()
    {
        const std::string input = "63 p";
        const std::string empty;
        const auto result1 = FormatOs::printResult(input, empty);
        EXPECT_EQ(result1, input);

        const std::string remark = "WR";
        const std::string expected = "63 p (WR)";
        const auto result2 = FormatOs::printResult(input, remark);
        EXPECT_EQ(result2, expected);
    }

    void TestFormatOs::testPrintResultWithColon()
    {
        const std::string input = "6:12.34";
        const std::string empty;
        const std::string expected1 = "6 min 12.34 s";
        const auto result1 = FormatOs::printResult(input, empty);
        EXPECT_EQ(result1, expected1);

        const std::string remark = "WR";
        const std::string expected2 = "6 min 12.34 s (WR)";
        const auto result2 = FormatOs::printResult(input, remark);
        EXPECT_EQ(result2, expected2);
    }

    void TestFormatOs::testPrintResultWithTwoRuns()
    {
        const std::string input = "34.45;35.12";
        const std::string empty;
        const std::string expected1 = "34.45 s + 35.12 s = 69.57 s";
        const auto result1 = FormatOs::printResult(input, empty);
        EXPECT_EQ(result1, expected1);

        const std::string remark = "WR";
        const std::string expected2 = "34.45 s + 35.12 s = 69.57 s (WR)";
        const auto result2 = FormatOs::printResult(input, remark);
        EXPECT_EQ(result2, expected2);
    }

    void TestFormatOs::testPrintResultHappyFlow()
    {
        const std::string input = "78.45";
        const std::string empty;
        const std::string expected1 = "1 min 18.45 s";
        const auto result1 = FormatOs::printResult(input, empty);
        EXPECT_EQ(result1, expected1);

        const std::string remark = "WR";
        const std::string expected2 = "1 min 18.45 s (WR)";
        const auto result2 = FormatOs::printResult(input, remark);
        EXPECT_EQ(result2, expected2);
    }

}

