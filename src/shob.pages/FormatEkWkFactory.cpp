
#include "FormatEkWkFactory.h"

namespace shob::pages
{
    FormatEkWk FormatEkWkFactory::build(const std::string& dataFolder, const html::settings& settings)
    {
        auto remarks = readers::csvAllSeasonsReader();
        remarks.init(dataFolder + "/ekwk_remarks.csv");

        auto topScorers = readers::csvAllSeasonsReader();
        topScorers.init(dataFolder + "/topscorers_ekwk.csv");

        auto retval = FormatEkWk(dataFolder, settings, remarks, topScorers);
        return retval;
    }
}
