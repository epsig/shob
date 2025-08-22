
#pragma once
#include "../shob.general/multipleStrings.h"
#include "settings.h"
#include <string>
#include <vector>

namespace shob::html
{
    class tableContent
    {
    public:
        general::multipleStrings header;
        std::vector<general::multipleStrings> body;
        std::string title;
        std::vector<int> colWidths;
        bool empty() const { return body.empty() && header.data.empty(); }
    };

    class table
    {
    public:
        table(settings s) : settings_(s){}
        general::multipleStrings buildTable(const tableContent& content) const;
        general::multipleStrings buildTable(const std::vector<tableContent>& content) const;
    private:
        static std::string buildRow(const general::multipleStrings& content);
        static std::string buildRow(const general::multipleStrings& content, const std::vector<int>& colWidths);
        static std::string buildHeader(const general::multipleStrings& content);
        static std::string buildHeader(const std::string& s, const size_t cols);
        static std::string buildHeader(const general::multipleStrings& content, const std::vector<int>& colWidths);
        static std::string buildRow(const general::multipleStrings& content, const std::string& tag1, const std::string& tag2);
        static std::string buildRow(const general::multipleStrings& content, const std::vector<std::string>& tag1, const std::vector<std::string>& tag2);
        settings settings_;
    };
}
