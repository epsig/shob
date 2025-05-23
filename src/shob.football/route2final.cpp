
#include "route2final.h"

namespace shob::football
{
    //     html::tableContent standings::prepareTable(const teams::clubTeams& teams, const html::settings& settings) const
    html::tableContent route2final::prepareTable(const teams::clubTeams& teams) const
    {
        auto table = html::tableContent();

        html::rowContent data;
        if ( ! final.matches.empty())
        {
            data.data = { final.matches[0].printSimple(teams) };
        }

        table.body.push_back(data);
        return table;
    }
}


