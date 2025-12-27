
#include "format_os_factory.h"

namespace shob::pages
{
    using namespace shob::readers;

    format_os format_os_factory::build(const std::string& folder, const html::settings& settings)
    {
        auto remarks = csvAllSeasonsReader();
        remarks.init(folder + "schaatsen_remarks.csv");

        const auto dames = csvReader::readCsvFile(folder + "schaatsersD.csv");
        const auto heren = csvReader::readCsvFile(folder + "schaatsersH.csv");

        auto os = format_os(folder, remarks, dames, heren, settings);
        return os;
    }
}

