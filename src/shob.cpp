
#include "shob.pages/format_nl.h"

int main(int argc, char* argv[])
{
    if (argc < 2) return -1;
    std::string season = argv[1];

    auto fmt_nl = shob::pages::format_nl("data");
    fmt_nl.get_season_stdout(season);
}
