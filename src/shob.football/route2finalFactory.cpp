
#include "route2finalFactory.h"

#include "filterResults.h"
#include "../shob.readers/csvReader.h"

namespace shob::football
{
    route2final route2finaleFactory::create(const std::string& filename)
    {
        const auto data = readers::csvReader::readCsvFile(filename);

        const auto finale = filterResults::readFromCsvData(data, "f");
        const auto semiFinal = filterResults::readFromCsvData(data, "2f");
        const auto quarterFinal = filterResults::readFromCsvData(data, "4f");
        const auto last16 = filterResults::readFromCsvData(data, "8f");

        const auto r2f = route2final(finale, semiFinal, quarterFinal, last16);
        return r2f;
    };

}
