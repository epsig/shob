
#include "table.h"

namespace shob::html
{
    using namespace shob::general;

    multipleStrings table::buildTable(const tableContent& content)
    {
        multipleStrings table;
        if (content.empty()) { return table; }

        if (content.title.empty())
        {
            table.data.emplace_back("<table>");
        }
        else
        {
            size_t cols = 1;
            if (!content.header.data.empty()) cols = content.header.data.size();
            table.data.emplace_back("<table border cellspacing=\"0\">" + buildHeader(content.title, cols));
        }

        if ( ! content.header.data.empty())
        {
            table.data.push_back(buildHeader(content.header));
        }
        for (const auto& row : content.body)
        {
            table.data.push_back(buildRow(row));
        }
        table.data.emplace_back("</table>");
        return table;
    }

    multipleStrings table::buildTable(const std::vector<tableContent>& content)
    {
        multipleStrings table;
        if (content.empty()) { return table; }

        table.data.emplace_back("<table border cellspacing=\"0\">");

        for (const auto& subTable : content)
        {
            if ( ! subTable.title.empty())
            {
                size_t cols = 1;
                if (!subTable.header.data.empty()) cols = subTable.header.data.size();
                table.data.emplace_back(buildHeader(subTable.title, cols));
            }
            if (!subTable.header.data.empty())
            {
                table.data.push_back(buildHeader(subTable.header));
            }
            for (const auto& row : subTable.body)
            {
                table.data.push_back(buildRow(row));
            }
        }

        table.data.emplace_back("</table>");
        return table;
    }

    std::string table::buildRow(const multipleStrings& content)
    {
        return buildRow(content, "<td>", "</td>");
    }

    std::string table::buildHeader(const multipleStrings& content)
    {
        return buildRow(content, "<th>", "</th>");
    }

    std::string table::buildHeader(const std::string& s, const size_t cols)
    {
        multipleStrings content;
        content.data.push_back(s);
        return buildRow(content, "<th colspan=\"" + std::to_string(cols) + "\" class=h>", "</th>");
    }

    std::string table::buildRow(const multipleStrings& content, const std::string& tag1, const std::string& tag2)
    {
        std::string row = "<tr>";
        for (const auto& col : content.data)
        {
            row += tag1 + col + tag2;
        }
        row += "</tr>";
        return row;
    }

}
