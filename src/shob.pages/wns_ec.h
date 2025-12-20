
#pragma once
#include <string>
#include <map>
#include "../shob.football/footballCompetition.h"

namespace shob::pages
{
    class wns_ec
    {
    public:
        int wns_cl;
        int wns_cf;
        int scoring;
        std::map<std::string, int> groups;
        int getWns(const std::string& part, const std::string& group, const football::footballCompetition& matches) const;
    };

}
