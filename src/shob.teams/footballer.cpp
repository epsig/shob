
#include "footballer.h"
#include "../shob.readers/csvReader.h"

namespace shob::teams
{
    std::string footballer::fullName() const
    {
        if (insertion.empty())
        {
            return firstName + " " + lastName;
        }
        else
        {
            return firstName + " " + insertion + " " + lastName;
        }
    }

    void footballers::initFromFile(const std::string& filename)
    {
        auto data = readers::csvReader::readCsvFile(filename);

        for (const auto& col : data.body)
        {
            const auto& row = col.column;
            auto player = footballer();
            player.firstName = row[1];
            player.insertion = row[2];
            player.lastName = row[3];
            all.insert({ row[0], player });
        }
    }

    std::string footballers::expand(const std::string& name) const
    {
        if (all.contains(name))
        {
            return all.at(name).fullName();
        }
        return name;
    }

}
