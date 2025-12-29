
#include "format_os.h"
#include "../shob.html/updateIfNewer.h"
#include <format>
#include <iostream>

#include "head_bottum.h"

namespace shob::pages
{
    format_os::format_os(std::string folder, readers::csvAllSeasonsReader reader, readers::csvContent dames,
        readers::csvContent heren, topMenu menu, html::settings settings) :
        folder(std::move(folder)), seasons_reader(std::move(reader)),
        dames(std::move(dames)), heren(std::move(heren)), menu(std::move(menu)), settings(settings) {  }

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

    std::string findName(const std::string& name, const readers::csvContent& listNames)
    {
        for(const auto& row : listNames.body)
        {
            if (row.column[0] == name) return row.column[1];
        }
        return name;
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
                general::multipleStrings body;
                const auto DH = row.column[0];
                const auto distance = row.column[1];
                auto name = row.column[3];
                if (DH == "D")
                {
                    name = findName(name, dames);
                }
                else
                {
                    name = findName(name, heren);
                }
                const auto time = row.column[5];
                body.data = { std::format("{} - {}", DH,distance), name, time };
                content.body.push_back(body);
            }
        }
        const auto Table = html::table(settings);
        auto table = Table.buildTable(content);
        retVal.addContent(table);
        return retVal;
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

}
