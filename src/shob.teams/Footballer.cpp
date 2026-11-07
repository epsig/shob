#include "Footballer.h"
#include "../shob.readers/CsvReader.h"

namespace shob::teams
{
    std::string Footballer::fullName() const
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

    void Footballers::initFromFile(const std::string& filename)
    {
        auto data = readers::CsvReader::readCsvFile(filename);

        for (const auto& col : data.body)
        {
            const auto& row = col.column;
            auto player = Footballer();
            player.firstName = row[1];
            player.insertion = row[2];
            player.lastName = row[3];
            all.insert({ row[0], player });
        }
    }

    std::string Footballers::expand(const std::string& name) const
    {
        const auto it = all.find(name);
        if (it != all.end())
        {
            return it->second.fullName();
        }
        return name;
    }

}
