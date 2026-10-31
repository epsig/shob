
#include "Route2finalFactory.h"

#include "FilterResults.h"
#include "../shob.readers/csvReader.h"

namespace shob::football
{
    RouteToFfinal RouteToFinalFactory::create(const std::string& filename)
    {
        const auto data = readers::csvReader::readCsvFile(filename);
        return create(data);
    }

    RouteToFfinal RouteToFinalFactory::create(const readers::csvContent& data)
    {
        auto filter = FilterInputList();
        filter.filters.push_back({ 0, "f" });
        const auto finale = FilterResults::readFromCsvData(data, filter, "final");
        filter.filters[0].name = "2f";
        const auto semiFinal = FilterResults::readFromCsvData(data, filter, "last4");
        filter.filters[0].name = "4f";
        const auto quarterFinal = FilterResults::readFromCsvData(data, filter, "last8");
        filter.filters[0].name = "8f";
        const auto last16 = FilterResults::readFromCsvData(data, filter, "last16");
        filter.filters[0].name = "f34";
        const auto bronze = FilterResults::readFromCsvData(data, filter, "final");

        const auto r2f = RouteToFfinal(finale, semiFinal, quarterFinal, last16, bronze);
        return r2f;
    }

    RouteToFfinal RouteToFinalFactory::createEC(const readers::csvContent& data, const std::string& ECpart)
    {
        auto filter = FilterInputList();
        filter.filters.push_back({ 0, ECpart });
        filter.filters.push_back({ 1, "f" });
        const auto finale = FilterResults::readFromCsvData(data, filter, "final");
        filter.filters[1].name = "2f";
        const auto semiFinal = FilterResults::readFromCsvData(data, filter, "last4");
        filter.filters[1].name = "4f";
        const auto quarterFinal = FilterResults::readFromCsvData(data, filter, "last8");
        const auto last16 = FootballCompetition();

        const auto r2f = RouteToFfinal(finale, semiFinal, quarterFinal, last16);
        return r2f;
    }

}
