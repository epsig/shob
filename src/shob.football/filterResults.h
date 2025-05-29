
#pragma once

#include "footballCompetition.h"
#include "../shob.readers/csvReader.h"
#include <vector>

namespace shob::football
{
    struct filterInput
    {
        size_t rowIndex;
        std::string name;
    };

    struct filterInputList
    {
        std::vector<filterInput> data;
    };

    class filterResults
    {
    public:
        static footballCompetition readFromCsvData(const readers::csvContent& csvData, const filterInputList& filter);
    private:
        static bool checkLine(const readers::csvColContent& col, const filterInputList& filter);
        static starEnum getStar(const std::vector<std::string>& line, size_t index);
        static bool isFinale(const filterInputList& filter);
    };

}
