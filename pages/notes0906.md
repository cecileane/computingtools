---
layout: page
title: 9/8 notes
description: notes, links, example code and exercises
---

nametags and survey:

* your name
* your graduate program and year
* why do you want to take this course
  (required / needs tools x and y for my research / need tools on my CV to apply for job x or y / ...)
* any questions for me


## what the course is about

#### learning objectives:

- learn to do computations
    * efficiently: possibly handling very large data sets
    * automatically: using scripts to repeat tasks (and avoid manual errors)
    * reproducibly: by oneself or by others
    * collaboratively: sharing work with a version control system
- ability to adapt to change.

#### what the course is *not* about:

- learn how to run specific software / bioinformatics pipelines
  (use google, online manuals & resources)
- learn how to use R (other courses)
- learn statistical concepts / techniques (other courses)

#### why should we learn these things?

- demands from the modern professional world: research & industry

- cautionary tale: "Duke Saga". Research with multiple serious errors,
  reviewed by statisticians Baggerly and Coombes.
  Results could not be reproduced,
  insufficient information to reproduce all the steps.
  "forensic bioinformatics".
  read their [paper](http://projecteuclid.org/euclid.aoas/1267453942) and watch the
  [youtube video](https://www.youtube.com/watch?v=eV9dcAGaVU8) (13 minutes)
  for the story.

   * "common errors are simple, and simple errors are common"
   *  poor documentation can lead to errors and irreproducibility.
      document:
      - data
      - methods, software versions
      - code

- talk on [reproducible research](https://github.com/kbroman/Talk_ReproRes) by Karl Broman.
  Slide #12 is so true.

## expectations

- very active participation. no practice = no learning.
    * ask questions
    * try things out, spend time debugging, again and again
    * help others with their practical roadblocks
- your learning objectives? expectations?

## logistics

Your laptop is going to be your slave and best friend. Invest in it!

[Hardware requirement](pages/coursedescription.html#hardware-requirements): Linux or Mac.

- need to use the bash shell (this tool won't change!)
- need admin access: to have the freedom to install new software or tweak which compiler
  or Python version (etc.) you system uses.
- pick an old laptop in your parents' or friends' basement, presumably old and slow.
  Wipe its OS and install some LTS (long term support) release of Ubuntu.
  Version [16.04.1](http://www.ubuntu.com/download/desktop) requires
    * 2 GHz dual core processor
    * 2 GB system memory
    * 25 GB of free hard drive space
    * Either a DVD drive or a USB port for the installer media
    * Internet access is helpful

    but choose a light-weight environment (how the desktop looks like and what tools are
  preinstalled) for lower requirements (avoid Unity and Gnome).

## best practices

from [Wilson et al. 2014](http://journals.plos.org/plosbiology/article?id=10.1371/journal.pbio.1001745):

1. Write programs for people, not computers.
    a. A program should not require its readers to hold more than a handful of facts in memory at once.
    b. Make names consistent, distinctive, and meaningful.
    c. Make code style and formatting consistent.
2. Let the computer do the work.
    a. Make the computer repeat tasks.
    b. Save recent commands in a file for re-use.
    c. Use a build tool to automate workflows.
3. Make incremental changes.
    a. Work in small steps with frequent feedback and course correction.
    b. Use a version control system.
    c. Put everything that has been created manually in version control.
4. Don't repeat yourself (or others).
    a. Every piece of data must have a single authoritative representation in the system.
    b. Modularize code rather than copying and pasting.
    c. Re-use code instead of rewriting it.
5. Plan for mistakes.
    a. Add assertions to programs to check their operation.
    b. Use an off-the-shelf unit testing library.
    c. Turn bugs into test cases.
    d. Use a symbolic debugger. [interactive program inspector]
6. Optimize software only after it works correctly.
    a. Use a profiler to identify bottlenecks.
    b. Write code in the highest-level language possible.
7. Document design and purpose, not mechanics.
    a. Document interfaces and reasons, not implementations.
    b. Refactor code in preference to explaining how it works.
    c. Embed the documentation for a piece of software in that software. [plus documentation generator]
8. Collaborate.
    a. Use pre-merge code reviews.
    b. Use pair programming when bringing someone new up to speed and when tackling particularly tricky problems.
    c. Use an issue tracking tool.

Python example (from [Bioinformatics Data Skills](http://shop.oreilly.com/product/0636920030157.do))

```Python
EPS = 0.00001 # a small number to use when comparing floating-point values

def add(x, y):
    """Add two things together."""
    return x + y

def test_add():
    """Test that the add() function works for a variety of numeric types."""
    assert(add(2, 3) == 5)
    assert(add(-2, 3) == 1)
    assert(add(-1, -1) == -2)
    assert(abs(add(2.4, 0.1) - 2.5) < EPS)
```

Which best practices are shown here?

## motivating example: data manipulation

From my own work, just last week
[here](https://github.com/frupaul/Test-for-SNAQ-by-Reduced-Data-Sample/):
need to extract various pieces of information from
[result files](https://github.com/frupaul/Test-for-SNAQ-by-Reduced-Data-Sample/tree/master/TestResults)
such as this result file `TestResults/out files/net1_snaq.out`:

```
(ECH3937,((Dic586,DzeEch1591):0.39334426457355115,((((BspEniD312,BsaATCC15712):0.313091357476667,((PcaPC1,(PcaPCC21,WPP1692):1.1457045168568845):0.08725049544490777,(SCRI1043,((PectoSCC3193,Pwa43316):0.858533139429174,#H20:1.2894166676352883::0.022562841930608746):0.09559815984571758):0.4382834061748707):2.5022258780461746):1.4087025649051665,(((GCDA,GBAG):2.2215234026418282,((Pae1,PstDC3000):3.5532626847828177,(VFI114,VchN16961):2.514723407664476):1.3114662776537342):0.41902892411289594)#H20:1.1087410295507665::0.9774371580693912):1.7110632803748822,Dpa2511):1.506271879442207):0.7569747895374156,Ddi453); -Ploglik = 3440.8180547004067
 Dendroscope: (ECH3937,((Dic586,DzeEch1591):0.39334426457355115,((((BspEniD312,BsaATCC15712):0.313091357476667,((PcaPC1,(PcaPCC21,WPP1692):1.1457045168568845):0.08725049544490777,(SCRI1043,((PectoSCC3193,Pwa43316):0.858533139429174,#H20:1.2894166676352883):0.09559815984571758):0.4382834061748707):2.5022258780461746):1.4087025649051665,(((GCDA,GBAG):2.2215234026418282,((Pae1,PstDC3000):3.5532626847828177,(VFI114,VchN16961):2.514723407664476):1.3114662776537342):0.41902892411289594)#H20:1.1087410295507665):1.7110632803748822,Dpa2511):1.506271879442207):0.7569747895374156,Ddi453);
 Elapsed time: 11648.984309726 seconds in 10 successful runs
-------
List of estimated networks for all runs:
 (ECH3937,((Dic586,DzeEch1591):0.39334426457355115,((((BspEniD312,BsaATCC15712):0.313091357476667,((PcaPC1,(PcaPCC21,WPP1692):1.1457045168568845):0.08725049544490777,(SCRI1043,((PectoSCC3193,Pwa43316):0.858533139429174,#H20:1.2894166676352883::0.022562841930608746):0.09559815984571758):0.4382834061748707):2.5022258780461746):1.4087025649051665,(((GCDA,GBAG):2.2215234026418282,((Pae1,PstDC3000):3.5532626847828177,(VFI114,VchN16961):2.514723407664476):1.3114662776537342):0.41902892411289594)#H20:1.1087410295507665::0.9774371580693912):1.7110632803748822,Dpa2511):1.506271879442207):0.7569747895374156,Ddi453);, with -loglik 3440.8180547004067
 (VFI114,VchN16961,(((GBAG,GCDA):2.5245419478720663,(((((Ddi453,ECH3937):0.6047267342464384,(Dic586,DzeEch1591):0.3403176012248513):1.9059445907036108,Dpa2511):2.235321253925316,(BsaATCC15712,((PcaPCC21,(((WPP1692,PcaPC1):4.840121005469344e-81,SCRI1043):1.5701029169080017e-81,#H20:::0.3236896049860076):1.352198753587325e-17):0.05736002957738657,(Pwa43316,PectoSCC3193):1.5238322108331215):2.51329903340477):1.036277594288562):0.0,(BspEniD312)#H20:::0.6763103950139924):1.7190095175499105):1.530594461241091,(Pae1,PstDC3000):4.995850727915352):2.562424468068505);, with -loglik 19269.16345936403
 ((((PectoSCC3193,Pwa43316):3.553610733771546e-15,SCRI1043):0.6474185172594675,(BsaATCC15712,((BspEniD312,((Dpa2511,((DzeEch1591,Dic586):0.40820601146043234,(ECH3937,Ddi453):0.8757625508985754):1.6724150659934216):2.183643473060728,((GBAG,GCDA):3.1451583907332092,((Pae1,PstDC3000):4.509705244575739,(VFI114,VchN16961):2.503235768283856):1.5078417948141687):1.5959002904387598):1.553542222136306):0.0)#H22:1.309389116513644e-15::0.9127687744114756):10.0):0.04995813473096922,(#H22:9.048390395573063e-16::0.08723122558852431,PcaPC1):2.2346481928265355e-18,(PcaPCC21,WPP1692):1.552683790646415);, with -loglik 6890.772908596581
 (VFI114,VchN16961,(((GBAG,GCDA):2.2181192485056758,((Dpa2511,((DzeEch1591,Dic586):0.3916156240560825,(ECH3937,Ddi453):0.7566722278726479):1.5074684429287624):1.747429526882279,((((PectoSCC3193,Pwa43316):0.9501732839655112,SCRI1043):0.4029626050630284,(PcaPCC21,((WPP1692,PcaPC1):0.0)#H20:0.0::0.9722639735503795):0.4027554189070717):2.2721218845628948,(#H20:0.0003038114855103211::0.02773602644962043,(BsaATCC15712,BspEniD312):0.33463588910738173):0.0):1.229804645020795):1.3399682651446452):1.3120033729922145,(Pae1,PstDC3000):3.5600301681303845):2.51818214370805);, with -loglik 5620.196528113887
 (ECH3937,Ddi453,((Dpa2511,((((PcaPC1,(PcaPCC21,WPP1692):1.1429852032707186):0.09620215996092102,(SCRI1043,(Pwa43316,PectoSCC3193):0.9511872865590026):0.42678193109726004):2.1183264683380596,(BspEniD312,BsaATCC15712):0.3384076580894693):1.216974452459672,((GBAG,GCDA):2.194352317062987,(((Pae1,PstDC3000):3.5397209154481932,(VFI114,VchN16961):2.5111214631509617):0.4794476644505572)#H20:0.9467698406332375::0.9884611277426241):1.4240870413695534):1.8521032319317305):1.6037951419775782,(DzeEch1591,(Dic586,#H20:0.05109572126928388::0.011538872257375885):0.4397058985891824):0.3943173907613837):0.7523611860416453);, with -loglik 3793.0442212805383
 (ECH3937,(((((GCDA,GBAG):2.193756843189924,(((VFI114,VchN16961):2.5207381162686846,(Pae1,PstDC3000):3.554378937046041):0.01233174464049745)#H20:1.497720306073061::0.9892992939236428):1.4296038206660144,((BsaATCC15712,BspEniD312):0.3345621679479068,((PcaPC1,(PcaPCC21,WPP1692):1.1449069248382384):0.09309828120666166,(SCRI1043,(Pwa43316,PectoSCC3193):0.9526041635444833):0.42668782398545746):2.118870240664439):1.2167087667210865):1.8440376842575519,Dpa2511):1.5957887532496429,(DzeEch1591,(Dic586,#H20:4.675334247257724::0.010700706076357177):0.0077445203460371655):0.3952345483913463):0.7532993567084834,Ddi453);, with -loglik 3789.1508233434643
 (VFI114,VchN16961,(((GBAG,GCDA):2.212475599100721,(((((DzeEch1591,Dic586):0.3696509747311919,(ECH3937,Ddi453):0.756737928774276):1.5112758720613992,Dpa2511):1.684052571235145,(((((PcaPCC21,WPP1692):1.1469873337860346,PcaPC1):0.09038485166954024,((PectoSCC3193,Pwa43316):0.9555743576515744,SCRI1043):0.4255967306373895):2.113114818846118,(BsaATCC15712,BspEniD312):0.3361897404293803))#H20:2.093864102636834::0.9314636030199334):1.162510627859383,#H20:6.171613091377723e-8::0.06853639698006661):0.36234994766300677):1.310324100987545,(Pae1,PstDC3000):3.6037463809694015):2.5373275910417945);, with -loglik 3821.5271175693492
 ((WPP1692,PcaPCC21):1.0534575224123381,((SCRI1043,(Pwa43316,PectoSCC3193):0.9488036980689983):0.0,#H22:9.992377816436747::0.3235310400449231):0.6620187375621733,(PcaPC1,(((BspEniD312,BsaATCC15712):0.33343475782982623,((Dpa2511,((ECH3937,Ddi453):0.7530463904900576,(DzeEch1591,Dic586):0.38997603702161565):1.5066595347385965):1.7486516843928388,((GCDA,GBAG):2.224283684607174,((VchN16961,VFI114):2.5102867402698825,(Pae1,PstDC3000):3.5487706559153787):1.3130259481090099):1.3407781540044517):1.2265176226740198):1.9732658721762155)#H22:0.2794988181403773::0.6764689599550768):0.22661513908037734);, with -loglik 3770.6791156388645
 (((Dpa2511,(((BspEniD312,BsaATCC15712):0.3346621630454019,((PcaPC1,(WPP1692,PcaPCC21):1.1442123144680205):0.09306634431412385,((Pwa43316,PectoSCC3193):0.9526331443229515,SCRI1043):0.4271180729130922):2.1187983635203205):1.216970952460887,((GBAG,GCDA):2.1954878077368796,(((PstDC3000,Pae1):3.55278287210519,(VchN16961,VFI114):2.5204195787957584):0.0)#H22:1.5048013291163698::0.9897342850994104):1.4267386398600983):1.8421285001624097):1.597605850292273,(Ddi453,ECH3937):0.7532176353973834):0.3967618687594186,DzeEch1591,(Dic586,#H22:0.006261881582570027::0.010265714900589622):0.35723839150575165);, with -loglik 3786.7201402041833
 (VFI114,VchN16961,((Pae1,PstDC3000):3.559990458370163,((GCDA,GBAG):2.218012119547241,(((BsaATCC15712,BspEniD312):0.33455337500466675,(((SCRI1043,(Pwa43316,(PectoSCC3193)#H22:::0.9715644289314767):1.0967310149501057):0.45575302685090346,(PcaPC1,(WPP1692,PcaPCC21):1.1421245266445263):0.08234532616324368):2.210036261995772,#H22:::0.028435571068523364):8.160583229878246e-6):1.2275791123554678,(((ECH3937,Ddi453):0.7567033876290241,(DzeEch1591,Dic586):0.3916330806387961):1.5074252624245137,Dpa2511):1.7474327640290075):1.3399421382797148):1.3119914628188931):2.5181349183423207);, with -loglik 3864.1900537877186
-------
```

or as this other result file `TestResults/out files/timetest1_snaq.out`:

```
(ECH3937,Ddi453,((Dic586,DzeEch1591):0.39151452022020755,(Dpa2511,(((BsaATCC15712,BspEniD312):0.31165264651122426,((PcaPC1,(PcaPCC21,WPP1692):1.144025891196133):0.0876790364165445,(((PectoSCC3193,Pwa43316):0.9529701731377197,SCRI1043):0.0632647451890301,#H20:8.251812487790279e-7::0.023694403794416646):0.37365021164620515):2.5071408957817876):1.4168426104118295,(((GCDA,GBAG):2.21912632231476,((Pae1,PstDC3000):3.565361799130726,(VFI114,VchN16961):2.518277890640175):1.3136037135425378):0.42011126229987183)#H20:1.1184877095177088::0.9763055962055833):1.7090991861969702):1.5074073219469928):0.7563231659538783); -Ploglik = 3443.958828187268
 Dendroscope: (ECH3937,Ddi453,((Dic586,DzeEch1591):0.39151452022020755,(Dpa2511,(((BsaATCC15712,BspEniD312):0.31165264651122426,((PcaPC1,(PcaPCC21,WPP1692):1.144025891196133):0.0876790364165445,(((PectoSCC3193,Pwa43316):0.9529701731377197,SCRI1043):0.0632647451890301,#H20:8.251812487790279e-7):0.37365021164620515):2.5071408957817876):1.4168426104118295,(((GCDA,GBAG):2.21912632231476,((Pae1,PstDC3000):3.565361799130726,(VFI114,VchN16961):2.518277890640175):1.3136037135425378):0.42011126229987183)#H20:1.1184877095177088):1.7090991861969702):1.5074073219469928):0.7563231659538783);
 Elapsed time: 16688.01510346 seconds in 10 successful runs
-------
List of estimated networks for all runs:
 (ECH3937,Ddi453,((Dic586,DzeEch1591):0.3916223389169537,(Dpa2511,(((BsaATCC15712,BspEniD312):0.3128260626881626,(PcaPC1,((SCRI1043,((PectoSCC3193,Pwa43316):0.6977437173196366,#H20:0.00022822386439850124::0.021630732814455052):0.26322537066459134):0.4236629591108912,(PcaPCC21,WPP1692):1.1890466239510304):0.06863934472914392):2.4773007202770576):1.4053376341094526,(((GCDA,GBAG):2.219164745964012,((PstDC3000,Pae1):3.5602401877744643,(VFI114,VchN16961):2.5183186557471093):1.3135338210943872):0.41032277572157794)#H20:1.1138891991703652::0.978369267185545):1.7118998331253241):1.5069910040504322):0.7566818252183738);, with -loglik 3455.845945853218
 (VFI114,VchN16961,((((Dpa2511,((ECH3937,(Ddi453)#H20:::0.9940317642071066):0.7909101959471819,(Dic586,DzeEch1591):0.3822022037813626):1.5729758170682475):1.7827505483353387,((BsaATCC15712,BspEniD312):0.3337206942159198,(((PectoSCC3193,Pwa43316):0.9523881593998712,SCRI1043):0.4263694627890546,((PcaPCC21,WPP1692):1.1443644073470125,(PcaPC1,#H20:::0.005968235792893377):1.459335224099927):0.0934172793433709):2.1361816669883664):1.2369595960158875):1.3378100318296535,(GCDA,GBAG):2.2181613686042736):1.3118574211203706,(Pae1,PstDC3000):3.5620157597292295):2.5171717848786104);, with -loglik 3860.533441026289
 (VFI114,VchN16961,(((GCDA,GBAG):2.2180451724547128,((Dpa2511,((ECH3937,Ddi453):0.7470303514949284,(Dic586,(DzeEch1591)#H20:::0.994771261343114):0.4083904741512361):1.5647832090680156):1.7807472197470362,((BsaATCC15712,BspEniD312):0.33353223019842365,((SCRI1043,(PectoSCC3193,(Pwa43316,#H20:::0.005228738656885995):0.10184589942412053):0.9563893187362575):0.4295184565038544,(PcaPC1,(PcaPCC21,WPP1692):1.1447460190010872):0.09241025146502349):2.138754739951621):1.236388839988299):1.3378875879930074):1.3119542771562265,(Pae1,PstDC3000):3.559964423795921):2.5181376787449845);, with -loglik 3859.115780423511
 (VFI114,(((GCDA,GBAG):2.2116293771387436,(((((PectoSCC3193,Pwa43316):0.9451763936198495,SCRI1043):0.4276126604275862,(PcaPC1,(PcaPCC21,WPP1692):1.1442515087738958):0.09257741297938635):2.1175503858573657,(BsaATCC15712,BspEniD312):0.3358694731956836):1.226419818151741,(Dpa2511,((ECH3937,Ddi453):0.7537967494400539,(Dic586,DzeEch1591):0.3918148459412738):1.5051842841458647):1.7498955131059477):1.3418708024902517):1.212458369009057,((PstDC3000,Pae1):3.647142996017561)#H20:0.0::0.9175175496088633):4.44195280505641,(VchN16961,#H20:0.003097631251670284::0.08248245039113664):0.12357098930534696);, with -loglik 3880.752407454445
 (Pwa43316,(SCRI1043,((PcaPC1,(PcaPCC21,WPP1692):1.1334868472726147):0.015529070014493173,(((BsaATCC15712,BspEniD312):0.334192507684605,((Dpa2511,((ECH3937,Ddi453):0.7637187370250744,(Dic586,DzeEch1591):0.39454426004379634):1.5004547626395341):1.7516952494614373,((GCDA,GBAG):2.1979948685600146,((Pae1,PstDC3000):3.565208708518564,(VFI114,VchN16961):2.5451573307659827):1.3136886241612056):1.3414962402868322):1.2303311675499125):0.9886797414707493)#H20:2.4246357026184118::0.9072559440190524):0.5775689462229046):1.2184942668958334,(PectoSCC3193,#H20:0.012726416987990588::0.09274405598094757):0.07370961607455255);, with -loglik 3811.554199979079
 (VFI114,VchN16961,(((GCDA,GBAG):2.213866261637645,(((BsaATCC15712,BspEniD312):0.3357443180077425,(((PectoSCC3193,Pwa43316):0.952020727134612,SCRI1043):0.4261925401517078,(PcaPC1,(PcaPCC21,WPP1692):1.144072670650649):0.0941130880421839):2.119205380854781):1.2182342965189237,(Dpa2511,(((ECH3937,Ddi453):0.7574919898685711,(Dic586,DzeEch1591):0.3908116183920976):0.03198033167351987)#H20:1.763212262416741::0.9924168215315269):1.8874765424136433):1.385918971638839):1.3581769509836341,((Pae1,PstDC3000):0.45961881403585547,#H20:0.0017264888860279942::0.007583178468473104):3.378616184478208):2.5098725180135033);, with -loglik 3777.823939751652
 (ECH3937,Ddi453,((Dic586,DzeEch1591):0.39151452022020755,(Dpa2511,(((BsaATCC15712,BspEniD312):0.31165264651122426,((PcaPC1,(PcaPCC21,WPP1692):1.144025891196133):0.0876790364165445,(((PectoSCC3193,Pwa43316):0.9529701731377197,SCRI1043):0.0632647451890301,#H20:8.251812487790279e-7::0.023694403794416646):0.37365021164620515):2.5071408957817876):1.4168426104118295,(((GCDA,GBAG):2.21912632231476,((Pae1,PstDC3000):3.565361799130726,(VFI114,VchN16961):2.518277890640175):1.3136037135425378):0.42011126229987183)#H20:1.1184877095177088::0.9763055962055833):1.7090991861969702):1.5074073219469928):0.7563231659538783);, with -loglik 3443.958828187268
 (VFI114,VchN16961,(((GCDA,GBAG):2.219460035105914,((Dpa2511,(((ECH3937,Ddi453):0.75630888011499,(Dic586,DzeEch1591):0.3919875100972792):1.380739910125236,#H20:::0.010247944712692417):0.1267063939441514):1.7556400603164963,(((((Pwa43316,(PectoSCC3193)#H20:::0.9897520552873076):1.0203848918799054,SCRI1043):0.4442368954687679,(PcaPC1,(PcaPCC21,WPP1692):1.1431289589640605):0.08882274906772937):2.201511576092636,BspEniD312):0.0,BsaATCC15712):1.2645226824391311):1.3377070859820448):1.3118900769122575,(Pae1,PstDC3000):3.5515426626571953):2.515647137851658);, with -loglik 4357.230840522077
 (VFI114,VchN16961,(((GCDA,GBAG):2.2183132507826904,(((Dpa2511,((ECH3937,Ddi453):0.7567273128941133,(Dic586,DzeEch1591):0.39151150339747):1.5071812690507407):1.721566100927654,((BsaATCC15712,BspEniD312):0.2897689849762642,((((PectoSCC3193,Pwa43316):0.9525864229583921,SCRI1043):0.42692988906485313,(PcaPC1,(PcaPCC21,WPP1692):1.1449532226110368):0.09304539465538224):0.6838826946843389)#H20:2.3273420820899653::0.969250753611784):1.4404006054681064):1.4464278717313024,#H20:1.2813081230801888::0.03074924638821598):0.0):1.3120148804021463,(Pae1,PstDC3000):3.5615515442678705):2.5179082718561263);, with -loglik 3465.6935439833105
 (VFI114,VchN16961,(((GCDA,GBAG):2.218398156745566,((Dpa2511,((ECH3937,Ddi453):0.7565245329816281,((Dic586,DzeEch1591):0.3074760295098175,#H20:::0.01057544767069923):0.08439636130940043):1.5263962399612987):1.7676594274287591,((BsaATCC15712,(BspEniD312)#H20:::0.9894245523293008):0.35068273430616315,(((PectoSCC3193,Pwa43316):0.9522720970942834,SCRI1043):0.42662648477461573,(PcaPC1,(PcaPCC21,WPP1692):1.1446634305897092):0.0930095443582278):2.108996812337079):1.2518446488144161):1.3376850915400154):1.3120369837552903,(Pae1,PstDC3000):3.5616003865640833):2.518746338077192);, with -loglik 3892.1805493222896
-------
```

and then combine information from each pair of files into a summary table like this:

```
,Hmax,Number of Runs,Nfails,ftolAbs,ftolRel,xtolAbs,xtolRel,The First Seed,Best Seed,Number of Log-lik under 3460,Number of Log-lik under 3450,Number of Log-lik under 3440,Log-lik,Best Run Time,Total CPU Time
Original Try,1,10,100,0.000001,0.00001,0.0001,0.001,3322,3322,1,1,0,3440.8181,16000,150000
Best Starting Tree,0,1,100,0.000001,0.00001,0.0001,0.001,66077,66077,0,0,0,3917.9621,10085,10085
Best Model,1,10,100,0.000001,0.00001,0.0001,0.001,36252,14351,4,4,2,3439.7454,12012,88579.31
Timetest1,1,10,10,0.000001,0.00001,0.0001,0.001,30312,81138,2,1,0,3443.9588,1598,16688.02
Timetest2,1,10,25,0.000001,0.00001,0.0001,0.001,28669,28669,4,1,0,3445.5654,2607,37137.96
Timetest6,1,10,25,0.000001,0.00001,0.0001,0.001,14351,14351,4,3,3,3439.8319,4940,39287.8
Timetest3,1,10,100,0.1,0.1,0.0001,0.001,66086,86464,0,0,0,3579.9085,2239,12630.99
Timetest4,1,10,100,0.01,0.01,0.0001,0.001,62366,62366,0,0,0,3471.5565,3526,21942.35
Timetest5,1,10,100,0.005,0.005,0.0001,0.001,3888,25572,2,1,0,3443.9379,3746,23949.38
Timetest7,1,10,100,0.005,0.005,0.0001,0.001,14351,14351,5,5,0,3442.2165,2351,29822.15
Timetest8,1,10,100,0.000001,0.00001,0.001,0.1,15989,68739,3,2,1,3439.8619,2091,51589.34
Timetest9,1,10,50,0.0001,0.00001,0.0001,0.001,45123,97830,1,1,0,3450.3233,1772,34831.47
Timetest10,1,10,50,0.00001,0.0001,0.0001,0.001,37792,44249,0,0,0,3462.3852,3842,29394.46
Timetest11,1,10,50,0.000005,0.00001,0.0001,0.001,25765,78407,2,2,0,3444.0098,12200,67926.5
Timetest12,1,10,50,0.000001,0.00001,0.01,0.1,39416,74437,4,0,0,3452.1753,1790,18935.63
Timetest13,1,10,100,0.00001,0.00001,0.01,0.1,38112,82736,3,1,1,3439.7857,3131,31456.99
```

Can you notice one "best practice" not followed in this project?

## introduction to the Unix shell

GUI (graphical user interface): easy but not reproducible.  
CLI (command line interface) or REPL (read-evaluate-print loop): steep learning curve but
reproducible and powerful.  
The shell is an incredibly powerful tool:

* Gary Bernhardt:
 [Unix is like a chainsaw](http://confreaks.tv/videos/cascadiaruby2011-the-unix-chainsaw).
 Can kill trees, and people.
 The Unix shell can do great things, but power comes with danger: it's unsafe!
* example:

deletes all large alignment files `aligned-reads_1` to `aligned-reads_1000`
in old temporary directory `tmp-data`:
```
> rm -rf tmp-data/aligned-reads*
```

deletes your entire current directory (ouch!):
```
> rm -rf tmp-data/aligned-reads *
rm: tmp-data/aligned-reads: No such file or directory
```

watch shell script example from Gary Bernhardt's
[talk](http://confreaks.tv/videos/cascadiaruby2011-the-unix-chainsaw) at 10:18-12:14

#### modularity

    This is the Unix philosophy: Write programs that do one thing and do it well.
    Write programs to work together. Write programs to handle text streams,
    because that is a universal interface.
    —- Doug McIlory

* modularity
* pipes: STDIN --> myprogram --> STDOUT

Advantages to modularity:

* easier to spot errors, and fix them
* experiments with alternative choices at one step in the pipeline
* choose appropriate tool for each step, e.g. C++ -> Python -> R
* modules possible reusable for other tasks later on

#### text streams

to process a stream of data rather than holding it all in memory.

Example: concatenate two data files.
Open both in editor, copy one and paste into the other?

* may not have enough memory
* manual operation: error-prone and not reproducible.

Instead: print the files's content to *standard output* stream and
redirect this stream from our terminal to the file we wish to save the combined results to.

```
cd bds-files/chapter-03-remedial-unix/
cat tb1-protein.fasta
cat tga1-protein.fasta
cat tb1-protein.fasta tga1-protein.fasta
cat tb1-protein.fasta tga1-protein.fasta > zea-proteins.fasta
ls -lrt
```
`-l`: in list format  
`-r`: in reverse order  
`-t`: ordered by time

data processed without storing huge amounts of data in our computers' memory: very efficient

## let's get started: the bash shell

```shell
echo $SHELL
```
quick count: shell versus terminal? absolute versus relative path? `grep`?

We will follow the
[software carpentry introduction](http://swcarpentry.github.io/shell-novice/).
Click on 'setup' to download the data.

## next time:

Text editor
Typing skills
Set up and manage an analysis project
