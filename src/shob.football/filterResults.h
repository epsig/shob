
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

    class filterInputList
    {
    public:
        std::vector<filterInput> data;
        bool isFinale() const;
        bool checkLine(const readers::csvColContent& col) const;
    };

    class filterResults
    {
    public:
        static footballCompetition readFromCsvData(const readers::csvContent& csvData, const filterInputList& filter);
    private:
        static starEnum getStar(const std::vector<std::string>& line, size_t index);
    };

}
