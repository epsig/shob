
#include "wns_ec.h"

namespace shob::pages
{
    int wns_ec::getWns(const std::string& part, const std::string& group, const football::footballCompetition& matches) const
    {
        if (groups.contains(group))
        {
            return groups.at(group);
        }
        else if (wns_cf != -1 && part == "CF")
        {
            return wns_cf;
        }
        else if (wns_cl != -1)
        {
            return wns_cl;
        }
        else if (matches.matches.size() == 12)
        {
            return (part == "CL" && group.find('2') == std::string::npos ? 2 : 1);
        }
        else if (matches.matches.size() == 10 && part == "UEFAcup")
        {
            return 5;
        }
        else
        {
            return wns_cl;
        }
    }

}

