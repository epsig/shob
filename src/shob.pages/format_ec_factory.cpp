
#include "format_ec_factory.h"

namespace shob::pages
{
    format_ec format_ec_factory::build(const std::string& dataFolder)
    {
        auto extras = readers::csvAllSeasonsReader();
        extras.init(dataFolder + "/europacup/europacup_u2s.csv");

        auto format = format_ec(dataFolder, extras);
        return format;
    }
}
