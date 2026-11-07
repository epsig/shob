#include "TestDate.h"
#include "../shob.general/ItDate.h"
#include <gtest/gtest.h>

#include "../shob.general/ShobException.h"

namespace shob::general::test
{
    void TestDate::testItdateToString()
    {
        const auto date = ItDate(20250524);
        const auto str = date.toShortString();
        ASSERT_EQ(str, "24 mei");
    }

    void TestDate::testErrorHandling()
    {
        const auto date = ItDate(20251524); // invalid month
        const auto str = date.toShortString();
        ASSERT_EQ(str, "*****");
    }

    void TestDate::testErrorHandlingMaxDays()
    {
        std::string msg;
        try
        {
            auto mxdays = ShobDate::maxDays(2025, 15);
            ASSERT_EQ(mxdays, 0) << "note that this line is unreachable";
        }
        catch (const ShobException& e)
        {
            msg = e.what();
        }
        ASSERT_EQ(msg, "Invalid month number: 15");
    }

    void TestDate::testIsLeapYear()
    {
        const auto isLeap1 = ShobDate::isLeapYear(2000);
        ASSERT_TRUE(isLeap1);
        const auto isLeap2 = ShobDate::isLeapYear(2025);
        ASSERT_FALSE(isLeap2);
        const auto isLeap3 = ShobDate::isLeapYear(1900);
        ASSERT_FALSE(isLeap3);
        const auto isLeap4 = ShobDate::isLeapYear(2020);
        ASSERT_TRUE(isLeap4);
    }

    void TestDate::testMaxDays()
    {
        const auto maxDays1 = ShobDate::maxDays(2025, 2);
        ASSERT_EQ(maxDays1, 28);
        const auto maxDays2 = ShobDate::maxDays(2025, 5);
        ASSERT_EQ(maxDays2, 31);
        const auto maxDays3 = ShobDate::maxDays(2028, 2);
        ASSERT_EQ(maxDays3, 29);
    }

}
