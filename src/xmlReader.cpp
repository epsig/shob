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
