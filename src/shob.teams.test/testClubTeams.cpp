
#include "testClubTeams.h"
#include <string>
#include <gtest/gtest.h>

#include "../shob.general.test/testUtils.h"
#include "../shob.teams/clubTeams.h"

namespace shob::teams::test
{
    using namespace readers::test;

    void testClubTeams::test1()
    {
        const std::string clubs = "../../data/sport/clubs.csv";
        const std::string filename = testUtils::refFileWithPath(__FILE__, clubs);
        auto teams = clubTeams();
        teams.InitFromFile(filename);
        const auto fullName = teams.expand("NLfyn");
        EXPECT_EQ(fullName, "Feyenoord");
    }
}


