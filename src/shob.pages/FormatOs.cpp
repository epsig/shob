
#include "FormatOs.h"
#include "HeadBottom.h"
#include "../shob.html/funcs.h"
#include "../shob.general/shobException.h"
#include <format>

namespace shob::pages
{
    FormatOs::FormatOs(std::string folder, readers::csvAllSeasonsReader reader, readers::csvContent dames,
        readers::csvContent heren, TopMenu menu, teams::nationalTeams teams, html::settings settings) :
        folder(std::move(folder)), seasons_reader(std::move(reader)),
        dames(std::move(dames)), heren(std::move(heren)), menu(std::move(menu)), land_codes(std::move(teams)), settings(settings) {  }

    bool FormatOs::isValidYear(const int year) const
    {
        return year % 4 == 2 && year < 2026;
    }

    std::string FormatOs::getOutputFilename(const std::string& output_folder, const int year) const
    {
        return std::format("{}/sport_schaatsen_OS_{}.html", output_folder, year);
    }

    std::string FormatOs::getOutputFilename(const std::string& folder) const
    {
        return "";
    }

    int FormatOs::getLastYear() const
    {
        return 2022; // TODO make function of available csv input files
    }

    general::MultipleStrings FormatOs::getPages(const int year) const
    {
        auto return_value = general::MultipleStrings();
        if (settings.lang == html::language::English)
        {
            return_value.addContent("<hr> other Winter Olympics: |");
        }
        else
        {
            return_value.addContent("<hr> andere winterspelen: |");
        }
        auto topMenu = menu.getMenu(std::to_string(year));
        return_value.addContent(topMenu);
        return_value.addContent("<hr>");

        const auto remarks = seasons_reader.getSeason( std::to_string(year));

        const auto allData = readMatchesData(year);

        auto part1 = getNumbersOne(allData);
        return_value.addContent(part1);

        auto part2 = getAllDistances('H', allData);
        return_value.addContent(part2);

        auto part3 = getAllDistances('D', allData);
        return_value.addContent(part3);

        auto hb = HeadBottomInput(findDate(remarks));
        hb.title = findTitle(remarks);
        std::swap(hb.body, return_value);

        return HeadBottom::getPage(hb);
    }

    readers::csvContent FormatOs::readMatchesData(const int year) const
    {
        const auto csv_input = std::format("{}/OS_{}.csv", folder, year);
        const auto csv_data = readers::csvReader::readCsvFile(csv_input);
        return csv_data;
    }

