
#include "route2finalFactory.h"

#include "filterResults.h"
#include "../shob.readers/csvReader.h"

namespace shob::football
{
    route2final route2finaleFactory::create(const std::string& filename)
    {
        const auto data = readers::csvReader::readCsvFile(filename);

        auto filter = filterInputList();
        filter.filters.push_back({ 0, "f" });
        const auto finale = filterResults::readFromCsvData(data, filter);
        filter.filters[0].name = "2f";
        const auto semiFinal = filterResults::readFromCsvData(data, filter);
        filter.filters[0].name = "4f";
        const auto quarterFinal = filterResults::readFromCsvData(data, filter);
        filter.filters[0].name = "8f";
        const auto last16 = filterResults::readFromCsvData(data, filter);

        const auto r2f = route2final(finale, semiFinal, quarterFinal, last16);
        return r2f;
    }

    route2final route2finaleFactory::createEC(const readers::csvContent& data, const std::string& ECpart)
    {
        auto filter = filterInputList();
        filter.filters.push_back({ 0, ECpart });
        filter.filters.push_back({ 1, "f" });
        const auto finale = filterResults::readFromCsvData(data, filter);
        filter.filters[1].name = "2f";
        const auto semiFinal = filterResults::readFromCsvData(data, filter);
        filter.filters[1].name = "4f";
        const auto quarterFinal = filterResults::readFromCsvData(data, filter);
        filter.filters[1].name = "8f";
        const auto last16 = filterResults::readFromCsvData(data, filter);

        const auto r2f = route2final(finale, semiFinal, quarterFinal, last16);
        return r2f;
    }

}
