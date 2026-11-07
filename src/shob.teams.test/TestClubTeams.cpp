#include "TestClubTeams.h"
#include <string>
#include <gtest/gtest.h>

#include "../shob.test.utils/testUtils.h"
#include "../shob.teams/ClubTeams.h"

namespace shob::teams::test
{
    using namespace readers::test;

    void TestClubTeams::test1()
    {
        const std::string clubs = "../../data/sport/clubs.csv";
        const std::string filename = testUtils::refFileWithPath(__FILE__, clubs);
        auto teams = ClubTeams();
        teams.InitFromFile(filename, ClubsOrCountries::clubs);
        const auto fullName = teams.expand("NLfyn");
        EXPECT_EQ(fullName, "Feyenoord");
    }
}
