
#pragma once
#include <string>
#include <vector>
#include "../shob.readers/csvReader.h"

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
}
