#pragma once

#include <string>
#include <string_view>

namespace shob::klaverjas
{
    class KlaverjasTable
    {
    public:
        static std::string kjTable(std::string_view displayType);
    private:
        static std::string form(std::string_view name, const std::string& content);
        static std::string input(std::string_view type, std::string_view name, std::string_view value, int size,
            std::string_view cssClass = {}, std::string_view onClick = {});
        static std::string td(const std::string& content, int columns = 1, int rows =1, std::string_view align = {},
            std::string_view valign = {});
        static std::string tdTop(const std::string& content);
        static std::string row(const std::string& content);
        static std::string spacer(int columns);
        static std::string blankImage(int size);
        static std::string showCard(bool graphics, char position);
        static constexpr auto nbsp = "&nbsp;";
    };
}