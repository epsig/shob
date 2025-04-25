#include "xmlReader.h"

#include <boost/property_tree/ptree.hpp>
#include <boost/property_tree/xml_parser.hpp>
#include <boost/foreach.hpp>

Catowner load(const std::string &file)
{
    boost::property_tree::ptree pt;
    read_xml(file, pt);

    Catowner co;

    co.owner = pt.get<std::string>("main.owner");

    BOOST_FOREACH(
       boost::property_tree::ptree::value_type &v,
       pt.get_child("main.cats"))
       co.cats.insert(v.second.data());

    return co;
}

std::vector<std::pair<std::string,std::string>> loadPairs(const std::string& file, const std::string& path, const std::string& attr)
{
    boost::property_tree::ptree pt;
    read_xml(file, pt);

    std::vector<std::pair<std::string, std::string>> Pairs;

    for (const auto& i : pt.get_child(path))
    {
        const auto & sub_pt = i.second;
        const auto first = sub_pt.get<std::string>("<xmlattr>." + attr);
        const auto second = sub_pt.data();
        Pairs.emplace_back(first, second);
    }

    return Pairs;
}
