
#include "format_nl_factory.h"

namespace shob::pages
{
    format_nl format_nl_factory::build(const std::string& dataFolder)
    {
        auto extras = readers::csvAllSeasonsReader();
        extras.init(dataFolder + "/eredivisie/eredivisie_u2s.csv");

        auto remarks = readers::csvAllSeasonsReader();
        remarks.init(dataFolder + "/eredivisie/eredivisie_remarks.csv");

        auto format = format_nl(dataFolder, extras, remarks);
        return format;
    }
}
