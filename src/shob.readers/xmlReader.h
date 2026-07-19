#pragma once

#include <string>
#include <vector>
#include <boost/property_tree/ptree.hpp>

namespace shob::readers
{
    class xmlReader
    {
    public:
        xmlReader() = default;
        xmlReader(const std::string& file);
        std::vector<std::pair<std::string, std::string>> loadPairs(const std::string& path, const std::string& attr);
        std::string loadSingleValue(const std::string& path);
    private:
        boost::property_tree::ptree pt;
    };
}

