
#include "TestFormatOs.h"

#include <gtest/gtest.h>

#include "../shob.html/settings.h"
#include "../shob.pages/FormatOsFactory.h"
#include "../shob.test.utils/testUtils.h"

namespace shob::pages::test
{
    using namespace readers::test;

    const std::string dataMap = "../../data/sport/schaatsen/";
    const std::string dataFolder = testUtils::refFileWithPath(__FILE__, dataMap);
    const html::settings settings = html::settings();
    const auto fmt_os = FormatOsFactory::build(dataFolder, settings);

    void TestFormatOs::test_os_2002()
    {
        const auto lines = fmt_os.get_pages(2002);
        ASSERT_EQ(lines.data.size(), 205);
        EXPECT_GE(lines.findString("Salt Lake City"), 0);
        EXPECT_GE(lines.findString("Jochem Uytdehaage"), 0);
        EXPECT_GE(lines.findString("Marianne Timmer"), 0);
    }

    void TestFormatOs::test_print_result_points()
    {
        const std::string input = "63 p";
        const std::string empty;
        auto result1 = FormatOs::print_result(input, empty);
        EXPECT_EQ(result1, input);

        const std::string remark = "WR";
        const std::string expected = "63 p (WR)";
        auto result2 = FormatOs::print_result(input, remark);
        EXPECT_EQ(result2, expected);
    }

    void TestFormatOs::test_print_result_with_colon()
    {
        const std::string input = "6:12.34";
        const std::string empty;
        const std::string expected1 = "6 min 12.34 s";
        auto result1 = FormatOs::print_result(input, empty);
        EXPECT_EQ(result1, expected1);

        const std::string remark = "WR";
        const std::string expected2 = "6 min 12.34 s (WR)";
        auto result2 = FormatOs::print_result(input, remark);
        EXPECT_EQ(result2, expected2);
    }

    void TestFormatOs::test_print_result_with_two_runs()
    {
        const std::string input = "34.45;35.12";
        const std::string empty;
        const std::string expected1 = "34.45 s + 35.12 s = 69.57 s";
        auto result1 = FormatOs::print_result(input, empty);
        EXPECT_EQ(result1, expected1);

        const std::string remark = "WR";
        const std::string expected2 = "34.45 s + 35.12 s = 69.57 s (WR)";
        auto result2 = FormatOs::print_result(input, remark);
        EXPECT_EQ(result2, expected2);
    }

    void TestFormatOs::test_print_result_happy_flow()
    {
        const std::string input = "78.45";
        const std::string empty;
        const std::string expected1 = "1 min 18.45 s";
        auto result1 = FormatOs::print_result(input, empty);
        EXPECT_EQ(result1, expected1);

        const std::string remark = "WR";
        const std::string expected2 = "1 min 18.45 s (WR)";
        auto result2 = FormatOs::print_result(input, remark);
        EXPECT_EQ(result2, expected2);
    }

}

