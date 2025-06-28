
#include "testSeason.h"
#include "../shob.general/season.h"
#include <gtest/gtest.h>

namespace shob::general::test
{
    void testSeason::test1()
    {
        const auto season = general::season(2020);
        const auto str = season.to_string();
        ASSERT_EQ(str, "2020-2021");
    }

    void testSeason::test2()
    {
        const auto season = general::season(2020);
        const auto str = season.to_part_filename();
        ASSERT_EQ(str, "2020_2021");
    }
}
