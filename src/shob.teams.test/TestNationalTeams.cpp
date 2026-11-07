#include "TestNationalTeams.h"
#include <string>
#include <gtest/gtest.h>

#include "../shob.test.utils/testUtils.h"
#include "../shob.teams/NationalTeams.h"

namespace shob::teams::test
{
    using namespace readers::test;

    void TestNationalTeams::test1()
    {
        const std::string landcodes = "../../data/sport/landcodes.csv";
        const std::string filename = testUtils::refFileWithPath(__FILE__, landcodes);
        auto countries = NationalTeams();
        countries.InitFromFile(filename);
        const auto fullName = countries.expand("NL");
        EXPECT_EQ(fullName, "Nederland");
    }
}
