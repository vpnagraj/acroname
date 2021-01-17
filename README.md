
<!-- README.md is generated from README.Rmd. Please edit that file -->

# acroname

[![CRAN
Status](https://www.r-pkg.org/badges/version/acroname)](https://cran.r-project.org/package=acroname)
![](https://cranlogs.r-pkg.org/badges/acroname)

## Installation

``` r
devtools::install_github("vpnagraj/acroname")
```

## Features

  - `acronym()`: Generate acronym from input string
  - `initialism()`: Generate initialism from input string
  - `mince()`: Prepare input string

## Usage

### Basic example

The minimal usage for creating an acronym:

``` r
library(acroname)
set.seed(123)
acronym("super special software package", acronym_length = 5)
#> [1] "SUSIE: SUper SpecIal softwarE package"
```

And an initialism for the same string:

``` r
initialism("super special software package")
#> [1] "SSSP: Super Special Software Package"
```

The functions can accept input character vectors that either contain the
string in a single element or are prepared with one element per word:

``` r
acronym(c("super", "special", "software", "package"), acronym_length = 5)
#> [1] "SUSIE: SUper SpecIal softwarE package"
```

### Convert result to `tibble`

Both `acronym()` and `initialism()` include an option to return the
result as a `tibble` object:

``` r
acronym("dip him in the river who loves water", acronym_length = 4, to_tibble = TRUE)
#> # A tibble: 1 x 4
#>   formatted                  prefix suffix                 original             
#>   <chr>                      <chr>  <chr>                  <chr>                
#> 1 ROOT: dip him in River wh… ROOT   dip him in River whO … dip him in river who…
```

### Exclude articles

Each function can also be customized to exclude articles in the input
string:

``` r
initialism("dip him in the river who loves water", to_tibble = TRUE, ignore_articles = TRUE)
#> # A tibble: 1 x 4
#>   formatted                   prefix  suffix               original             
#>   <chr>                       <chr>   <chr>                <chr>                
#> 1 DHIRWLW: Dip Him In River … DHIRWLW Dip Him In River Wh… dip him in river who…
```

### Trigger “bag of words” approach

Using the “bow” option will trigger processing using a “bag of words”
method, by which words in the input string are randomly selected. The
number of words selected from the input string depends on the value
passed to the “bow\_prop” argument:

``` r
acronym("dip him in the river who loves water the fountain contains the cistern overflows", ignore_articles = TRUE, acronym_length = 4, bow = TRUE, bow_prop = 0.75)
#> [1] "INRI: dip loves hIm who water fouNtain River In cistern"
```

It is possible to generate a series of randomized results by iterating
over the function:

``` r
library(purrr)
library(dplyr)
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union

## write a function to wrap acronym() in order to map
mapwrap <- function(i, input) {
  res <- 
    acronym(input = input, ignore_articles = TRUE, acronym_length =  4, bow = TRUE, bow_prop = 0.75, to_tibble = TRUE) %>%
    mutate(iteration = i, .before = "formatted")
  return(res)
}

iterations <- paste0("iteration_",1:5)
map_df(iterations, mapwrap, "dip him in the river who loves water the fountain contains the cistern overflows")
#> # A tibble: 5 x 5
#>   iteration  formatted              prefix suffix            original           
#>   <chr>      <chr>                  <chr>  <chr>             <chr>              
#> 1 iteration… CORA: dip Cistern whO… CORA   dip Cistern whO … dip cistern who ri…
#> 2 iteration… HOWE: Him who cistern… HOWE   Him who cistern … him who cistern ov…
#> 3 iteration… CROW: loves dip who C… CROW   loves dip who Co… loves dip who cont…
#> 4 iteration… INST: IN him containS… INST   IN him containS … in him contains ci…
#> 5 iteration… DIOR: cistern who DIp… DIOR   cistern who DIp … cistern who dip ov…
```

### Use a custom dictionary

By default the `acronym()` engine will search for acronyms that match
words in the “en\_US” dictionary provided by the
[hunspell](https://CRAN.R-project.org/package=hunspell) package.
However, the dictionary of words to match can be customized via the
“dictionary” argument. The example below uses a dictionary based on
names from the dplyr package, prepared with a little help from the
`mince()` function:

``` r
## get names (first or last) from the dplyr::starwars data
## see mince() in action
mince(starwars$name)
#> $words
#>   [1] "Luke"        "Skywalker"   "C3PO"        "R2D2"        "Darth"      
#>   [6] "Vader"       "Leia"        "Organa"      "Owen"        "Lars"       
#>  [11] "Beru"        "Whitesun"    "lars"        "R5D4"        "Biggs"      
#>  [16] "Darklighter" "ObiWan"      "Kenobi"      "Anakin"      "Skywalker"  
#>  [21] "Wilhuff"     "Tarkin"      "Chewbacca"   "Han"         "Solo"       
#>  [26] "Greedo"      "Jabba"       "Desilijic"   "Tiure"       "Wedge"      
#>  [31] "Antilles"    "Jek"         "Tono"        "Porkins"     "Yoda"       
#>  [36] "Palpatine"   "Boba"        "Fett"        "IG88"        "Bossk"      
#>  [41] "Lando"       "Calrissian"  "Lobot"       "Ackbar"      "Mon"        
#>  [46] "Mothma"      "Arvel"       "Crynyd"      "Wicket"      "Systri"     
#>  [51] "Warrick"     "Nien"        "Nunb"        "QuiGon"      "Jinn"       
#>  [56] "Nute"        "Gunray"      "Finis"       "Valorum"     "Jar"        
#>  [61] "Jar"         "Binks"       "Roos"        "Tarpals"     "Rugor"      
#>  [66] "Nass"        "Ric"         "Olié"        "Watto"       "Sebulba"    
#>  [71] "Quarsh"      "Panaka"      "Shmi"        "Skywalker"   "Darth"      
#>  [76] "Maul"        "Bib"         "Fortuna"     "Ayla"        "Secura"     
#>  [81] "Dud"         "Bolt"        "Gasgano"     "Ben"         "Quadinaros" 
#>  [86] "Mace"        "Windu"       "KiAdiMundi"  "Kit"         "Fisto"      
#>  [91] "Eeth"        "Koth"        "Adi"         "Gallia"      "Saesee"     
#>  [96] "Tiin"        "Yarael"      "Poof"        "Plo"         "Koon"       
#> [101] "Mas"         "Amedda"      "Gregar"      "Typho"       "Cordé"      
#> [106] "Cliegg"      "Lars"        "Poggle"      "Lesser"      "Luminara"   
#> [111] "Unduli"      "Barriss"     "Offee"       "Dormé"       "Dooku"      
#> [116] "Bail"        "Prestor"     "Organa"      "Jango"       "Fett"       
#> [121] "Zam"         "Wesell"      "Dexter"      "Jettster"    "Lama"       
#> [126] "Su"          "Taun"        "We"          "Jocasta"     "Nu"         
#> [131] "Ratts"       "Tyerell"     "R4P17"       "Wat"         "Tambor"     
#> [136] "San"         "Hill"        "Shaak"       "Ti"          "Grievous"   
#> [141] "Tarfful"     "Raymus"      "Antilles"    "Sly"         "Moore"      
#> [146] "Tion"        "Medon"       "Finn"        "Rey"         "Poe"        
#> [151] "Dameron"     "BB8"         "Captain"     "Phasma"      "Padmé"      
#> [156] "Amidala"    
#> 
#> $collapsed
#> [1] "LukeSkywalkerC3POR2D2DarthVaderLeiaOrganaOwenLarsBeruWhitesunlarsR5D4BiggsDarklighterObiWanKenobiAnakinSkywalkerWilhuffTarkinChewbaccaHanSoloGreedoJabbaDesilijicTiureWedgeAntillesJekTonoPorkinsYodaPalpatineBobaFettIG88BosskLandoCalrissianLobotAckbarMonMothmaArvelCrynydWicketSystriWarrickNienNunbQuiGonJinnNuteGunrayFinisValorumJarJarBinksRoosTarpalsRugorNassRicOliéWattoSebulbaQuarshPanakaShmiSkywalkerDarthMaulBibFortunaAylaSecuraDudBoltGasganoBenQuadinarosMaceWinduKiAdiMundiKitFistoEethKothAdiGalliaSaeseeTiinYaraelPoofPloKoonMasAmeddaGregarTyphoCordéClieggLarsPoggleLesserLuminaraUnduliBarrissOffeeDorméDookuBailPrestorOrganaJangoFettZamWesellDexterJettsterLamaSuTaunWeJocastaNuRattsTyerellR4P17WatTamborSanHillShaakTiGrievousTarffulRaymusAntillesSlyMooreTionMedonFinnReyPoeDameronBB8CaptainPhasmaPadméAmidala"
#> 
#> $words_len
#>   [1]  4  9  4  4  5  5  4  6  4  4  4  8  4  4  5 11  6  6  6  9  7  6  9  3  4
#>  [26]  6  5  9  5  5  8  3  4  7  4  9  4  4  4  5  5 10  5  6  3  6  5  6  6  6
#>  [51]  7  4  4  6  4  4  6  5  7  3  3  5  4  7  5  4  3  4  5  7  6  6  4  9  5
#>  [76]  4  3  7  4  6  3  4  7  3 10  4  5 10  3  5  4  4  3  6  6  4  6  4  3  4
#> [101]  3  6  6  5  5  6  4  6  6  8  6  7  5  5  5  4  7  6  5  4  3  6  6  8  4
#> [126]  2  4  2  7  2  5  7  5  3  6  3  4  5  2  8  7  6  8  3  5  4  5  4  3  3
#> [151]  7  3  7  6  5  7
#> 
#> $first_chars
#>   [1] "L" "S" "C" "R" "D" "V" "L" "O" "O" "L" "B" "W" "l" "R" "B" "D" "O" "K"
#>  [19] "A" "S" "W" "T" "C" "H" "S" "G" "J" "D" "T" "W" "A" "J" "T" "P" "Y" "P"
#>  [37] "B" "F" "I" "B" "L" "C" "L" "A" "M" "M" "A" "C" "W" "S" "W" "N" "N" "Q"
#>  [55] "J" "N" "G" "F" "V" "J" "J" "B" "R" "T" "R" "N" "R" "O" "W" "S" "Q" "P"
#>  [73] "S" "S" "D" "M" "B" "F" "A" "S" "D" "B" "G" "B" "Q" "M" "W" "K" "K" "F"
#>  [91] "E" "K" "A" "G" "S" "T" "Y" "P" "P" "K" "M" "A" "G" "T" "C" "C" "L" "P"
#> [109] "L" "L" "U" "B" "O" "D" "D" "B" "P" "O" "J" "F" "Z" "W" "D" "J" "L" "S"
#> [127] "T" "W" "J" "N" "R" "T" "R" "W" "T" "S" "H" "S" "T" "G" "T" "R" "A" "S"
#> [145] "M" "T" "M" "F" "R" "P" "D" "B" "C" "P" "P" "A"

sw_names <- mince(starwars$name)$words

acronym("latest and greatest data analysis package", dictionary = sw_names, acronym_length = 4)
#> [1] "LARS: Latest And gReatest data analySis package"
```

### Configure timeout option

Depending on the characters in the input string, the size of dictionary,
and the acronym length it may not be possible to generate an acronym
that matches a word in the dictionary. The `acronym()` function will try
for 60 seconds by default, but this duration can be customized via the
“timeout” argument:

``` r
## the longer the desired acronym, the longer it will likely to take to find a match
## setting the timeout to 2 seconds here
acronym("latest and greatest data analysis package", dictionary = sw_names, acronym_length = 10, timeout = 2)
#> Unable to find viable acronym in 'timeout' specified (2 seconds) ...
```

## Related

  - <https://github.com/bacook17/acronym>

## Contributing

Please use GitHub issues to report bugs or request features.
Contributions will be reviewed via pull requests.
