
#include <filesystem>
#include <iostream>
#include <format>

#include "shob.general/dateFactory.h"
#include "shob.pages/format_ec_factory.h"
#include "shob.pages/format_nl_factory.h"
#include "shob.pages/format_ekwk_qf_factory.h"
#include "shob.pages/FormatOsFactory.h"
#include "shob.pages/FormatSemestersAndYearStandingsFactory.h"
#include "shob.pages/FormatHomeAndAwayStandingsFactory.h"
#include "shob.general/Season.h"
#include "shob.general/shobException.h"
#include "shob.html/updateIfNewer.h"

void read_command_line(int argc, char* argv[], int& yr1, int&yr2)
{
    using namespace shob::general;
    if (argc >= 3)
    {
        if (dateFactory::allDigits(argv[1]) && dateFactory::allDigits(argv[2]))
        {
            const std::string arg1 = argv[1];
            const std::string arg2 = argv[2];
            yr1 = std::stoi(arg1);
            yr2 = std::stoi(arg2);
        }
        else
        {
            throw shobException("first two command line arguments must be years");
        }
    }
    else if (argc == 2)
    {
        if (dateFactory::allDigits(argv[1]))
        {
            const std::string arg1 = argv[1];
            yr1 = std::stoi(arg1);
            yr2 = yr1;
        }
        else
        {
            throw shobException("first command line argument must be a year");
        }
    }
}


int main(int argc, char* argv[])
{
    using namespace shob::pages;
    using namespace shob::general;

    std::string part;
    try
    {
        int firstYear = 1993;
        int lastYear = 2026; // TODO function of current date

        read_command_line(argc, argv, firstYear, lastYear);

        part = "running factories";
        auto fmt_nl = format_nl_factory::build("sport");
        auto settings = shob::html::settings();
        settings.dateFormatShort = false;
        auto fmt_ec = format_ec_factory::build("sport", settings);
        auto fmt_ekwk_qf = format_ekwk_qf_factory::build("sport", settings);
        auto fmt_os = FormatOsFactory::build("sport/schaatsen/", settings);
        auto fmt_semesters_and_year = FormatSemestersAndYearStandingsFactory::build("sport/eredivisie/", settings);
        auto fmt_home_away = FormatHomeAndAwayStandingsFactory::build("sport/eredivisie/", settings);
        constexpr auto fmt_outfile = "../pages/sport_voetbal_{}_{}_voorronde.html";

        for (int year = firstYear; year <= lastYear; year++)
        {
            part = std::format("running year: {}", year);
            const auto season = Season(year);
            if (year < 2026)
            {
                if (std::filesystem::is_directory("../pages_new/"))
                {
                    fmt_nl.get_season_to_file(season, "../pages_new/sport_voetbal_nl_" + season.toPartFilename() + ".html");
                }
                if (year >= 1994)
                {
                    fmt_ec.get_season_to_file(season, "../pages/sport_voetbal_europacup_" + season.toPartFilename() + ".html");
                }
            }
            if (fmt_semesters_and_year.isValidYear(year))
            {
                fmt_semesters_and_year.getPagesToFile(year, fmt_semesters_and_year.getOutputFilename("../pages_new", year));
            }
            if (fmt_home_away.isValidSeason(season))
            {
                fmt_home_away.getPagesToFile(season, fmt_home_away.getOutputFilename("../pages_new", season));
            }
            if (year >= 1996)
            {
                // ReSharper disable once CppDefaultCaseNotHandledInSwitchStatement
                switch (year % 4)
                {
                case 0:
                    fmt_ekwk_qf.get_pages_to_file(year, std::format(fmt_outfile, "EK", year));
                    break;
                case 2:
                    fmt_ekwk_qf.get_pages_to_file(year, std::format(fmt_outfile, "WK", year));
                    break;
                }
            }
            if (year % 4 == 2 && year < 2026)
            {
                fmt_os.getPagesToFile(year, std::format("{}/sport_schaatsen_OS_{}.html", "../pages", year));
            }
        }

        part = "last year/season unofficial standings";
        auto last_season = fmt_home_away.getLastSeason();
        fmt_home_away.getPagesToFile(last_season, fmt_home_away.getOutputFilename("../pages_new"));

        part = "copy style sheets";
        if (std::filesystem::is_directory("../pages_new/"))
        {
            shob::html::updateIfDifferent::update("../code/test/epsig.css", "../pages_new/epsig.css");
        }
        if (std::filesystem::is_directory("../pages_compatible/"))
        {
            shob::html::updateIfDifferent::update("../code/test/epsig.css", "../pages_compatible/epsig.css");
        }
    }
    catch (const std::exception& e)
    {
        std::cout << part << "\n";
        std::cout << e.what() << "\n";
        return -1;
    }

    return 0;
}