    general::MultipleStrings FormatOs::getNumbersOne(const readers::csvContent& all_data) const
    {
        auto return_value = general::MultipleStrings();
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

        const auto gender_column = all_data.findColumn("DH");
        const auto distance_column = all_data.findColumn("distance");
        const auto ranking_column = all_data.findColumn("ranking");
        const auto name_column = all_data.findColumn("name");
        const auto team_column = all_data.findColumn("team");
        const auto result_column = all_data.findColumn("result");
        const auto remark_column = all_data.findColumn("remark");

        for (const auto& row : all_data.body)
        {
            const auto rank = row.column[ranking_column];
            if (rank == "1")
            {
                const auto DH = row.column[gender_column];
                const auto distance = row.column[distance_column];
                const auto name = row.column[name_column];
                const auto team = (team_column < row.column.size() ? row.column[team_column] : "");
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
                    name_with_country = land_codes.expand(country) + " (" + adjustTeam(team) + ")";
                }
                const auto time = row.column[result_column];
                const auto linkName = std::format("{}{}", DH, distance);
                const auto description = std::format("{} - {}", DH, distance);
                const auto link = "<a href=\"#" + linkName + "\">" + description + "</a>";
                general::MultipleStrings body;
                const auto remark = (remark_column < row.column.size() ? row.column[remark_column] : "");
                body.data = { link, name_with_country, printResult(time, remark)};
                content.body.push_back(body);
            }
        }
        const auto Table = html::table(settings);
        auto table = Table.buildTable(content);
        return_value.addContent(table);
        return return_value;
    }

    general::MultipleStrings FormatOs::getOneDistance(const std::string& distance, const char gender, const readers::csvContent& all_data) const
    {
        auto return_value = general::MultipleStrings();
        return_value.addContent(std::format("<p/> <a name=\"{}{}\">", gender, distance));
        html::tableContent content;

        const auto gender_column = all_data.findColumn("DH");
        const auto distance_column = all_data.findColumn("distance");
        const auto ranking_column = all_data.findColumn("ranking");
        const auto name_column = all_data.findColumn("name");
        const auto team_column = all_data.findColumn("team");
        const auto result_column = all_data.findColumn("result");
        const auto remark_column = all_data.findColumn("remark");

        bool found_points = false;
        for (const auto& row : all_data.body)
        {
            const auto cur_gender = row.column[gender_column];
            const auto cur_distance = row.column[distance_column];
            if (cur_gender.find(gender) != std::string::npos && cur_distance == distance)
            {
                auto rank = row.column[ranking_column];
                const auto name = row.column[name_column];
                const auto team = (team_column < row.column.size() ? row.column[team_column] : "");
                const auto country = name.substr(0, 2);
                const auto full_name = (gender == 'D' ? findName(name, dames) : findName(name, heren));
                const auto land_code_and_name = html::funcs::acronym(country, land_codes.expand(country));
                std::string name_with_country;
                if (team.empty())
                {
                    name_with_country = std::format("{} ({})", full_name, land_code_and_name);
                }
                else
                {
                    name_with_country = land_codes.expand(country) + " (" + adjustTeam(team) + ")";
                }
                const auto time = row.column[result_column];
                if (time.ends_with(" p")) found_points = true;
                general::MultipleStrings body;
                if (rank == "-1") { rank = ""; }
                const auto remark = (remark_column < row.column.size() ? row.column[remark_column] : "");
                body.data = { rank, name_with_country, printResult(time, remark) };
                content.body.push_back(body);
            }
        }

        if (settings.lang == html::language::English)
        {
            content.header.data = { "rank", "name", found_points ? "points" : "time" };
            content.title = distance + " " + (gender == 'H' ? "men" : "woman");
        }
        else
        {
            content.header.data = { "rank", "naam", found_points ? "punten" : "tijd" };
            content.title = distance + " " + (gender == 'H' ? "Heren" : "Dames");
        }

        const auto Table = html::table(settings);
        auto table = Table.buildTable(content);
        return_value.addContent(table);
        return return_value;
    }

    general::MultipleStrings FormatOs::getAllDistances(const char gender, const readers::csvContent& all_data) const
    {
        auto return_value = general::MultipleStrings();
        const auto distances = findDistances(gender, all_data);
        for (const auto& distance : distances)
        {
            auto d = getOneDistance(distance, gender, all_data);
            return_value.addContent(d);
        }
        return return_value;
    }

    std::string FormatOs::findName(const std::string& name, const readers::csvContent& listNames)
    {
        for (const auto& row : listNames.body)
        {
            if (row.column[0] == name) return row.column[1];
        }
        return name;
    }

    int FormatOs::findDate(const std::vector<std::vector<std::string>>& remarks)
    {
        for (const auto& row : remarks)
        {
            if (row[0] == "dd") return std::stoi(row[1]);
        }
        throw general::shobException("Date not found in remarks");
    }

    std::string FormatOs::findTitle(const std::vector<std::vector<std::string>>& remarks)
    {
        for (const auto& row : remarks)
        {
            if (row[0] == "title") return row[1];
        }
        return "";
    }

    std::vector<std::string> FormatOs::findDistances(const char gender, const readers::csvContent& all_data)
    {
        auto return_value = std::vector<std::string>();
        std::string previous;
        for (const auto& row : all_data.body)
        {
            if (row.column[0].find(gender) != std::string::npos)
            {
                if (row.column[1] != previous)
                {
                    previous = row.column[1];
                    return_value.push_back(row.column[1]);
                }
            }
        }
        return return_value;
    }

    std::string FormatOs::printResult(const std::string& time_as_string, const std::string& remark)
    {
        const auto remark_with_par = remark.empty() ? "" : " (" + remark + ")";
        const auto pos_colon = time_as_string.find(':');
        if (time_as_string.ends_with(" p"))
        {
            return time_as_string + remark_with_par;
        }
        else if (pos_colon != std::string::npos)
        {
            auto minutes = time_as_string.substr(0, pos_colon);
            auto seconds = time_as_string.substr(1+pos_colon, 5);
            return std::format("{} min {} s{}", minutes, seconds, remark_with_par);
        }
        else if (time_as_string.find(';') != std::string::npos)
        {
            const auto times_as_strings = readers::csvReader::split(time_as_string, ";");
            const auto first_500m = times_as_strings.column[0];
            const auto second_500m = times_as_strings.column[1];
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
            const auto time = std::stod(time_as_string);
            const auto minutes = static_cast<int>(time) / 60;
            const auto seconds = time - 60.0 * static_cast<double>(minutes);
            if (minutes > 0)
            {
                return std::format("{} min {:05.2f} s{}", minutes, seconds, remark_with_par);
            }
            else
            {
                return std::format("{} s{}", time_as_string, remark_with_par);
            }
        }
        catch (const std::exception&)
        {
            return time_as_string;
        }
    }

    std::string FormatOs::adjustTeam(const std::string& team)
    {
        auto return_value = team;
        for (size_t i = 0; i < return_value.size(); i++)
        {
            if (return_value.find("; ") == i)
            {
                return_value.replace(i, 1, ",");
            }
        }
        return return_value;
    }

}
