
#include "table.h"
#include "funcs.h"
#include <boost/regex.hpp>

namespace shob::html
{
    using namespace shob::general;

    multipleStrings table::buildTable(const tableContent& content) const
    {
        multipleStrings table;

        std::string zeroWidth = settings_.isCompatible ? "0" : "\"0\"";

        if (content.empty()) { return table; }

        if (content.title.empty())
        {
            table.data.emplace_back("<table>");
        }
        else
        {
            size_t cols = 1;
            if (!content.header.data.empty()) cols = content.header.data.size();
            table.data.emplace_back("<table border cellspacing=" + zeroWidth+">" + buildHeader(content.title, cols));
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

    multipleStrings table::buildTable(const std::vector<tableContent>& content) const
    {
        multipleStrings table;
        if (content.empty()) { return table; }

        std::string zeroWidth = settings_.isCompatible ? "0" : "\"0\"";

        table.data.emplace_back("<table border cellspacing=" + zeroWidth + ">");

        for (const auto& subTable : content)
        {
            if ( ! subTable.title.empty())
            {
                size_t cols = 1;
                if (!subTable.colWidths.empty())
                {
                    cols = 0;
                    for (const auto col : subTable.colWidths) cols += col;
                }
                else if (!subTable.header.data.empty())
                {
                    cols = subTable.header.data.size();
                }
                else
                {
                    cols = subTable.body.size();
                }
                table.data.emplace_back(buildHeader(subTable.title, cols));
            }
            if (!subTable.header.data.empty())
            {
                if (subTable.colWidths.empty())
                {
                    table.data.push_back(buildHeader(subTable.header));
                }
                else
                {
                    table.data.push_back(buildHeader(subTable.header, subTable.colWidths));
                }
            }
            for (const auto& row : subTable.body)
            {
                if (subTable.colWidths.empty())
                {
                    table.data.push_back(buildRow(row));
                }
                else
                {
                    table.data.push_back(buildRow(row, subTable.colWidths));
                }
            }
        }

        table.data.emplace_back("</table>");
        return table;
    }

    std::string table::buildRow(const multipleStrings& content, const std::vector<int>& colWidths)
    {
        std::vector<std::string> tag1;
        std::vector<std::string> tag2;
        for (int colWidth : colWidths)
        {
            tag2.emplace_back("</td>");
            if (colWidth == 1)
            {
                tag1.emplace_back("<td>");
            }
            else
            {
                tag1.emplace_back("<td colspan=\"" + std::to_string(colWidth) + "\">");
            }
        }
        return buildRow(content, tag1, tag2);
    }

    std::string table::buildRow(const multipleStrings& content)
    {
        return buildRow(content, "<td>", "</td>");
    }

    std::string table::buildHeader(const multipleStrings& content)
    {
        return buildRow(content, "<th>", "</th>");
    }

    std::string table::buildHeader(const multipleStrings& content, const std::vector<int>& colWidths)
    {
        std::vector<std::string> tag1;
        std::vector<std::string> tag2;
        for (int colWidth : colWidths)
        {
            tag2.emplace_back("</th>");
            if (colWidth == 1)
            {
                tag1.emplace_back("<th>");
            }
            else
            {
                tag1.emplace_back("<th colspan=\"" + std::to_string(colWidth) + "\">");
            }
        }
        return buildRow(content, tag1, tag2);
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
        boost::regex expression("\\d+-\\d+");
        bool extraLine = true;
        boost::cmatch what;
        for (int i = 0; i < static_cast<int>(content.data.size()); i++)
        {
            auto& col = content.data[i];
            if (funcs::isAcronymOnly(col) && col.find(" =") != std::string::npos)
            {
                if (extraLine) row += "\n";
                row += "<td class=r>" + col + tag2;
                if (i < static_cast<int>(content.data.size()) - 1) row += "\n";
                extraLine = false;
            }
            else if (regex_match(col.c_str(), what, expression))
            {
                row += "<td class=c>" + col + tag2;
            }
            else
            {
                row += tag1 + col + tag2;
                extraLine = true;
            }
        }
        row += "</tr>";
        return row;
    }

    std::string table::buildRow(const multipleStrings& content, const std::vector<std::string>& tag1, const std::vector<std::string>& tag2)
    {
        std::string row = "<tr>";
        boost::regex expression("\\d+-\\d+");
        boost::cmatch what;
        for (int i = 0; i < static_cast<int>(content.data.size()); i++)
        {
            auto& col = content.data[i];
            if (regex_match(col.c_str(), what, expression))
            {
                row += "<td class=c>" + col + tag2[i];
            }
            else
            {
                row += tag1[i] + content.data[i] + tag2[i];
            }
        }
        row += "</tr>";
        return row;
    }

}
