#include "xmlReader.h"

#include <boost/property_tree/ptree.hpp>
#include <boost/property_tree/xml_parser.hpp>

namespace shob::readers
{
    xmlReader::xmlReader(const std::string& file)
    {
        read_xml(file, pt);
    }

    std::vector<std::pair<std::string, std::string>> xmlReader:: loadPairs(const std::string& path, const std::string& attr)
    {
        std::vector<std::pair<std::string, std::string>> Pairs;

        auto check = pt.get_child_optional(path);
        if (!check) return Pairs;

        for (const auto& i : check.value())
        {
            const auto& sub_pt = i.second;
            const auto first = sub_pt.get<std::string>("<xmlattr>." + attr);
            const auto second = sub_pt.data();
            Pairs.emplace_back(first, second);
        }

        return Pairs;
    }

    std::string xmlReader::loadSingleValue(const std::string& path)
    {
        auto check = pt.get_child_optional(path);
        if (!check) return "";

        auto x = check->get_value<std::string>();

        return x;
    }

}

