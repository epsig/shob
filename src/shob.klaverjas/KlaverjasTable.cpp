#include "KlaverjasTable.h"

#include <string>

namespace
{
    constexpr auto nbsp = "&nbsp;";

    std::string form(std::string_view name, const std::string& content)
    {
        return "<form name=\"" + std::string(name) + "\">" + content + "</form>\n";
    }

    std::string input(std::string_view type, std::string_view name, std::string_view value,
        int size = 0, std::string_view cssClass = {}, std::string_view onClick = {})
    {
        std::string result = "<input";
        if (!type.empty()) result += " type=\"" + std::string(type) + "\"";
        if (!name.empty()) result += " name=\"" + std::string(name) + "\"";
        result += " value=\"" + std::string(value) + "\"";
        if (size > 0) result += " size=\"" + std::to_string(size) + "\"";
        if (!cssClass.empty()) result += " class=\"" + std::string(cssClass) + "\"";
        if (!onClick.empty()) result += " onClick=\"" + std::string(onClick) + "\"";
        return result + "/>\n";
    }

    std::string td(const std::string& content, int columns = 1, int rows = 1,
        std::string_view align = {}, std::string_view valign = {})
    {
        std::string result = "<td";
        if (columns > 1) result += " colspan=\"" + std::to_string(columns) + "\"";
        if (rows > 1) result += " rowspan=\"" + std::to_string(rows) + "\"";
        if (!align.empty()) result += " align=\"" + std::string(align) + "\"";
        if (!valign.empty()) result += " valign=\"" + std::string(valign) + "\"";
        return result + ">" + content + "</td>";
    }

    std::string tdTop(const std::string& content)
    {
        return "<td valign=\"top\">" + content + "</td>\n";
    }

    std::string row(const std::string& content)
    {
        return "<tr>" + content + "</tr>\n";
    }

    std::string spacer(int columns)
    {
        return td(nbsp, columns);
    }

    std::string blankImage(int size)
    {
        return "<img border=0 src=\"include/wit.gif\" height=" + std::to_string(size) +
            " width=" + std::to_string(size) + "/>";
    }

    std::string showCard(bool graphics, char position)
    {
        const auto content = graphics
            ? blankImage(50)
            : input("text", "", "", 4, "k");
        return td(form("ShowKaart" + std::string(1, position), content));
    }
}

namespace shob::klaverjas
{
    std::string kjTable(std::string_view displayType)
    {
        const bool graphics = displayType == "gfx";
        std::string topLine = tdTop(form("KiesTroefTxt",
            input("text", "vld1", "kies troef:", 12)));

        std::string formText;
        for (int index = 0; index < 4; ++index)
        {
            if (graphics)
            {
                formText += "<a href=\"javascript:KiesTroef(" + std::to_string(index) +
                    ")\">" + blankImage(40) + "</a>" + nbsp;
            }
            else
            {
                formText += input("button", "", " ? ", 0, "k",
                    "KiesTroef(" + std::to_string(index) + ");");
            }
        }
        topLine += td(form("KiesTroefKleur", formText), 2) +
            tdTop("Score: ") +
            td(form("ShowScore",
                input("text", "HuidigeScoreU", "0", 4) +
                input("text", "HuidigeScoreC", "0", 4)));

        formText.clear();
        const int historyRows = graphics ? 6 : 7;
        const auto historyField = input("text", "", "", 5);
        for (int index = 0; index < historyRows; ++index)
        {
            if (index > 0) formText += "<br>";
            formText += historyField + nbsp + historyField;
        }
        topLine += td(
            form("WijZij", input("text", "Wij", "Wij", 5) +
                input("text", "Zij", "Zij", 5) + "<br>") +
            form("TotaleScore", formText), 1, graphics ? 4 : 5);

        std::string output = row(topLine) + row(
            tdTop("gekozen door: ") +
            td(form("ShowTroefKleur", input("text", "HuidigeTroefKiezer", "???", 10)), 2) +
            tdTop("Roem: ") +
            td(form("ShowRoem", input("text", "HuidigeRoemU", "0", 4) +
                input("text", "HuidigeRoemC", "0", 4))));

        output += row(
            td(form("BSpelNiveau",
                input("button", "", "Spelniveau:", 0, "b", "HelpFunctie(3);") +
                input("button", "", "-", 0, "b", "IncSpelNiveau(-1);") +
                input("button", "HuidigNiv", "1", 0, "b", "HelpFunctie(3);") +
                input("button", "", "+", 0, "b", "IncSpelNiveau(1);")), 2) +
            showCard(graphics, 'M') +
            td(form("InfoHelp",
                input("button", "", " ? ", 0, "b", "HelpFunctie(1);") +
                input("button", "", " i ", 0, "b", "HelpFunctie(4);") +
                input("button", "", " &copy; ", 0, "b", "HelpFunctie(2);")),
                2, 1, "center", "center"));

        formText.clear();
        if (graphics)
        {
            for (int index = 0; index < 8; ++index)
            {
                formText += "<a href=\"javascript:SpeelDeze(" + std::to_string(index) +
                    ")\">" + blankImage(50) + "</a>" + nbsp + "\n";
            }
            output += row(spacer(1) + showCard(true, 'L') + showCard(true, 'S') +
                showCard(true, 'R') + spacer(1));
            output += row(td(form("IndeHand", formText), 6, 1, "center"));
        }
        else
        {
            for (int index = 0; index < 8; ++index)
            {
                formText += input("button", "", "WWW", 0, "k",
                    "SpeelDeze(" + std::to_string(index) + ");");
            }
            output += row(spacer(1) + showCard(false, 'L') + spacer(1) +
                showCard(false, 'R') + spacer(1));
            output += row(spacer(2) + showCard(false, 'S') + spacer(2));
            output += row(spacer(1) + td(form("IndeHand", formText), 5));
        }

        output += row(td(form("msg",
            input("text", "m0", " ", 43) + input("text", "m1", " ", 43)), 6));
        return "<table border cellspacing=\"0\" width=\"100%\">" + output + "</table>\n";
    }
}