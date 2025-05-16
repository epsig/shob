
#include "topscorers.h"

namespace shob::football
{
    void topscorers::initFromFile(const std::string& season)
    {
        auto data = reader.getSeason(season);

        for (size_t i = 1; i < data.size(); i++)
        {
            const auto& row = data[i];
            auto tp = topscorer();
            tp.rank = std::stoi(row[0]);
            tp.name = row[1];
            tp.club = row[2];
            tp.goals = std::stoi(row[3]);
            list_tp.push_back(tp);
        }
    }
}


