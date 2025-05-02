
#pragma once

#include <string>
#include <vector>

namespace shob::readers
{
    class csvAllSeasonsReader
    {
    public:
        void init(const std::string& filename);
        std::vector<std::vector<std::string>> getSeason(const std::string& season) const;
    private:
        std::vector<std::vector<std::string>> allData;
        std::vector<std::string> header;
    };

}

