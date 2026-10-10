#include "FormatKlaverjas.h"
#include "HeadBottom.h"

#include "../shob.klaverjas/KlaverjasTable.h"
#include "../shob.html/updateIfNewer.h"
#include "../shob.general/FileIO.h"
#include "../shob.readers/csvReader.h"
#include "../shob.html/table.h"

namespace shob::pages
{
    using namespace shob::general;
    using namespace shob::html;

    void FormatKlaverjas::rebuildKlaverjas(std::string_view type, std::string_view location)
    {
        const auto content = type == "klein" ? getKlaverjasKleinScherm(location) : getKlaverjas(type, location);
        const auto filename = "../pages/kj_" + std::string(type) + "_" + std::string(location) + ".html";
        updateIfDifferent::update(filename, content);
    }

    general::MultipleStrings FormatKlaverjas::getKlaverjas(std::string_view type, std::string_view location)
    {
        const auto content = klaverjas::kjTable(type);
        auto ret = general::MultipleStrings();
        ret.addContent(content);

        auto hb = HeadBottomInput(-1);
        hb.title = "Klaverjassen";
        hb.css = StyleSheetType::InlineForKlaverjas;
        hb.copyTitleToH1 = false;
        hb.footerStyle = FooterStyle::Klaverjas;

        if (type == "gfx")
        {
            hb.js = JavaScriptType::KlaverjasGfx;
            hb.footerSubStyle = location == "rdam" ? FooterSubStyle::KlaverjasRdamGfx : FooterSubStyle::KlaverjasAdamGfx;
        }
        else if (type == "txt")
        {
            hb.js = JavaScriptType::KlaverjasTxt;
            hb.footerSubStyle = location == "rdam" ? FooterSubStyle::KlaverjasRdamTxt : FooterSubStyle::KlaverjasAdamTxt;
        }

        hb.body.addContent(ret);
        auto pageContent = HeadBottom::getPage(hb);
        return pageContent;
    }

    general::MultipleStrings FormatKlaverjas::getKlaverjasKleinScherm(std::string_view location)
    {
        auto content = FileIO::readFile("../code/Klaverjas/palmtop_scherm.html");
        for (auto& line : content.data)
        {
            const auto pos = line.find("InfoHelp");
            if (pos != std::string::npos)
            {
                line.replace(pos, 8, "nL");
            }
            line = readers::csvReader::trim(line, " ");
        }

        auto hb = HeadBottomInput(-1);
        hb.title = "Klaverjassen";
        hb.css = StyleSheetType::InlineForKlaverjasKlein;
        hb.copyTitleToH1 = false;
        hb.footerStyle = FooterStyle::Klaverjas;

        hb.js = JavaScriptType::KlaverjasTxt;
        hb.footerSubStyle = location == "rdam" ? FooterSubStyle::KlaverjasRdamKlein : FooterSubStyle::KlaverjasAdamKlein;

        hb.body.addContent(content);
        auto pageContent = HeadBottom::getPage(hb);
        return pageContent;
    }

    void FormatKlaverjas::rebuildFaq()
    {
        auto pageContent = getFaq();
        updateIfDifferent::update("../pages/klaverjas_faq.html", pageContent);
    }

    general::MultipleStrings FormatKlaverjas::getFaq()
    {
        auto content = R"(
<ol> <li> Welke versies zijn er precies? <br> Mijn klaverjas-spel is er in 6 smaken:
<table border cellspacing = 0>
 <tr> <th class="c"> Amsterdams </th> <th class="c"> Rotterdams </th> </tr>
 <tr>
  <td class="c"> <a href="kj_gfx_adam.html"> met plaatjes </a> </td>
  <td class="c"> <a href="kj_gfx_rdam.html"> met plaatjes </a> </td>
 </tr>
 <tr>
  <td class="c"> <a href="kj_txt_adam.html"> text - only </a> </td>
  <td class="c"> <a href="kj_txt_rdam.html"> text - only </a> </td>
 </tr>
 <tr>
  <td class="c"> <a href="kj_klein_adam.html"> text - only en klein scherm </a> </td>
  <td class="c"> <a href="kj_klein_rdam.html"> text - only en klein scherm </a> </td>
 </tr>
</table> </li>
 <li> Waarom kan ik niet passen?
   <br> Het verplicht spelen was sneller te programmeren.</li>
  <li> Amsterdams is helemaal niet Amsterdams; Rotterdams is helemaal niet Rotterdams!
   <br> Er zijn veel varianten van klaverjassen met een flinke spraakverwarring als gevolg.
   Ik heb de volgende regels toegepast:
   <ol>
    <li> Verplicht troefkiezen, en dan als eerste uitkomen.</li>
    <li> Kleur bekennen indien mogelijk.</li>
    <li> Als troef wordt gevraagd, en je kunt overtroeven, dan moet dat.</li>
    <li> Als je niet kunt bekennen, moet je introeven, behalve als de slag aan je maat ligt.
     <br> Bij Rotterdams moet dat ook als de slag aan je maat ligt.
    </li>
    <li> Je mag alleen ondertroeven, als je niets anders kunt.</li>
   </ol> </li>
  <li> Na &quot;Reload&quot; doet de tekst-only uitvoering van het programma vreemd.
   <br> Waarom weet ik ook niet, maar ik kan niet vinden waarom.
   Daarom kun je beter &quot;Nieuw Spel&quot; uit het menu op pagina zelf gebruiken.</li>
  <li> Ook op niveau vier speelt mijn maat niet best!
   <br> Er kan inderdaad slimmer gespeeld worden, maar dat vraagt een forse programmeerinspanning.
    Dat ga ik misschien ooit doen, maar die versie komt dan mogelijk niet gratis op Internet. </li>
 </ol>
        )";
        auto ml = MultipleStrings();
        ml.addContent(content);
        auto hb = HeadBottomInput(20261010);
        hb.title = "Klaverjas FAQ";
        hb.css = StyleSheetType::SeparateFile;
        hb.copyTitleToH1 = false;
        hb.footerStyle = FooterStyle::New;
        hb.body = table::yellowRed(ml, hb.title);
        auto pageContent = HeadBottom::getPage(hb);
        return pageContent;
    }
}
