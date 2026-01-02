
#include "FormatOs.h"
#include "head_bottum.h"
#include "../shob.html/updateIfNewer.h"
#include "../shob.html/funcs.h"
#include "../shob.general/shobException.h"
#include <format>
#include <iostream>

namespace shob::pages
{
    format_os::format_os(std::string folder, readers::csvAllSeasonsReader reader, readers::csvContent dames,
        readers::csvContent heren, topMenu menu, teams::nationalTeams teams, html::settings settings) :
        folder(std::move(folder)), seasons_reader(std::move(reader)),
        dames(std::move(dames)), heren(std::move(heren)), menu(std::move(menu)), land_codes(std::move(teams)), settings(settings) {  }

    void format_os::get_pages_to_file(const int year, const std::string& filename) const
    {
        auto output = get_pages(year);
        html::updateIfDifferent::update(filename, output);
    }

    void format_os::get_pages_stdout(const int year) const
    {
        const auto output = get_pages(year);
        for (const auto& row : output.data)
        {
            std::cout << row << '\n';
        }
        std::cout.flush();
    }

    general::multipleStrings format_os::get_pages(const int year) const
    {
        auto retVal = general::multipleStrings();
        if (settings.lang == html::language::English)
        {
            retVal.addContent("<hr> other Winter Olympics: |");
        }
        else
        {
            retVal.addContent("<hr> andere winterspelen: |");
        }
        auto topMenu = menu.getMenu(std::to_string(year));
        retVal.addContent(topMenu);
        retVal.addContent("<hr>");

        const auto remarks = seasons_reader.getSeason( std::to_string(year));

        const auto allData = read_matches_data(year);

        auto part1 = get_numbers_one(allData);
        retVal.addContent(part1);

        auto part2 = get_all_distances('H', allData);
        retVal.addContent(part2);

        auto part3 = get_all_distances('D', allData);
        retVal.addContent(part3);

        auto hb = headBottumInput(findDate(remarks));
        hb.title = findTitle(remarks);
        std::swap(hb.body, retVal);

        return headBottum::getPage(hb);
    }

    readers::csvContent format_os::read_matches_data(const int year) const
    {
        const auto csvInput = std::format("{}/OS_{}.csv", folder, year);
        const auto csvData = readers::csvReader::readCsvFile(csvInput);
        return csvData;
    }

    general::multipleStrings format_os::get_numbers_one(const readers::csvContent& allData) const
    {
        auto retVal = general::multipleStrings();
        html::tableContent content;
        if (settings.lang == html::language::English)
        {
            content.header.data = { "distance", "name", "time" };
            content.title = "Golden medal winners";
        }
        else
        {
            content.header.data = { "afstand", "naam", "tijd" };
            content.title = "Gouden medaille winnaars";
        }

        const auto DH_Column = allData.findColumn("DH");
        const auto distanceColumn = allData.findColumn("distance");
        const auto rankingColumn = allData.findColumn("ranking");
        const auto nameColumn = allData.findColumn("name");
        const auto teamColumn = allData.findColumn("team");
        const auto resultColumn = allData.findColumn("result");
        const auto remarkColumn = allData.findColumn("remark");

        for (const auto& row : allData.body)
        {
            const auto rank = row.column[rankingColumn];
            if (rank == "1")
            {
                const auto DH = row.column[DH_Column];
                const auto distance = row.column[distanceColumn];
                const auto name = row.column[nameColumn];
                const auto team = (teamColumn < row.column.size() ? row.column[teamColumn] : "");
                const auto country = name.substr(0, 2);
                const auto full_name = (DH == "D" ? findName(name, dames) : findName(name, heren));
                const auto land_code_and_name = html::funcs::acronym(country, land_codes.expand(country));
                std::string name_with_country;
                if (team.empty())
                {
                    name_with_country = std::format("{} ({})", full_name, land_code_and_name);
                }
                else
                {
                    name_with_country = land_codes.expand(country) + " (" + adj_team(team) + ")";
                }
                const auto time = row.column[resultColumn];
                const auto linkName = std::format("{}{}", DH, distance);
                const auto description = std::format("{} - {}", DH, distance);
                const auto link = "<a href=\"#" + linkName + "\">" + description + "</a>";
                general::multipleStrings body;
                const auto remark = (remarkColumn < row.column.size() ? row.column[remarkColumn] : "");
                body.data = { link, name_with_country, print_result(time, remark)};
                content.body.push_back(body);
            }
        }
        const auto Table = html::table(settings);
        auto table = Table.buildTable(content);
        retVal.addContent(table);
        return retVal;
    }

