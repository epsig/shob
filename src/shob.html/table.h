
#pragma once
#include "../shob.general/MultipleStrings.h"
#include "settings.h"
#include <string>
#include <vector>

namespace shob::html
{
    class tableContent
    {
    public:
        general::MultipleStrings header;
        std::vector<general::MultipleStrings> body;
        std::string title;
        std::vector<int> colWidths;
        bool empty() const { return body.empty() && header.data.empty(); }
    };

    class table
    {
    public:
        table(settings s) : settings_(s){}
        general::MultipleStrings buildTable(const tableContent& content) const;
        general::MultipleStrings buildTable(const std::vector<tableContent>& content) const;
        general::MultipleStrings tableOfTwoTables(general::MultipleStrings& left, general::MultipleStrings& right) const;
        general::MultipleStrings tableOfThreeTables(general::MultipleStrings& left, general::MultipleStrings& middle, general::MultipleStrings& right) const;
        bool withBorder = true;
    private:
        static std::string buildRow(const general::MultipleStrings& content);
        static std::string buildRow(const general::MultipleStrings& content, const std::vector<int>& colWidths);
        static std::string buildHeader(const general::MultipleStrings& content);
        static std::string buildHeader(const std::string& s, const size_t cols);
        static std::string buildHeader(const general::MultipleStrings& content, const std::vector<int>& colWidths);
        static std::string buildRow(const general::MultipleStrings& content, const std::string& tag1, const std::string& tag2);
        static std::string buildRow(const general::MultipleStrings& content, const std::vector<std::string>& tag1, const std::vector<std::string>& tag2);
        settings settings_;
    };
}
