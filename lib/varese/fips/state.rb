module Varese
  module FIPS
    class State
      ABBREVIATIONS = {
        "ak" => "alaska",
        "al" => "alabama",
        "ar" => "arkansas",
        "as" => "american samoa",
        "az" => "arizona",
        "ca" => "california",
        "co" => "colorado",
        "ct" => "connecticut",
        "dc" => "district of columbia",
        "de" => "delaware",
        "fl" => "florida",
        "ga" => "georgia",
        "gu" => "guam",
        "hi" => "hawaii",
        "ia" => "iowa",
        "id" => "idaho",
        "il" => "illinois",
        "in" => "indiana",
        "ks" => "kansas",
        "ky" => "kentucky",
        "la" => "louisiana",
        "ma" => "massachusetts",
        "md" => "maryland",
        "me" => "maine",
        "mi" => "michigan",
        "mn" => "minnesota",
        "mo" => "missouri",
        "ms" => "mississippi",
        "mt" => "montana",
        "nc" => "north carolina",
        "nd" => "north dakota",
        "ne" => "nebraska",
        "nh" => "new hampshire",
        "nj" => "new jersey",
        "nm" => "new mexico",
        "nv" => "nevada",
        "ny" => "new york",
        "oh" => "ohio",
        "ok" => "oklahoma",
        "or" => "oregon",
        "pa" => "pennsylvania",
        "pr" => "puerto rico",
        "ri" => "rhode island",
        "sc" => "south carolina",
        "sd" => "south dakota",
        "tn" => "tennessee",
        "tx" => "texas",
        "ut" => "utah",
        "va" => "virginia",
        "vi" => "virgin islands",
        "vt" => "vermont",
        "wa" => "washington",
        "wi" => "wisconsin",
        "wv" => "west virginia",
        "wy" => "wyoming"
      }

      CODES = {
        "alaska" => "02",
        "alabama" => "01",
        "arkansas" => "05",
        "american samoa" => "60",
        "arizona" => "04",
        "california" => "06",
        "colorado" => "08",
        "connecticut" => "09",
        "district of columbia" => "11",
        "delaware" => "10",
        "florida" => "12",
        "georgia" => "13",
        "guam" => "66",
        "hawaii" => "15",
        "iowa" => "19",
        "idaho" => "16",
        "illinois" => "17",
        "indiana" => "18",
        "kansas" => "20",
        "kentucky" => "21",
        "louisiana" => "22",
        "massachusetts" => "25",
        "maryland" => "24",
        "maine" => "23",
        "michigan" => "26",
        "minnesota" => "27",
        "missouri" => "29",
        "mississippi" => "28",
        "montana" => "30",
        "north carolina" => "37",
        "north dakota" => "38",
        "nebraska" => "31",
        "new hampshire" => "33",
        "new jersey" => "34",
        "new mexico" => "35",
        "nevada" => "32",
        "new york" => "36",
        "ohio" => "39",
        "oklahoma" => "40",
        "oregon" => "41",
        "pennsylvania" => "42",
        "puerto rico" => "72",
        "rhode island" => "44",
        "south carolina" => "45",
        "south dakota" => "46",
        "tennessee" => "47",
        "texas" => "48",
        "utah" => "49",
        "virginia" => "51",
        "virgin islands" => "78",
        "vermont" => "50",
        "washington" => "53",
        "wisconsin" => "55",
        "west virginia" => "54",
        "wyoming" => "56"
      }

      class << self
        def abbreviation(abbrev)
          state = ABBREVIATIONS.fetch("#{abbrev}".downcase){ raise UnknownAbbreviation }
          CODES.fetch(state)
        end

        def method_missing(name, *args, &block)
          str = ABBREVIATIONS.fetch("#{name}"){ "#{name}" }
          CODES.fetch(str){ super }
        end
      end
    end

    class UnknownAbbreviation < StandardError
    end
  end
end

