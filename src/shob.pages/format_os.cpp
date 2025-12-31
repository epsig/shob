
#include "format_os.h"
#include "head_bottum.h"
#include "../shob.html/updateIfNewer.h"
#include "../shob.html/funcs.h"
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
        retVal.addContent("<hr> andere winterspelen: |");
        auto topMenu = menu.getMenu(std::to_string(year));
        retVal.addContent(topMenu);
        retVal.addContent("<hr>");

        const auto remarks = seasons_reader.getSeason( std::to_string(year));

        const auto allData = read_matches_data(year);

        auto part1 = get_numbers_one(allData);
        retVal.addContent(part1);

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

        for (const auto& row : allData.body)
        {
            const auto rank = row.column[2];
            if (rank == "1")
            {
                const auto DH = row.column[0];
                const auto distance = row.column[1];
                const auto name = row.column[3];
                const auto country = name.substr(0, 2);
                const auto full_name = (DH == "D" ? findName(name, dames) : findName(name, heren));
                const auto land_code_and_name = html::funcs::acronym(country, land_codes.expand(country));
                const auto name_with_country = std::format("{} ({})", full_name, land_code_and_name);
                const auto time = row.column[5];
                general::multipleStrings body;
                body.data = { std::format("{} - {}", DH,distance), name_with_country, print_time(time, row.column[6])};
                content.body.push_back(body);
            }
        }
        const auto Table = html::table(settings);
        auto table = Table.buildTable(content);
        retVal.addContent(table);
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
        return 20000101;
    }

    std::string format_os::findTitle(const std::vector<std::vector<std::string>>& remarks)
    {
        for (const auto& row : remarks)
        {
            if (row[0] == "title") return row[1];
        }
        return "";
    }

    std::string format_os::print_time(const std::string& stime, const std::string& remark)
    {
        const auto remark_with_par = remark.empty() ? "" : " (" + remark + ")";
        if (stime.find(';') != std::string::npos)
        {
            const auto stimes = readers::csvReader::split(stime, ";");
            const auto first_500m = stimes.column[0];
            const auto second_500m = stimes.column[1];
            const auto sum = std::stod(first_500m) + std::stod(second_500m);
            return std::format("{} s + {} s = {:.2f} s{}", first_500m, second_500m, sum, remark_with_par);
        }
        const auto time = std::stod(stime);
        const auto minutes = static_cast<int>(time) / 60;
        const auto seconds = time - 60.0 * static_cast<double>(minutes);
        return std::format("{} min {:.2f} s{}", minutes, seconds, remark_with_par);
    }

}
