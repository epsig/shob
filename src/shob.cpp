
#include "shob.pages/format_nl_factory.h"

int main(int argc, char* argv[])
{
    if (argc < 2) return -1;
    std::string season = argv[1];

    auto fmt_nl = shob::pages::format_nl_factory::build("sport");
    fmt_nl.get_season_stdout(season);
}
