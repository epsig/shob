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

Game loadChronological(const std::string& file)
{
    boost::property_tree::ptree pt;
    read_xml(file, pt);

    Game game;

    for (const auto& i : pt.get_child("games.group_phase.groupA.CH_NL.stats.chronological"))
    {
        std::string name;
        boost::property_tree::ptree sub_pt;
        std::tie(name, sub_pt) = i;

        Goal goal;
        goal.min = sub_pt.get<std::string>("<xmlattr>.min");
        goal.score = sub_pt.data();
        game.data.push_back(goal);
    }

    return game;
}
