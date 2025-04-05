
#pragma once

#include <string>
#include <vector>

namespace shob::readers
{
    class csvReader
    {
    public:
        static std::vector<std::vector<std::string>> readCsvFile(const std::string& filename);
    };

}

