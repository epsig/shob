
#include "testSeason.h"
#include "../shob.general/Season.h"
#include <gtest/gtest.h>

namespace shob::general::test
{
    void testSeason::test1()
    {
        const auto season = general::Season(2020);
        const auto str = season.toString();
        ASSERT_EQ(str, "2020-2021");
    }

    void testSeason::test2()
    {
        const auto season = general::Season(2020);
        const auto str = season.toPartFilename();
        ASSERT_EQ(str, "2020_2021");
    }
}
