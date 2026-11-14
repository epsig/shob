#pragma once

#include "FilterInput.h"
#include "FootballCompetition.h"
#include "../shob.readers/CsvReader.h"

namespace shob::football
{
    class FilterResults
    {
    public:
        static FootballCompetition readFromCsvData(const readers::CsvContent& csvData, const FilterInputList& filter, const std::string& ko_phase = "");
    private:
        static StarEnum getStar(const std::vector<std::string>& line, size_t index);
    };

}
