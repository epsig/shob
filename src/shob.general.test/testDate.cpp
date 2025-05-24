
#include "testDate.h"
#include "../shob.general/itdate.h"
#include <gtest/gtest.h>

#include "../shob.general/shobException.h"

namespace shob::general::test
{
    void testDate::testItdateToString()
    {
        const auto date = itdate(20250524);
        const auto str = date.toShortString();
        ASSERT_EQ(str, "24 mei");
    }

    void testDate::testErrorHandling()
    {
        const auto date = itdate(20251524); // invalid month
        const auto str = date.toShortString();
        ASSERT_EQ(str, "*****");
    }

    void testDate::testErrorHandlingMaxDays()
    {
        std::string msg;
        try
        {
            auto mxdays = shobDate::maxDays(2025, 15);
            ASSERT_EQ(mxdays, 0) << "note that this line is unreachable";
        }
        catch (const shobException& e)
        {
            msg = e.what();
        }
        ASSERT_EQ(msg, "Invalid month number: 15");
    }

    void testDate::testIsLeapYear()
    {
        const auto isLeap1 = shobDate::isLeapYear(2000);
        ASSERT_TRUE(isLeap1);
        const auto isLeap2 = shobDate::isLeapYear(2025);
        ASSERT_FALSE(isLeap2);
        const auto isLeap3 = shobDate::isLeapYear(1900);
        ASSERT_FALSE(isLeap3);
        const auto isLeap4 = shobDate::isLeapYear(2020);
        ASSERT_TRUE(isLeap4);
    }

    void testDate::testMaxDays()
    {
        const auto maxDays1 = shobDate::maxDays(2025, 2);
        ASSERT_EQ(maxDays1, 28);
        const auto maxDays2 = shobDate::maxDays(2025, 5);
        ASSERT_EQ(maxDays2, 31);
        const auto maxDays3 = shobDate::maxDays(2028, 2);
        ASSERT_EQ(maxDays3, 29);
    }

}
