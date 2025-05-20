
#pragma once

#include "footballCompetition.h"
#include <vector>

namespace shob::football
{
    class filterResults
    {
    public:
        static footballCompetition readFromCsvData(const std::vector<std::vector<std::string>>& csvData, const std::string& round);
    };

}
