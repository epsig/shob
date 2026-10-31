
#pragma once

#include "filterInput.h"
#include "footballCompetition.h"
#include "../shob.readers/csvReader.h"

namespace shob::football
{
    class FilterResults
    {
    public:
        static FootballCompetition readFromCsvData(const readers::csvContent& csvData, const FilterInputList& filter, const std::string& ko_phase = "");
    private:
        static StarEnum getStar(const std::vector<std::string>& line, size_t index);
    };

}
