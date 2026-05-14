
#include "FormatNL_Factory.h"

#include "../shob.general/glob.h"
#include "TopMenu.h"

namespace shob::pages
{
    // TODO move to string utils
    void replace_first(
        std::string& s,
        std::string const& toReplace,
        std::string const& replaceWith
    ) {
        std::size_t pos = s.find(toReplace);
        if (pos == std::string::npos) return;
        s.replace(pos, toReplace.length(), replaceWith);
    }

    FormatNL format_nl_factory::build(const std::string& dataFolder, const html::settings& settings)
    {
        auto extras = readers::csvAllSeasonsReader();
        extras.init(dataFolder + "/eredivisie/eredivisie_u2s.csv");

        auto remarks = readers::csvAllSeasonsReader();
        remarks.init(dataFolder + "/eredivisie/eredivisie_remarks.csv");

        auto archive = general::glob::list(dataFolder + "/eredivisie", "eredivisie_[0-9].*csv");
        archive.erase(archive.begin()); // there is one more csv input file than html output
        for (auto& row : archive)
        {
            replace_first(row, "eredivisie", "nl");
        }
        auto menu = TopMenu(archive, 'K');

        auto teams = teams::clubTeams();
        auto file2 = dataFolder + "/clubs.csv";
        teams.InitFromFile(file2, teams::clubsOrCountries::clubs);

        auto format = FormatNL(dataFolder, extras, remarks, menu, teams, settings);
        return format;
    }
}
