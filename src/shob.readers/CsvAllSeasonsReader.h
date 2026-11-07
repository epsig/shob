#pragma once

#include <string>
#include <vector>
#include <map>
#include "../shob.readers/CsvReader.h"
#include "../shob.general/Season.h"

namespace shob::readers
{
    class CsvAllSeasonsReader
    {
    public:
        void init(const std::string& filename);
        std::vector<std::vector<std::string>> getSeason(const general::Season& season) const;
        std::vector<std::vector<std::string>> getSeason(const std::string& id) const;
        std::map<std::string, std::string> getAll(const std::string& id) const;
    private:
        CsvContent allData;
    };
}
