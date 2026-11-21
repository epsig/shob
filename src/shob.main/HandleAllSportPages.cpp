#include "HandleAllSportPages.h"

#include "../shob.pages/FormatEcBuilder.h"
#include "../shob.pages/FormatNlBuilder.h"
#include "../shob.pages/FormatEkWkBuilder.h"
#include "../shob.pages/FormatEkWkDBuilder.h"
#include "../shob.pages/FormatEkWkQfBuilder.h"
#include "../shob.pages/FormatOsBuilder.h"
#include "../shob.pages/FormatSemestersAndYearStandingsBuilder.h"
#include "../shob.pages/FormatHomeAndAwayStandingsBuilder.h"
#include "../shob.pages/FormatStatsEredivisieBuilder.h"

#include <format>

namespace shob::main
{
    using namespace shob::general;
    using namespace shob::pages;

    void HandleAllSportPages::buildAllSport(const int first_year, const int last_year, int& dd, std::string& part)
    {
        part = "running builders";
        auto settings = shob::html::Settings();
        settings.dateFormatShort = false;
        auto fmt_nl = FormatNlBuilder::build("sport", settings);
        auto fmt_ec = FormatEcBuilder::build("sport", settings);
        auto fmt_ekwk = FormatEkWkBuilder::build("sport", settings);
        auto fmt_ekwkD = FormatEkWkDBuilder::build("sport", settings);
        auto fmt_ekwk_qf = FormatEkWkQfBuilder::build("sport", settings);
        auto fmt_os = FormatOsBuilder::build("sport/schaatsen/", settings);
        auto fmt_semesters_and_year = FormatSemestersAndYearStandingsBuilder().build("sport/eredivisie/", settings);
        auto fmt_home_away = FormatHomeAndAwayStandingsBuilder::build("sport/eredivisie/", settings);

        auto fmt_stats_eredivisie = FormatStatsEredivisieBuilder::build("sport/eredivisie/", settings);
        for (const auto& extra : { true, false })
        {
            fmt_stats_eredivisie.getPagesToFile(extra,
                FormatStatsEredivisie::getOutputFilename("../pages/", extra));
        }

        for (int year = first_year; year <= last_year; year++)
        {
            part = std::format("running year: {}", year);
            const auto season = Season(year);
            if (fmt_nl.isValidSeason(season))
            {
                fmt_nl.getPagesToFile(season, fmt_nl.getOutputFilename("../pages", season));
            }
            if (fmt_ec.isValidSeason(season))
            {
                fmt_ec.getPagesToFile(season, fmt_ec.getOutputFilename("../pages", season));
            }
            if (fmt_semesters_and_year.isValidYear(year))
            {
                fmt_semesters_and_year.getPagesToFile(year, fmt_semesters_and_year.getOutputFilename("../pages", year));
            }
            if (fmt_home_away.isValidSeason(season))
            {
                fmt_home_away.getPagesToFile(season, fmt_home_away.getOutputFilename("../pages", season));
            }
            if (fmt_ekwk.isValidYear(year))
            {
                fmt_ekwk.getPagesToFile(year, fmt_ekwk.getOutputFilename("../pages", year));
            }
            if (fmt_ekwkD.isValidYear(year))
            {
                fmt_ekwkD.getPagesToFile(year, fmt_ekwkD.getOutputFilename("../pages", year));
            }
            if (fmt_ekwk_qf.isValidYear(year))
            {
                fmt_ekwk_qf.getPagesToFile(year, fmt_ekwk_qf.getOutputFilename("../pages", year));
            }
            if (fmt_os.isValidYear(year))
            {
                fmt_os.getPagesToFile(year, fmt_os.getOutputFilename("../pages", year));
            }
        }

        part = "last year/season unofficial standings";
        auto last_season = fmt_home_away.getLastSeason();
        fmt_home_away.getPagesToFile(last_season, fmt_home_away.getOutputFilename("../pages"));
        auto file_based_last_year = fmt_semesters_and_year.getLastYear();
        fmt_semesters_and_year.getPagesToFile(file_based_last_year, fmt_semesters_and_year.getOutputFilename("../pages"));

        dd = fmt_nl.get_dd();
        dd = std::max(dd, fmt_ec.get_dd());
        dd = std::max(dd, fmt_ekwk_qf.get_dd());
    }
}