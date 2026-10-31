
#pragma once
#include <string>
#include <vector>
#include "../shob.readers/csvReader.h"

namespace shob::football
{
    struct FilterInput
    {
        size_t rowIndex;
        std::string name;
    };

    class FilterInputList
    {
    public:
        std::vector<FilterInput> filters;
        bool isFinale() const;
        bool checkLine(const readers::csvColContent& col) const;
    };
}
