
#pragma once

#include "footballCompetition.h"
#include "../shob.readers/csvReader.h"
#include <vector>

namespace shob::football
{
    class filterResults
    {
    public:
        static footballCompetition readFromCsvData(const readers::csvContent& csvData, const std::string& round);
    private:
        static starEnum getStar(const std::vector<std::string>& line, size_t index);
    };

}