    general::multipleStrings format_os::get_one_distance(const std::string& distance, const char DH, const readers::csvContent& allData) const
    {
        auto retVal = general::multipleStrings();
        retVal.addContent(std::format("<p/> <a name=\"{}{}\">", DH, distance));
        html::tableContent content;

        const auto DH_Column = allData.findColumn("DH");
        const auto distanceColumn = allData.findColumn("distance");
        const auto rankingColumn = allData.findColumn("ranking");
        const auto nameColumn = allData.findColumn("name");
        const auto teamColumn = allData.findColumn("team");
        const auto resultColumn = allData.findColumn("result");
        const auto remarkColumn = allData.findColumn("remark");

        bool found_points = false;
        for (const auto& row : allData.body)
        {
            const auto cur_DH = row.column[DH_Column];
            const auto cur_distance = row.column[distanceColumn];
            if (cur_DH.find(DH) != std::string::npos && cur_distance == distance)
            {
                auto rank = row.column[rankingColumn];
                const auto name = row.column[nameColumn];
                const auto team = (teamColumn < row.column.size() ? row.column[teamColumn] : "");
                const auto country = name.substr(0, 2);
                const auto full_name = (DH == 'D' ? findName(name, dames) : findName(name, heren));
                const auto land_code_and_name = html::funcs::acronym(country, land_codes.expand(country));
                std::string name_with_country;
                if (team.empty())
                {
                    name_with_country = std::format("{} ({})", full_name, land_code_and_name);
                }
                else
                {
                    name_with_country = land_codes.expand(country) + " (" + adj_team(team) + ")";
                }
                const auto time = row.column[resultColumn];
                if (time.ends_with(" p")) found_points = true;
                general::multipleStrings body;
                if (rank == "-1") { rank = ""; }
                const auto remark = (remarkColumn < row.column.size() ? row.column[remarkColumn] : "");
                body.data = { rank, name_with_country, print_result(time, remark) };
                content.body.push_back(body);
            }
        }

        if (settings.lang == html::language::English)
        {
            content.header.data = { "rank", "name", found_points ? "points" : "time" };
            content.title = distance + " " + (DH == 'H' ? "men" : "woman");
        }
        else
        {
            content.header.data = { "rank", "naam", found_points ? "punten" : "tijd" };
            content.title = distance + " " + (DH == 'H' ? "Heren" : "Dames");
        }

        const auto Table = html::table(settings);
        auto table = Table.buildTable(content);
        retVal.addContent(table);
        return retVal;
    }

    general::multipleStrings format_os::get_all_distances(const char DH, const readers::csvContent& allData) const
    {
        auto retVal = general::multipleStrings();
        const auto distances = find_distances(DH, allData);
        for (const auto& distance : distances)
        {
            auto d = get_one_distance(distance, DH, allData);
            retVal.addContent(d);
        }
        return retVal;
    }

    std::string format_os::findName(const std::string& name, const readers::csvContent& listNames)
    {
        for (const auto& row : listNames.body)
        {
            if (row.column[0] == name) return row.column[1];
        }
        return name;
    }

    int format_os::findDate(const std::vector<std::vector<std::string>>& remarks)
    {
        for (const auto& row : remarks)
        {
            if (row[0] == "dd") return std::stoi(row[1]);
        }
        throw general::shobException("Date not found in remarks");
    }

    std::string format_os::findTitle(const std::vector<std::vector<std::string>>& remarks)
    {
        for (const auto& row : remarks)
        {
            if (row[0] == "title") return row[1];
        }
        return "";
    }

    std::vector<std::string> format_os::find_distances(const char DH, const readers::csvContent& allData)
    {
        auto retVal = std::vector<std::string>();
        std::string previous;
        for (const auto& row : allData.body)
        {
            if (row.column[0].find(DH) != std::string::npos)
            {
                if (row.column[1] != previous)
                {
                    previous = row.column[1];
                    retVal.push_back(row.column[1]);
                }
            }
        }
        return retVal;
    }

    std::string format_os::print_result(const std::string& stime, const std::string& remark)
    {
        const auto remark_with_par = remark.empty() ? "" : " (" + remark + ")";
        const auto pos_colon = stime.find(':');
        if (stime.ends_with(" p"))
        {
            return stime + remark_with_par;
        }
        else if (pos_colon != std::string::npos)
        {
            auto minutes = stime.substr(0, pos_colon);
            auto seconds = stime.substr(1+pos_colon, 5);
            return std::format("{} min {} s{}", minutes, seconds, remark_with_par);
        }
        else if (stime.find(';') != std::string::npos)
        {
            const auto stimes = readers::csvReader::split(stime, ";");
            const auto first_500m = stimes.column[0];
            const auto second_500m = stimes.column[1];
            const auto parts1 = readers::csvReader::split(first_500m, " ");
            const auto parts2 = readers::csvReader::split(second_500m, " ");
            const auto remark1 = (parts1.column.size() > 1 ? " (" + parts1.column[1] + ")" : "");
            const auto remark2 = (parts2.column.size() > 1 ? " (" + parts2.column[1] + ")" : "");
            try
            {
                const auto sum = std::stod(parts1.column[0]) + std::stod(parts2.column[0]);
                return std::format("{} s{} + {} s{} = {:.2f} s{}", parts1.column[0], remark1, parts2.column[0], remark2, sum, remark_with_par);
            }
            catch (const std::exception&)
            {
                return std::format("{} ; {}{}", first_500m, second_500m, remark_with_par);
            }
        }
        try
        {
            const auto time = std::stod(stime);
            const auto minutes = static_cast<int>(time) / 60;
            const auto seconds = time - 60.0 * static_cast<double>(minutes);
            if (minutes > 0)
            {
                return std::format("{} min {:05.2f} s{}", minutes, seconds, remark_with_par);
            }
            else
            {
                return std::format("{} s{}", stime, remark_with_par);
            }
        }
        catch (const std::exception&)
        {
            return stime;
        }
    }

    std::string format_os::adj_team(const std::string& team)
    {
        auto retVal = team;
        for (size_t i = 0; i < retVal.size(); i++)
        {
            if (retVal.find("; ") == i)
            {
                retVal.replace(i, 1, ",");
            }
        }
        return retVal;
    }

}
