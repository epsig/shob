
#pragma once

#include "filterInput.h"
#include "footballCompetition.h"
#include "../shob.readers/csvReader.h"

namespace shob::football
{
    class filterResults
    {
    public:
        static footballCompetition readFromCsvData(const readers::csvContent& csvData, const filterInputList& filter, const std::string& ko_phase = "");
    private:
        static starEnum getStar(const std::vector<std::string>& line, size_t index);
    };

}
