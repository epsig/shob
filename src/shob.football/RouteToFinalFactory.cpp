#include "RouteToFinalFactory.h"

#include "FilterResults.h"
#include "../shob.readers/CsvReader.h"

namespace shob::football
{
    RouteToFinal RouteToFinalFactory::create(const std::string& filename)
    {
        const auto data = readers::CsvReader::readCsvFile(filename);
        return create(data);
    }

    RouteToFinal RouteToFinalFactory::create(const readers::CsvContent& data)
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

        const auto r2f = RouteToFinal(finale, semiFinal, quarterFinal, last16, bronze);
        return r2f;
    }

    RouteToFinal RouteToFinalFactory::createEC(const readers::CsvContent& data, const std::string& ECpart)
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

        const auto r2f = RouteToFinal(finale, semiFinal, quarterFinal, last16);
        return r2f;
    }

}
